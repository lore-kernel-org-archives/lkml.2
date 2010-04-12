Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105Ab0DLVdi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 17:33:38 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:60891 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426Ab0DLVdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 17:33:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HXJaNV9JP6Rfh9ZgzMV6n7tpdFZWn909vebcL+puucjlTGOflHtblvd67ED2oTEC56
         hRa+adpo9nE2+99Ww/abc/hlFxDssOB6YQtAnFaQ6QHPg+h84rQQ6VFmTmBVwypOc+8y
         flPUTl0FLofzdxfw+0Gk31yJH89f+/1eUgt2I=
Date: Mon, 12 Apr 2010 23:33:27 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-fbdev@vger.kernel.org, nouveau@lists.freedesktop.org,
       LKML <linux-kernel@vger.kernel.org>,
       dri-devel <dri-devel@lists.freedesktop.org>,
       Peter Jones <pjones@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] fbmem: fix aperture overlapping check
Message-ID: <20100412213327.GA4463@joi.lan>
References: <1270929334-3742-1-git-send-email-marcin.slusarz@gmail.com>
 <1271030068.3554.1.camel@localhost>
 <20100412113438.GB2789@joi.lan>
 <1271104101.5726.3.camel@t60prh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271104101.5726.3.camel@t60prh>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 13, 2010 at 06:28:21AM +1000, Dave Airlie wrote:
> On Mon, 2010-04-12 at 13:34 +0200, Marcin Slusarz wrote:
> > On Mon, Apr 12, 2010 at 09:54:28AM +1000, Dave Airlie wrote:
> > > On Sat, 2010-04-10 at 21:55 +0200, marcin.slusarz@gmail.com wrote:
> > > > fb_do_apertures_overlap is returning wrong value when one aperture
> > > > is completely whithin the other. Add generic ranges_overlap macro
> > > > (probably kernel.h candidate) and use it here.
> > > > 
> > > 
> > > That doesn't seem right.
> > > 
> > > The rules are:
> > > 
> > > the generic aperture has to be equal or smaller than the hw aperture,
> > > otherwise the generic driver will be trashing random hw pieces on the
> > > machine.
> 
> > Why "it has to"? Why generic aperture can't start one byte before hw?
> 
> Think about how it works a bit more, the answer is obvious.
> 
> The hw aperture is defined by the actual hardware, not by the OS or my
> code. The PCI apertures are well defined. Now for a generic driver like
> vesa or offb to access the hardware it needs to access the hw apertures.
> 
> It can't go accessing one byte before the hw aperture, as that will
> crash the machine, or write to some other devices hw.

Ok, thanks for explanation. I'll drop this patch and rebase the others.

> > > So with that in mind, the check makes sure the generic aperture starts
> > > somewhere inside the hw aperture, which the test clearly gets right.
> > 
> > So your only objection is that it's impossible with the current code?
> > 
> > > Have you got a pointer to a machine where it fails?
> > 
> > No, it failed with an artifical test while I was working on vga16fb handoff
> > (unfinished).
> 
> You won't be able to make this work for vga16fb from what I can see
> since it access 0xa000 directly, not via any of the defined apertures
> that vesafb/offb use. vga16fb will need a different approach I suspect.

Yeah, there's an idea to claim 0xa0000 as an aperture of vga16fb and then
do the same in KMS driver but only if it's the primary card. 
(You hinted to use SHADOW resource bit to check whether card is primary)
I think I'll try this approach soon.

Marcin

