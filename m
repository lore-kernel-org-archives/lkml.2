Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600Ab2KHTKT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 14:10:19 -0500
Received: from us02smtp2.synopsys.com ([198.182.60.77]:33621 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754806Ab2KHTKQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 14:10:16 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: RE: [RFC Patch v1 00/31] Synopsys ARC Linux kernel Port
Thread-Topic: [RFC Patch v1 00/31] Synopsys ARC Linux kernel Port
Thread-Index: AQHNvM0BFksUY6JXgECBeI+BGapsJJfeFNiAgAI25B8=
Date: Thu, 8 Nov 2012 19:09:20 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA230750D9871@in01wembx1.internal.synopsys.com>
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com>,<201211071436.52035.arnd@arndb.de>
In-Reply-To: <201211071436.52035.arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.144.160.2]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Thanks for your valuable comments I will rework the port.

P.S. Sorry for top-posting. 

Thanks,
Vineet

On Wednesday 07 November 2012, Vineet Gupta wrote:
> This patchset based off-of 3.7-rc3, introduces the Linux kernel port to
> ARC700 processor family (750D and 770D) from Synopsys.
>
> ARC700 is highly configurable and power efficient 32-bit RISC core with MMU.
> It is embedded in SoCs deployed in TV Set Top boxes, Digital Media Players,
> all the way to Network-on-Chips.

Hi Vineet,

I'm largely quite happy with how the series has turned out, having looked
at earlier versions of the ARC kernel a couple of years ago. I've commented
already on individual patches, but overall, I see two main issues that
need to be resolved in order to merge the port:

* You have to use the generic syscall interface, and that means not using
  any of the legacy system calls that have since been replaced by newer
  versions of the same.

* You are missing dynamic hardware detection. Rather than building a kernel
  with everything known about the hardware at compile time, new ports these
  days are normally able to run on all kinds of hardware and detect the
  differences by looking at configuration registers (e.g. PCI), asking
  firmware (Open Firmware, ACPI, ...) or by interpreting a device tree
  that is passed by the boot loader (most embedded systems).
  I assume that device tree is the right solution for you because a lot of
  the hardware you use is likely shared with ARM, PowerPC or MIPS based
  SoCs and they are all using (or getting migrated to) DT now instead of
  static platform devices,

        Arnd
