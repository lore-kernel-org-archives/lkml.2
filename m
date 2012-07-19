Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813Ab2GSStU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 14:49:20 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52840 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057Ab2GSStN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 14:49:13 -0400
MIME-Version: 1.0
In-Reply-To: <20120719182235.GG8469@zod.bos.redhat.com>
References: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com>
	<20120713210240.GG1707@redhat.com>
	<CA+55aFz_Vv899eXz6F0jtFH=hT4QpB0_2XuS8HySPjHC6s+L7Q@mail.gmail.com>
	<20120719152618.GD16873@home.goodmis.org>
	<20120719154521.GC8469@zod.bos.redhat.com>
	<1342714088.12353.33.camel@gandalf.stny.rr.com>
	<20120719171918.GD8469@zod.bos.redhat.com>
	<1342722036.26179.40.camel@x61.thuisdomein>
	<20120719182235.GG8469@zod.bos.redhat.com>
Date: Thu, 19 Jul 2012 20:49:12 +0200
X-Google-Sender-Auth: IiT3nSr8rKh7Ag918PL1RLsmx5U
Message-ID: <CAMuHMdWunmaTvF3sEfWBtRfczwY01RDzvcX_hTWe2Q62RpCwHA@mail.gmail.com>
Subject: Re: [RFC] Simplifying kernel configuration for distro issues
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Paul Bolle <pebolle@tiscali.nl>, Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
        Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
        Debian Kernel Team <debian-kernel@lists.debian.org>,
        OpenSUSE Kernel Team <opensuse-kernel@opensuse.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Fedora Kernel Team <kernel-team@fedoraproject.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2012 at 8:22 PM, Josh Boyer <jwboyer@redhat.com> wrote:
> On Thu, Jul 19, 2012 at 08:20:36PM +0200, Paul Bolle wrote:
>> On Thu, 2012-07-19 at 13:19 -0400, Josh Boyer wrote:
>> > kconfig already spits out warnings for symbols being selected that
>> > don't exist.
>
>> Does it? Since when does it do that? Or do you mean select in a more
>> general way (not just meaning Kconfig's "select" statement)?
>
> I believe Alan was more correct than me when he said it was 'make
> oldconfig' that produced the warnings.

Kconfig does spit out warnings for selecting things with unmet dependencies.
But does anyone care?

[...checking logs...]

Oh, only 12 warnings in the v3.5-rc7 builds. Not that bad as my gut feeling
said...

warning: (ETRAX_USB_HOST && MOUSE_APPLETOUCH && MOUSE_BCM5974 &&
MOUSE_SYNAPTICS_USB && JOYSTICK_XPAD && TABLET_USB_ACECAD &&
TABLET_USB_AIPTEK && TABLET_USB_HANWANG && TABLET_USB_KBTAB &&
TABLET_USB_WACOM && TOUCHSCREEN_USB_COMPOSITE && INPUT_ATI_REMOTE2 &&
INPUT_KEYSPAN_REMOTE && INPUT_POWERMATE && INPUT_YEALINK &&
INPUT_CM109) selects USB which has unmet direct dependencies
(USB_SUPPORT && USB_ARCH_HAS_HCD): 10 warnings in 2 logs
warning: (IWLWIFI && IWLEGACY && ATH5K && ATH9K && ATH9K_HTC &&
CARL9170_LEDS) selects MAC80211_LEDS which has unmet direct
dependencies (NET && WIRELESS && MAC80211 && LEDS_CLASS): 10 warnings
in 2 logs
warning: (LOCKDEP && FAULT_INJECTION_STACKTRACE_FILTER && LATENCYTOP
&& KMEMCHECK) selects FRAME_POINTER which has unmet direct
dependencies (DEBUG_KERNEL && (CRIS || M68K || FRV || UML || AVR32 ||
SUPERH || BLACKFIN || MN10300) || ARCH_WANT_FRAME_POINTERS): 10
warnings in 2 logs
warning: (MPC836x_RDK && MTD_NAND_FSL_ELBC && MTD_NAND_FSL_UPM)
selects FSL_LBC which has unmet direct dependencies (FSL_SOC): 9
warnings in 2 logs
warning: (SINGLE_MEMORY_CHUNK) selects NEED_MULTIPLE_NODES which has
unmet direct dependencies (DISCONTIGMEM || NUMA): 9 warnings in 2 logs
warning: (COMPAT) selects COMPAT_BINFMT_ELF which has unmet direct
dependencies (COMPAT && BINFMT_ELF): 3 warnings in 1 logs
warning: (DRM) selects DMA_SHARED_BUFFER which has unmet direct
dependencies (EXPERIMENTAL): 3 warnings in 1 logs
warning: (DRM_RADEON_KMS && DRM_I915 && STUB_POULSBO && FB_BACKLIGHT
&& USB_APPLEDISPLAY && FB_OLPC_DCON && ASUS_LAPTOP && SONY_LAPTOP &&
THINKPAD_ACPI && EEEPC_LAPTOP && ACPI_CMPC && SAMSUNG_Q10 &&
APPLE_GMUX) selects BACKLIGHT_CLASS_DEVICE which has unmet direct
dependencies (HAS_IOMEM && BACKLIGHT_LCD_SUPPORT): 3 warnings in 1
logs
warning: (IA64) selects PM which has unmet direct dependencies
(PM_SLEEP || PM_RUNTIME): 4 warnings in 1 logs
warning: (MOUSE_APPLETOUCH && MOUSE_BCM5974 && MOUSE_SYNAPTICS_USB &&
JOYSTICK_XPAD && TABLET_USB_ACECAD && TABLET_USB_AIPTEK &&
TABLET_USB_HANWANG && TABLET_USB_KBTAB && TABLET_USB_WACOM &&
TOUCHSCREEN_USB_COMPOSITE && INPUT_ATI_REMOTE2 && INPUT_KEYSPAN_REMOTE
&& INPUT_POWERMATE && INPUT_YEALINK && INPUT_CM109 && RC_ATI_REMOTE &&
IR_IMON && IR_MCEUSB && IR_REDRAT3 && IR_STREAMZAP && DRM_USB) selects
USB which has unmet direct dependencies (USB_SUPPORT &&
USB_ARCH_HAS_HCD): 5 warnings in 1 logs
warning: (PLATFORM_AT32AP) selects HAVE_NET_MACB which has unmet
direct dependencies (NETDEVICES && ETHERNET): 3 warnings in 1 logs
warning: (PREEMPT && DEBUG_ATOMIC_SLEEP) selects PREEMPT_COUNT which
has unmet direct dependencies (COLDFIRE): 5 warnings in 1 logs

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
