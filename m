Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756464Ab1ENK6t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 06:58:49 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35082 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755723Ab1ENK46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 06:56:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fnnTM2cYmghaUQlrYLFfq6B00KlUhNBS3Z8oJAhwmVfOKshdEfValMZCFcXyUgvDLI
         4jJJpby9oigM6AweKRZYRjNqkmTYGrw1Qji0j63AEbNK4sXKqXfUoD5w7t1Z29BRSG1p
         OyIdZUKdxC9glCZMvYVwucqSmG7/3ayQSON9E=
Date: Sat, 14 May 2011 12:56:53 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 09/11] job control: reorganize wait_task_stopped()
Message-ID: <20110514105653.GC23665@htj.dyndns.org>
References: <1304869745-1073-10-git-send-email-tj@kernel.org>
 <20110511154854.GB23688@redhat.com>
 <20110511192902.GC24245@mtj.dyndns.org>
 <20110512154247.GC18599@redhat.com>
 <20110512160253.GK1030@htj.dyndns.org>
 <20110512172506.GA23033@redhat.com>
 <20110512173228.GO1030@htj.dyndns.org>
 <20110512183326.GA26042@redhat.com>
 <20110513084611.GB6500@htj.dyndns.org>
 <20110513172117.GA30243@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110513172117.GA30243@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.

On Fri, May 13, 2011 at 07:21:17PM +0200, Oleg Nesterov wrote:
> We already checked ->exit_state != ZOMBIE, and we are holding tasklist.
> The child can't exit. I mean, it can't change its ->exit_state.
> 
> However, SIGKILL can clear SIGNAL_STOP_STOPPED, and we can "miss" it.
> But this looks correct, the child is no longer stopped but it is still
> not dead. So I think in this case wait(WNOHANG | WEXITED | WSTOPPED)
> can fail, notabug.

Hmmm... I don't know.

> OTOH, perhaps SIGKILL should set SIGNAL_STOP_CONTINUED in this case?
> And keep it if it was already set.

I'd rather avoid that.  First of all, it's an extreme corner case and
I think introducing an extra state transition there is more likely to
cause trouble than helping anything.  It might be theoretically
correct but there's no reason to introduce that at this point.  If at
all possible, I think it would be better to make it either see STOPPED
or EXIT.

Thanks.

-- 
tejun
