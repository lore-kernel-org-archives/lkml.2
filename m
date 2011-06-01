Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590Ab1FAFeS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 01:34:18 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:43963 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab1FAFeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 01:34:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Cj0TgRxsOOTLtyBimZR/gYa/JKkPkZKUE1AIzOaXX0ZVq83VQhf8xWtxqo50Ode8oJ
         OyRE2AUmqc6iEWcEhJI+jNId9EGdcrMPaBfG0LV0bsswCMT5PEwZCTC8yf2qrlfte3eU
         usMsfSdhpbc2toyKrAlXUCMolm2wFYlkhTYUM=
Date: Wed, 1 Jun 2011 14:34:08 +0900
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Denys Vlasenko <vda.linux@googlemail.com>, indan@nul.nu,
        bdonlan@gmail.com, linux-kernel@vger.kernel.org,
        jan.kratochvil@redhat.com, akpm@linux-foundation.org
Subject: Re: [PATCH 03/10] ptrace: implement PTRACE_SEIZE
Message-ID: <20110601053408.GD23067@mtj.dyndns.org>
References: <20110518095539.GU20624@htj.dyndns.org>
 <20110523124314.GA7232@redhat.com>
 <20110524102834.GC10334@htj.dyndns.org>
 <20110525182919.GB16575@redhat.com>
 <20110526091401.GD9715@htj.dyndns.org>
 <20110526150150.GD12525@redhat.com>
 <20110527182121.GA3212@mtj.dyndns.org>
 <20110530192255.GB20616@redhat.com>
 <BANLkTimupSd774N-VBoswOj+Dza=5ofvWQ@mail.gmail.com>
 <20110531190809.GA20691@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110531190809.GA20691@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.

On Tue, May 31, 2011 at 09:08:09PM +0200, Oleg Nesterov wrote:
> Speaking of this particular problem, it is really annoying. The leader
> exits, and it even notifies the tracer. For what? waitpid() returns 0
> or hangs depending on WNOHANG, any ptrace() request fails with ESRCH.

Hmm... can't we just allow PTRACE_DETACH after PTRACE_EVENT_EXIT is
reported?  It doesn't involve changes to any visible behavior (other
than allowing DETACH of course) and we don't lose anything.  Haven't
really thought about the implementation but I don't think this would
be too difficult.

Thanks.

-- 
tejun
