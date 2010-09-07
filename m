Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394Ab0IGKyo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 06:54:44 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:36548 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755532Ab0IGKyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 06:54:39 -0400
X-Sasl-enc: 9rUGnomnvbD4t9gEINOdEO6Fmmiio6CG2JoqxrAmG1ck 1283856878
Message-ID: <4C861A09.5020203@ladisch.de>
Date: Tue, 07 Sep 2010 12:55:05 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
CC: the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Hungry for hardware timers
References: <AANLkTiktFQWvz-TzewKYEd1wtEbe3cVFjFca4dFtUTCV@mail.gmail.com>	<4C85F0E3.2050908@ladisch.de>	<AANLkTi=-=88y=6kvV-WC3b5Pw7cf_ZoPaxhUnYugQK81@mail.gmail.com>	<4C860043.9000501@ladisch.de> <AANLkTimbDOb-iJgRmpEb29GVfP-K0_6TtvPSF7eK-2ts@mail.gmail.com>
In-Reply-To: <AANLkTimbDOb-iJgRmpEb29GVfP-K0_6TtvPSF7eK-2ts@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput wrote:
> If I access /dev/hpet by hpet_example it shows that it is using HPET
> T0 as hi_hpet is 0 :
> 
> #./hpet_example info /dev/hpet
> -hpet: executing info
> hpet_info: hi_irqfreq 0x0 hi_flags 0x0 hi_hpet 0 hi_timer 2

This means HPET block 0, timer 2.  In practice, there is no machine with
more than one HPET block, so hi_hpet is rather useless.

> What will be IRQ # for T2.

Just check while hpet_example is running ...

> As per dmesg([    0.325958] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0)
> so IRQs are like this :
> HPET T0 : 2
> HPET T1 : 8
> HPET T2 : 0

"0" means that the BIOS did not initialize it.  In this case, the driver
will initializes it when accessed, with the first supported IRQ above 15.
On your HPET's T2, this is IRQ 20.


Regards,
Clemens
