Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412Ab0GNHdE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 03:33:04 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:42550 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880Ab0GNHdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 03:33:00 -0400
Message-ID: <4C3D643D.6070705@oss.ntt.co.jp>
Date: Wed, 14 Jul 2010 16:16:13 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Zachary Amsden <zamsden@redhat.com>
CC: KVM <kvm@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>,
        Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 18/18] Add timekeeping documentation
References: <1278987938-23873-1-git-send-email-zamsden@redhat.com> <1278987938-23873-19-git-send-email-zamsden@redhat.com>
In-Reply-To: <1278987938-23873-19-git-send-email-zamsden@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

(2010/07/13 11:25), Zachary Amsden wrote:
> +
> +2.3) APIC
> +
> +On Pentium and later processors, an on-board timer is available to each CPU
> +as part of the Advanced Programmable Interrupt Controller.  The APIC is
> +accessed through memory-mapped registers and provides interrupt service to each
> +CPU, used for IPIs and local timer interrupts.
> +
> +Although in theory the APIC is a safe and stable source for local interrupts,
> +in practice, many bugs and glitches have occurred due to the special nature of
> +the APIC CPU-local memory-mapped hardware.  Beware that CPU errata may affect
> +the use of the APIC and that workarounds may be required.  In addition, some of
> +these workarounds pose unique constraints for virtualization - requiring either
> +extra overhead incurred from extra reads of memory-mapped I/O or additional
> +functionality that may be more computationally expensive to implement.
> +
> +Since the APIC is documented quite well in the Intel and AMD manuals, we will
> +avoid repititon of the detail here.  It should be pointed out that the APIC

          repetition?

> +timer is programmed through the LVT (local vector timer) register, is capable
> +of one-shot or periodic operation, and is based on the bus clock divided down
> +by the programmable divider register.
> +
> +2.4) HPET
> +
> +HPET is quite complex, and was originally intended to replace the PIT / RTC
> +support of the X86 PC.  It remains to be seen whether that will be the case, as
> +the de facto standard of PC hardware is to emulate these older devices.  Some
> +systems designated as legacy free may support only the HPET as a hardware timer
> +device.
> +
> +The HPET spec is rather loose and vague, requiring at least 3 hardware timers,
> +but allowing implementation freedom to support many more.  It also imposes no
> +fixed rate on the timer frequency, but does impose some extremal values on
> +frequency, error and slew.
> +
> +In general, the HPET is recommended as a high precision (compared to PIT /RTC)
> +time source which is independent of local variation (as there is only one HPET
> +in any given system).  The HPET is also memory-mapped, and its presence is
> +indicated through ACPI tables by the BIOS.
> +
> +Detailed specification of the HPET is beyond the current scope of this
> +document, as it is also very well documented elsewhere.
> +


> +3.6) TSC and STPCLK / T-states
> +
> +External signals given to the processor may also have the affect of stopping

                                                              effect?

> +the TSC.  This is typically done for thermal emergency power control to prevent
> +an overheating condition, and typically, there is no way to detect that this
> +condition has happened.
> +


> +4.4) Migration
> +
> +Migration of a virtual machine raises problems for timekeeping in two ways.
> +First, the migration itself may take time, during which interrupts cannot be
> +delivered, and after which, the guest time may need to be caught up.  NTP may
> +be able to help to some degree here, as the clock correction required is
> +typically small enough to fall in the NTP-correctable window.
> +
> +An additional concern is that timers based off the TSC (or HPET, if the raw bus
> +clock is exposed) may now be running at different rates, requiring compensation
> +in some may in the hypervisor by virtualizing these timers.  In addition,

            way?

> +migrating to a faster machine may preclude the use of a passthrough TSC, as a
> +faster clock cannot be made visible to a guest without the potential of time
> +advancing faster than usual.  A slower clock is less of a problem, as it can
> +always be caught up to the original rate.  KVM clock avoids these problems by
> +simply storing multipliers and offsets gainst the TSC for the guest to convert

                                           against?

> +back into nanosecond resolution values.
> +


   Takuya

     -- I'm not English speaker, so not so sure about some places.
