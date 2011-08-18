Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076Ab1HRDoH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 23:44:07 -0400
Received: from relais.videotron.ca ([24.201.245.36]:38645 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754918Ab1HRDoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 23:44:02 -0400
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_SsnLIw92Rj/SQ+8jy81SMA)"
Date: Wed, 17 Aug 2011 23:44:01 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>, Sam Ravnborg <sam@ravnborg.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] ARM: zImage: Skip relinking if nothing changes
In-reply-to: <CACqU3MXtcg_8si9WiuZngMB2C977PS4zen8_cQ9oyNtwTbt75Q@mail.gmail.com>
Message-id: <alpine.LFD.2.00.1108172339270.20358@xanadu.home>
References: <4E457682.5020107@codeaurora.org>
 <1313175602-21834-1-git-send-email-sboyd@codeaurora.org>
 <CACqU3MUq5M-XPOxV=8GKyEzjEzpmdeaF+mGrXJrK+ZZxa4SdeQ@mail.gmail.com>
 <CACqU3MXtcg_8si9WiuZngMB2C977PS4zen8_cQ9oyNtwTbt75Q@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--Boundary_(ID_SsnLIw92Rj/SQ+8jy81SMA)
Content-type: TEXT/PLAIN; charset=ISO-8859-1
Content-transfer-encoding: 8BIT

On Fri, 12 Aug 2011, Arnaud Lacombe wrote:
> On Fri, Aug 12, 2011 at 4:48 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> > On Fri, Aug 12, 2011 at 3:00 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> >> diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
> >> index 0c74a6f..937fd26 100644
> >> --- a/arch/arm/boot/compressed/Makefile
> >> +++ b/arch/arm/boot/compressed/Makefile
> >> @@ -91,7 +91,7 @@ suffix_$(CONFIG_KERNEL_LZMA) = lzma
> >>
> >>  targets       := vmlinux vmlinux.lds \
> >>                 piggy.$(suffix_y) piggy.$(suffix_y).o \
> >> -                font.o font.c head.o misc.o $(OBJS)
> >> +                font.o font.c head.o misc.o lib1funcs.o lib1funcs.S $(OBJS)
> >>
> >>  # Make sure files are removed during clean
> >>  extra-y       += piggy.gzip piggy.lzo piggy.lzma lib1funcs.S
> >> @@ -121,9 +121,7 @@ LDFLAGS_vmlinux += -X
> >>  LDFLAGS_vmlinux += -T
> >>
> >>  # For __aeabi_uidivmod
> >> -lib1funcs = $(obj)/lib1funcs.o
> >> -
> >> -$(obj)/lib1funcs.S: $(srctree)/arch/$(SRCARCH)/lib/lib1funcs.S FORCE
> >> +$(obj)/lib1funcs.S: $(srctree)/arch/$(SRCARCH)/lib/lib1funcs.S
> >>        $(call cmd,shipped)
> >>
> > You should be able to avoid the extra copy altogether by doing something ala:
> >
> > $(obj)/lib1funcs.o: $(srctree)/arch/arm/lib/lib1funcs.S
> >        $(call cmd,as_o_S)
> >
> > note that I also remove the $(SRCARCH), as there is no other
> > `arch/*/lib/lib1funcs.S' than `arch/arm/lib/lib1funcs.S'
> >
> I withdraw this proposal and will hack around this to find a proper
> solution from within kbuild, and eventually come back on these uses
> :-)

Any progress on this?

I have a patch doing multiple similar $(call cmd,shipped) at the moment 
and this is far from looking nice.


Nicolas

--Boundary_(ID_SsnLIw92Rj/SQ+8jy81SMA)--
