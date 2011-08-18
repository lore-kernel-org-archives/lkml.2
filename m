Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751306Ab1HRSDq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 14:03:46 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:54324 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762Ab1HRSDo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 14:03:44 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1108172339270.20358@xanadu.home>
References: <4E457682.5020107@codeaurora.org>
	<1313175602-21834-1-git-send-email-sboyd@codeaurora.org>
	<CACqU3MUq5M-XPOxV=8GKyEzjEzpmdeaF+mGrXJrK+ZZxa4SdeQ@mail.gmail.com>
	<CACqU3MXtcg_8si9WiuZngMB2C977PS4zen8_cQ9oyNtwTbt75Q@mail.gmail.com>
	<alpine.LFD.2.00.1108172339270.20358@xanadu.home>
Date: Thu, 18 Aug 2011 14:03:43 -0400
Message-ID: <CACqU3MUV=-hQ_y3wLPBYRh+DhLcFqneWbURNQ66UyArb5UJcxw@mail.gmail.com>
Subject: Re: [PATCH] ARM: zImage: Skip relinking if nothing changes
From: Arnaud Lacombe <lacombar@gmail.com>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Stephen Boyd <sboyd@codeaurora.org>, Sam Ravnborg <sam@ravnborg.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Aug 17, 2011 at 11:44 PM, Nicolas Pitre <nico@fluxnic.net> wrote:
> On Fri, 12 Aug 2011, Arnaud Lacombe wrote:
>> On Fri, Aug 12, 2011 at 4:48 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
>> > On Fri, Aug 12, 2011 at 3:00 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>> >> diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
>> >> index 0c74a6f..937fd26 100644
>> >> --- a/arch/arm/boot/compressed/Makefile
>> >> +++ b/arch/arm/boot/compressed/Makefile
>> >> @@ -91,7 +91,7 @@ suffix_$(CONFIG_KERNEL_LZMA) = lzma
>> >>
>> >>  targets       := vmlinux vmlinux.lds \
>> >>                 piggy.$(suffix_y) piggy.$(suffix_y).o \
>> >> -                font.o font.c head.o misc.o $(OBJS)
>> >> +                font.o font.c head.o misc.o lib1funcs.o lib1funcs.S $(OBJS)
>> >>
>> >>  # Make sure files are removed during clean
>> >>  extra-y       += piggy.gzip piggy.lzo piggy.lzma lib1funcs.S
>> >> @@ -121,9 +121,7 @@ LDFLAGS_vmlinux += -X
>> >>  LDFLAGS_vmlinux += -T
>> >>
>> >>  # For __aeabi_uidivmod
>> >> -lib1funcs = $(obj)/lib1funcs.o
>> >> -
>> >> -$(obj)/lib1funcs.S: $(srctree)/arch/$(SRCARCH)/lib/lib1funcs.S FORCE
>> >> +$(obj)/lib1funcs.S: $(srctree)/arch/$(SRCARCH)/lib/lib1funcs.S
>> >>        $(call cmd,shipped)
>> >>
>> > You should be able to avoid the extra copy altogether by doing something ala:
>> >
>> > $(obj)/lib1funcs.o: $(srctree)/arch/arm/lib/lib1funcs.S
>> >        $(call cmd,as_o_S)
>> >
>> > note that I also remove the $(SRCARCH), as there is no other
>> > `arch/*/lib/lib1funcs.S' than `arch/arm/lib/lib1funcs.S'
>> >
>> I withdraw this proposal and will hack around this to find a proper
>> solution from within kbuild, and eventually come back on these uses
>> :-)
>
> Any progress on this?
>
> I have a patch doing multiple similar $(call cmd,shipped) at the moment
> and this is far from looking nice.
>
What is your use-case ? Is it re-use of code in a different
subdirectory (use-case presented in this thread), or aliasing of the
same source under different object name in the same directory (as used
in the alpha tree) ?

If it is the former, I potentially have a solution, but it is
highlighting bad use of the kbuild infrastructure. I have not been
able to yet measure the impact of the breakage, ie. either localized
or tree-wide. I should be able to provide you with more info,
hopefully, this evening.

Thanks,
 - Arnaud
