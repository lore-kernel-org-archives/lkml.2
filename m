Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326Ab1AZWEQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 17:04:16 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47798 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155Ab1AZWEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 17:04:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=N5SRgDhIjrAGTYfzbR7Swg7/IongYmgv5z1BTiPfXxZZXIT1CINZ5cfaOSJRJNjMYA
         zWWhKTlgFUKT+4n7c6VXW3NewTYbilB7ZP04lAtCnT71R9ojDbNedDmeOTAk9vpmN6Pa
         ZgAqxpthJQbcS9HmR/Yd9Hh+Hy5jNpnkWBeNU=
Date: Wed, 26 Jan 2011 14:04:07 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mark Lord <kernel@teksavvy.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils ?
Message-ID: <20110126220407.GA29484@core.coreip.homeip.net>
References: <4D3F4D11.9040302@teksavvy.com>
 <20110125232914.GA20130@core.coreip.homeip.net>
 <20110126020003.GA23085@core.coreip.homeip.net>
 <4D403855.4050706@teksavvy.com>
 <4D405A9D.4070607@redhat.com>
 <4D4076FD.6070207@teksavvy.com>
 <20110126194127.GE29268@core.coreip.homeip.net>
 <4D407A46.4080407@teksavvy.com>
 <20110126195011.GF29268@core.coreip.homeip.net>
 <4D4094F3.3020607@teksavvy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D4094F3.3020607@teksavvy.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 04:41:07PM -0500, Mark Lord wrote:
> On 11-01-26 02:50 PM, Dmitry Torokhov wrote:
> > On Wed, Jan 26, 2011 at 02:47:18PM -0500, Mark Lord wrote:
> >> On 11-01-26 02:41 PM, Dmitry Torokhov wrote:
> >>>
> >>> I do not consider lsinput refusing to work a regression.
> >>
> >> Obviously, since you don't use that tool.
> >> Those of us who do use it see this as broken userspace compatibility.
> >>
> >> Who the hell reviews this crap, anyway?
> >> Code like that should never have made it upstream in the first place.
> >>
> > 
> > You are more than welcome spend more time on reviews.
> 
> Somehow I detect a totally lack of sincerity there.

No, not really. If we known about Ubuntu's employ of such utility before
we'd try to come up with workaround or updated the utility proactively
so user-visible changes would be limited.

> 
> But thanks for fixing the worst of this regression, at least.
> 
> Perhaps you might think about eventually fixing the bad use of -EINVAL
> in future revisions.  One way perhaps to approach that, would be to begin
> fixing it internally,

Yes, that is on my lest (unless somebody beats me to it). Won't help
with the older kernels though, unfortunately.

> but still returning the same things from the actual
> f_ops->ioctl() routine.

Not sure if this is needed.

> 
> Then eventually provide new ioctl numbers which return the correct -ENOTTY
> (or whatever is best there), rather than converting to -EVINAL at the interface.
> Then a nice multi-year overlap, with a scheduled removal of the old codes some day.
> 
> Then the input subsystem would work more like most other subsystems,
> and make userspace programming simpler and easier to "get correct".

I do not believe that such characterization is called for. We did fix
the breakage that was ABI breakage. The version issue is different. If
we go by what you say _none_ of the versions anywhere can be changed
ever because there might be a program that does not expect new version.

-- 
Dmitry
