Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989Ab1FBFB2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 01:01:28 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:32972 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab1FBFB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 01:01:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vvlnxg8vIvcoVfaxgOX8Z2vW+m9qH0+M+F9l1hWUerfS3OcWQuJO+apIl+HcUmbMbF
         /0VQR1cImoW/AjtmPnbMKxpSXgKI8aGs8hR52h56nmky8grxEOJdeb4/AkjY40ufL4EY
         fP9pg++c0+3rwhfs/1v4LkpkzEU9kRAVXW7xs=
Date: Thu, 2 Jun 2011 14:01:20 +0900
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Denys Vlasenko <vda.linux@googlemail.com>, indan@nul.nu,
        bdonlan@gmail.com, linux-kernel@vger.kernel.org,
        jan.kratochvil@redhat.com, akpm@linux-foundation.org
Subject: Re: [PATCH 03/10] ptrace: implement PTRACE_SEIZE
Message-ID: <20110602050120.GA17434@mtj.dyndns.org>
References: <20110524102834.GC10334@htj.dyndns.org>
 <20110525182919.GB16575@redhat.com>
 <20110526091401.GD9715@htj.dyndns.org>
 <20110526150150.GD12525@redhat.com>
 <20110527182121.GA3212@mtj.dyndns.org>
 <20110530192255.GB20616@redhat.com>
 <BANLkTimupSd774N-VBoswOj+Dza=5ofvWQ@mail.gmail.com>
 <20110531190809.GA20691@redhat.com>
 <20110601053408.GD23067@mtj.dyndns.org>
 <20110601200807.GB9981@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110601200807.GB9981@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Wed, Jun 01, 2011 at 10:08:07PM +0200, Oleg Nesterov wrote:
> > Hmm... can't we just allow PTRACE_DETACH after PTRACE_EVENT_EXIT is
> > reported?
> 
> Confused. PTRACE_DETACH surely works if the tracee reports EVENT_EXIT...
> Could you explain what you meant?

Right, I briefly forgot it's already a ptrace stop and was thinking
about using PTRACE_EVENT_EXIT as the event notification point.
Anyways, back to the topic.

Maybe I misunderstood the problem but wasn't the problem about not
being able to wait for the exit of a leader thread and detach it?  We
have reliable (sans exec but that's a different story) exit
notification with EVENT_EXIT which even reports the exit_code, so I
don't see what the problem is.  What am I missing?

Thanks.

-- 
tejun
