Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541Ab1GGJ2h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 05:28:37 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35354 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104Ab1GGJ2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 05:28:35 -0400
Date: Thu, 7 Jul 2011 10:28:25 +0100
From: Dave Martin <dave.martin@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Simon Glass <sjg@chromium.org>, Olof Johansson <olof@lixom.net>,
        Stephen Boyd <sboyd@codeaurora.org>,
        anish singh <anish198519851985@gmail.com>,
        lak <linux-arm-kernel@lists.infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Joe Perches <joe@perches.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Alexander Shishkin <virtuoso@slind.org>,
        Phil Carmody <ext-phil.2.carmody@nokia.com>,
        Rabin Vincent <rabin@rab.in>, lk <linux-kernel@vger.kernel.org>,
        Omar Ramirez Luna <omar.ramirez@ti.com>
Subject: Re: [PATCH v4] ARM: Use generic BUG() handler
Message-ID: <20110707092802.GA2486@arm.com>
References: <1302822031-6752-1-git-send-email-sjg@chromium.org>
 <4DA7A914.5020804@codeaurora.org>
 <BANLkTikcY-xzjd0W77UfWWoO8ibjKNXQGg@mail.gmail.com>
 <BANLkTin_TpzdQS96SPKUNye6vb2b55Qc4A@mail.gmail.com>
 <143ea9b1bb96e613d534caa7cb3a1e2d.squirrel@www.codeaurora.org>
 <20110426014741.GB28721@quad.lixom.net>
 <BANLkTikHT2E=76jMLbzmQm_CiUw8rA3cCA@mail.gmail.com>
 <20110706200607.GS8286@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110706200607.GS8286@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 06, 2011 at 09:06:07PM +0100, Russell King - ARM Linux wrote:
> On Thu, May 19, 2011 at 10:24:31PM -0700, Simon Glass wrote:
> > On Mon, Apr 25, 2011 at 6:47 PM, Olof Johansson <olof@lixom.net> wrote:
> > > On Wed, Apr 20, 2011 at 11:01:59AM -0700, Stephen Boyd wrote:
> > >
> > >> It's here:
> > >> http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=6885/1
> > >>
> > >> I imagine it will be added when/if Russell picks it up. Sadly it
> > >> increases the LOC in ARM so Simon might need to really
> > >> sell it to get it merged.
> > >
> > > It's core code though, and the concern today is not with ARM core code
> > > as much as with the various platforms that are growing seemingly without
> > > upper bounds.
> > 
> > Hi,
> > 
> > Can anyone advise please what happens next with this patch? So far I
> > have posted it to the list, it has been reviewed on the list and I
> > have put it into the patch system. What is the next step please to get
> > this into the kernel?
> 
> Sorry, I've finally got back to looking at this.
> 
> +               ".pushsection .rodata.str, \"aMS\", 1\n"        \
> 
> According to my gas manual:
> 
> | 7.88 `.pushsection NAME [, SUBSECTION] [, "FLAGS"[, @TYPE[,ARGUMENTS]]]'
> | ...
> |    This directive pushes the current section (and subsection) onto the
> | top of the section stack, and then replaces the current section and
> | subsection with `name' and `subsection'. The optional `flags', `type'
> | and `arguments' are treated the same as in the `.section' (*note
> | Section::) directive.
> | 
> | 7.94 `.section NAME'
> | ...
> | ELF Version
> | ...
> |    Note on targets where the `@' character is the start of a comment (eg
> | ARM) then another character is used instead.  For example the ARM port
> | uses the `%' character.
> | 
> |    If FLAGS contains the `M' symbol then the TYPE argument must be
> | specified as well as an extra argument--ENTSIZE--like this:
> | 
> |      .section NAME , "FLAGS"M, @TYPE, ENTSIZE
> | 
> |    Sections with the `M' flag but not `S' flag must contain fixed size
> | constants, each ENTSIZE octets long. Sections with both `M' and `S'
> | must contain zero terminated strings where each character is ENTSIZE
> | bytes long. The linker may remove duplicates within sections with the
> | same name, same entity size and same flags.  ENTSIZE must be an
> | absolute expression.
> 
> It appears that the TYPE argument is missing.  As the GAS manual says
> its required, then I think it really ought to be there.  Any comment?

I guess type should be %progbits.  That's what the compiler generates for
the assembler input in similar situations.

Interestingly, gas does not require this argument and seems to default to
progbits anyway ... but it seems best to do what the manual says.

Cheers
---Dave
