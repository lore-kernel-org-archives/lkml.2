Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468Ab2EOKTY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 06:19:24 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52024 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894Ab2EOKTW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 06:19:22 -0400
MIME-Version: 1.0
In-Reply-To: <20120513055612.GA7129@codeaurora.org>
References: <q7bdy899mt3um93hikst04au.1336884464056@email.android.com> <20120513055612.GA7129@codeaurora.org>
From: Shantanu Gupta <shans95g@gmail.com>
Date: Tue, 15 May 2012 15:49:00 +0530
Message-ID: <CAPDArRKgZKR2kdbt-ySx7GrXopNnN+j4hKr1rrDPgxkZ8S2YjQ@mail.gmail.com>
Subject: Re: [PATCH v2] arm: msm: fix up very basic HTC Sapphire support
To: David Brown <davidb@codeaurora.org>
Cc: Daniel Walker <dwalker@fifo99.com>, Olof Johansson <olof@lixom.net>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for thread jacking, but do you still have an actively supported
8x50 board ? ( ie. mahimahi)

>> >> On Fri, May 11, 2012 at 5:15 PM, David Brown <davidb@codeaurora.org> wrote:
>> >> > From: Daniel Walker <dwalker@fifo99.com>
>> >> >
>> >> > Adds sapphire into the make file, and fixes all the code problems that
>> >> > prevented it from building (including adding board-sapphire.h)
>> >> >
>> >> > [davidb@codeaurora.org: Move MACH_TROUT selection back under
>> >> > ARCH_MSM7X00A]
>> >> >
>> >> > Signed-off-by: Daniel Walker <dwalker@fifo99.com>
>> >> > Signed-off-by: David Brown <davidb@codeaurora.org>
>> >> > ---
>> >> > v2 - Moved MACH_TROUT selection back under the ARCH config target
>> >> >
>> >> >  arch/arm/mach-msm/Kconfig          |    9 +-
>> >> >  arch/arm/mach-msm/Makefile         |    1 +
>> >> >  arch/arm/mach-msm/board-sapphire.c |   18 +--
>> >> >  arch/arm/mach-msm/board-sapphire.h |  224 ++++++++++++++++++++++++++++++++++++
>> >> >  4 files changed, 234 insertions(+), 18 deletions(-)
>> >> >  create mode 100644 arch/arm/mach-msm/board-sapphire.h
>> >> >
>> >> > diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
>> >> > index 1cd40ad..70eae63 100644
>> >> > --- a/arch/arm/mach-msm/Kconfig
>> >> > +++ b/arch/arm/mach-msm/Kconfig
>> >> > @@ -6,7 +6,7 @@ choice
>> >> >
>> >> >  config ARCH_MSM7X00A
>> >> >        bool "MSM7x00A / MSM7x01A"
>> >> > -       select MACH_TROUT if !MACH_HALIBUT
>> >> > +       select MACH_TROUT if (!MACH_HALIBUT && !MACH_SAPPHIRE)
>> >>
>> >> Better, thanks!
>> >>
>> >>
>> >> > diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
>> >> > index 4ad3969..aff4e5c 100644
>> >> > --- a/arch/arm/mach-msm/Makefile
>> >> > +++ b/arch/arm/mach-msm/Makefile
>> >> > @@ -20,6 +20,7 @@ CFLAGS_scm.o :=$(call as-instr,.arch_extension sec,-DREQUIRES_SEC=1)
>> >> >  obj-$(CONFIG_HOTPLUG_CPU) += hotplug.o
>> >> >  obj-$(CONFIG_SMP) += headsmp.o platsmp.o
>> >> >
>> >> > +obj-$(CONFIG_MACH_SAPPHIRE) += board-sapphire.o devices-msm7x00.o
>> >> >  obj-$(CONFIG_MACH_TROUT) += board-trout.o board-trout-gpio.o board-trout-mmc.o devices-msm7x00.o
>> >> >  obj-$(CONFIG_MACH_TROUT) += board-trout.o board-trout-gpio.o board-trout-mmc.o board-trout-panel.o devices-msm7x00.o
>> >> >  obj-$(CONFIG_MACH_HALIBUT) += board-halibut.o devices-msm7x00.o
>> >>
>> >> Unrelated to this change per se, but it seems like devices-msm7x00.o
>> >> should be on an obj-$(CONFIG_ARCH_MSM7X00A) statement instead of
>> >> duplicated for all boards.
>> >>
>> >> Also, the trout line is mostly duplicated, only delta is panel. Looks
>> >> broken. Both of these things is material for a separate patch though.
>> >>
>> >> > diff --git a/arch/arm/mach-msm/board-sapphire.h b/arch/arm/mach-msm/board-sapphire.h
>> >> > new file mode 100644
>> >> > index 0000000..70f925e
>> >> > --- /dev/null
>> >> > +++ b/arch/arm/mach-msm/board-sapphire.h
>> >> > @@ -0,0 +1,224 @@
>> >> [..]
>> >> > +void config_sapphire_camera_on_gpios(void);
>> >> > +void config_sapphire_camera_off_gpios(void);
>> >> > +int sapphire_get_smi_size(void);
>> >> > +unsigned int sapphire_get_hwid(void);
>> >> > +unsigned int sapphire_get_skuid(void);
>> >> > +unsigned int is_12pin_camera(void);
>> >> > +int sapphire_is_5M_camera(void);
>> >> > +int sapphire_gpio_write(struct gpio_chip *chip, unsigned n, unsigned on);
>> >>
>> >> Many (all?) of these functions are not to be found in the code. Please
>> >> don't add prototypes for code that isn't there.
>> >>
>> >>
>> >> -Olof
>> >
>> >--
>> >Sent by an employee of the Qualcomm Innovation Center, Inc.
>> >The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
>> >
>
> --
> Sent by an employee of the Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arm-msm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
