Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874Ab2KGOg6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 09:36:58 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:58648 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab2KGOg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 09:36:57 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: Re: [RFC Patch v1 00/31] Synopsys ARC Linux kernel Port
Date: Wed, 7 Nov 2012 14:36:51 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com>
In-Reply-To: <1352281674-2186-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201211071436.52035.arnd@arndb.de>
X-Provags-ID: V02:K0:C7z07I61Pac6imnaCJ1Z4cf1WDCMe7gXVJGSD3Qpjhq
 tRrQwFVoue+nHJ2j9DUqZ5v4TODgnZwmvjPLnednqDFA+eNjvR
 yldJjHP1jqJAaoFptdFN76q6/6C1VkjGQwx+Sr0La2+S31WrSf
 o3TKDklf3J0o8xtZ3X93vtppnVIxVCnJoCwVVbNIW5etS/1Fo2
 0CHpvQjtwvGUOTemlTRCr/Lh5E+IFpoxtFhDw5bbz74r2tHIPK
 jG6ywSP/MtbwlmtF5XfPrLlmPGHphsbd4oIFN8ey67QoNekCgI
 sXuT4Xgbhsw6kRXHNbv1z+l7UNlIRYvvtogl+9+x5y5eBDsG+d
 Juayeedm8pAfIudKbEus=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
