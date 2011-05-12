Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757959Ab1ELQDA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 12:03:00 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44421 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756674Ab1ELQC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 12:02:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FXU1KGNj75XMFwmH/+BR1wt7XlTVoZaqsNLG1h6vRBqVb7IsKl3YmeYG01Z/idpzXE
         Z1NpEf/MQ+xTakz2YrFuYWzBCt63kzKjHTPNpjoRqQEsSxx8dLQWGTi2DNDLDwjFD4Iz
         nA+O8IfsVYas9380G1e4fZrp7s5FnRLB8tobI=
Date: Thu, 12 May 2011 18:02:53 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 09/11] job control: reorganize wait_task_stopped()
Message-ID: <20110512160253.GK1030@htj.dyndns.org>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
 <1304869745-1073-10-git-send-email-tj@kernel.org>
 <20110511154854.GB23688@redhat.com>
 <20110511192902.GC24245@mtj.dyndns.org>
 <20110512154247.GC18599@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110512154247.GC18599@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, May 12, 2011 at 05:42:47PM +0200, Oleg Nesterov wrote:
> On 05/11, Tejun Heo wrote:
> >
> > > Can't we push this patch ahead of these changes? I can merge it into
> > > ptrace branch.
> >
> > It doesn't really fix the problem tho.  The whole thing is full of
> > holes
> 
> Hmm. Could you explain?  (unless you mean ptrace holes)

I meant other cases, RUNNING -> STOPPED and EXIT_* transitions.
Sleeping wait(2) is reliable without grabbing siglock thanks to
setting TASK_INTERRUPTIBLE on start and events waking up the waiter
after updating the state, so wait(2) is guaranteed to check the states
at least once after change actually has happened.

WNOHANG disables that mechanism.  We probably can add another set of
memory barrier hackery to fix that, but that's gonna be ugly.

Thanks.

-- 
tejun
