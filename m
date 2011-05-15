Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760186Ab1EOR2R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 13:28:17 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50790 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab1EOR2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 13:28:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cEhiFer/o9E5EsIR1FI+fVGsMj1t77yZComYe4kl0SRQ1G8T1DKjgEuRBS17sXvJKO
         F1QGTN6c7ixczARlkmIxzeMWCElxDaSaHlxev4zqDtgk5fez7HA3EiozahNRpWjkbSKH
         ulFC1Gt2f7y5qvwV+iNLnf8D0I9uFJPo7ICqY=
Date: Sun, 15 May 2011 19:28:11 +0200
From: Tejun Heo <tj@kernel.org>
To: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: oleg@redhat.com, vda.linux@googlemail.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu
Subject: Re: getter PTRACE_GETSIGINFO should not modify anything  [Re:
 [PATCH 11/11] ptrace: implement group stop notification for ptracer]
Message-ID: <20110515172811.GM23665@htj.dyndns.org>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
 <1304869745-1073-12-git-send-email-tj@kernel.org>
 <20110515140232.GB31855@host1.jankratochvil.net>
 <20110515142827.GF23665@htj.dyndns.org>
 <20110515171748.GA25216@host1.jankratochvil.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110515171748.GA25216@host1.jankratochvil.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sun, May 15, 2011 at 07:17:48PM +0200, Jan Kratochvil wrote:
> just a general point for all the mails:
> 
> On Sun, 15 May 2011 16:28:27 +0200, Tejun Heo wrote:
> > Even for LD_PRELOAD, it can simply keep scheduling INTERRUPT
> > until the application calls the wrapped GETSIGINFO when it detects the
> > stopped state has changed.  It can be easily done from userland.
> 
> I thought the goal is to simplify the interface, not making it even more
> complicated.

It's a balancing act.  The primary goal is to make it _functional_ as
the current ptrace is outright broken in many places.  The second, at
least for me, is not deviating from the current behavior too much
unless required by the first goal or not doing so is extremely silly.

It would be nice to have a concise pretty interface but we already
have this ugly thing which works half ways and it's not like the
current users can drop support for old kernels quickly, so I don't see
a lot of benefit in making changes for prettiness, but please note
that I'm not trying to make it any more complicated.  It won't be
pretty but won't be more complicated than now either.

After all, this is a pretty low level API which only a handful are
gonna use.  If it involves some ugliness to use it, as long as no
functionality is compromised, I would go that way than introducing
larger behavior difference from the current one.

That said, give me strong enough reasons, I'll be happy to change the
behavior.

And, thanks a lot for your comments.  I really appreciate them.

-- 
tejun
