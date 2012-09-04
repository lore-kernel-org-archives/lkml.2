Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592Ab2IDI6k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 04:58:40 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:45675 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589Ab2IDI6i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 04:58:38 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <alpine.DEB.2.00.1209040922110.523@skynet.skynet.ie>
References: <20120904135829.6beb08f80919aa2b5c8bf55f@canb.auug.org.au>
	<CA+icZUXT=GgYMAUq2KGm1jYsuw72moo+jzhoCadt7yJUpOAUzg@mail.gmail.com>
	<alpine.DEB.2.00.1209040922110.523@skynet.skynet.ie>
Date: Tue, 4 Sep 2012 10:58:36 +0200
Message-ID: <CA+icZUWxfE6VqsRbFNNUhR_NStO9rPThv_h5wVirL4e+dKUmBQ@mail.gmail.com>
Subject: Re: linux-next: build warnings after merge of the drm tree
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Dave Airlie <airlied@linux.ie>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sachin Kamat <sachin.kamat@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 4, 2012 at 10:22 AM, Dave Airlie <airlied@linux.ie> wrote:
>> > After merging the drm tree, today's linux-next build (powerpc
>> > ppc64_defconfig) produced these warnings:
>> >
>> > drivers/gpu/drm/udl/Kconfig:1:error: recursive dependency detected!
>> > drivers/gpu/drm/udl/Kconfig:1:  symbol DRM_UDL depends on USB_ARCH_HAS_HCD
>> > drivers/usb/Kconfig:76: symbol USB_ARCH_HAS_HCD depends on USB_SUPPORT
>> > drivers/usb/Kconfig:58: symbol USB_SUPPORT is selected by DRM_USB
>> > drivers/gpu/drm/Kconfig:22:     symbol DRM_USB is selected by DRM_UDL
>> > warning: (PPC_PS3) selects USB_OHCI_LITTLE_ENDIAN which has unmet direct dependencies (USB_SUPPORT && USB_OHCI_HCD)
>> > warning: (PPC_PS3 && PPC_CELLEB) selects USB_OHCI_BIG_ENDIAN_MMIO which has unmet direct dependencies (USB_SUPPORT && USB_OHCI_HCD)
>> > warning: (PPC_PS3 && PPC_CELLEB && USB_EHCI_HCD_PMC_MSP && XPS_USB_HCD_XILINX && USB_OCTEON_EHCI) selects USB_EHCI_BIG_ENDIAN_MMIO which has unmet direct dependencies (USB_SUPPORT && USB_EHCI_HCD && (PPC_CELLEB || PPC_PS3 || 440EPX || ARCH_IXP4XX || XPS_USB_HCD_XILINX || PPC_MPC512x || CPU_CAVIUM_OCTEON || PMC_MSP || SPARC_LEON || MIPS_SEAD3))
>> >
>> > The x86_64 allmodconfig produces these:
>> >
>> > drivers/gpu/drm/udl/Kconfig:1:error: recursive dependency detected!
>> > drivers/gpu/drm/udl/Kconfig:1:  symbol DRM_UDL depends on USB_ARCH_HAS_HCD
>> > drivers/usb/Kconfig:76: symbol USB_ARCH_HAS_HCD depends on USB_SUPPORT
>> > drivers/usb/Kconfig:58: symbol USB_SUPPORT is selected by DRM_USB
>> > drivers/gpu/drm/Kconfig:22:     symbol DRM_USB is selected by DRM_UDL
>> > warning: (MOUSE_APPLETOUCH && MOUSE_BCM5974 && MOUSE_SYNAPTICS_USB && JOYSTICK_XPAD && TABLET_USB_ACECAD && TABLET_USB_AIPTEK && TABLET_USB_HANWANG && TABLET_USB_KBTAB && TABLET_USB_WACOM && TOUCHSCREEN_USB_COMPOSITE && INPUT_ATI_REMOTE2 && INPUT_KEYSPAN_REMOTE && INPUT_POWERMATE && INPUT_YEALINK && INPUT_CM109 && RC_ATI_REMOTE && IR_IMON && IR_MCEUSB && IR_REDRAT3 && IR_STREAMZAP && IR_IGUANA && IR_TTUSBIR && DRM_USB) selects USB which has unmet direct dependencies (USB_SUPPORT && USB_ARCH_HAS_HCD)
>> >
>> > Maybe introduced by commit df0b34430072 ("drm/usb: select USB_SUPPORT in
>> > Kconfig"), maybe interacting with a commit 8f057d7bca54 ("gpu/mfd/usb:
>> > Fix USB randconfig problems") from Linus' tree (that added "depends on
>> > USB_ARCH_HAS_HCD" to "config DRM_USB" and "config DRM_UDL").
>> >
>> > I have left this mess for now, but it needs addressing.
>>
>> I have sent a fix ("drm/udl: usb: Fix recursive Kconfig dependency")
>> for this mess and pinged airlied on IRC.
>> NOTE: I saw this when I merged drm(-intel){-fixes,next} into next-20120824.
>
> I[ve pushed it to drm-next now hopefully it will resolve the mess.
>

Great and thanks!

Can't say if the label of my patch should be changed to "drm/usb: ..."
as the culprit commit df0b34430072 (drm/usb: select USB_SUPPORT in
Kconfig) has it and the fix is done in drm/usb Kconfig definition.
( Thinking loud of people searching within (git-)logs. )

For me the current status of drm-next is OK (next time I do better).

- Sedat -

[1] http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commitdiff;h=df0b344300724e00db9fff7eb6406eb91f450b91

> thanks,
> Dave.
