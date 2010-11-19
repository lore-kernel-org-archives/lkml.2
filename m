Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab0KSKmg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 05:42:36 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:39061 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752768Ab0KSKmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 05:42:35 -0500
Message-ID: <4CE6547A.9070309@metafoo.de>
Date: Fri, 19 Nov 2010 11:42:02 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Vasily Khoruzhick <anarsoul@gmail.com>
CC: linux-arm-kernel@lists.infradead.org, Kukjin Kim <kgene.kim@samsung.com>,
        Ben Dooks <ben-linux@fluff.org>,
        Marek Belisko <marek.belisko@open-nandra.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: s3x24xx: Fix gpiochip_add complaining.
References: <1290158139-16105-1-git-send-email-marek.belisko@open-nandra.com> <201011191123.22255.anarsoul@gmail.com>
In-Reply-To: <201011191123.22255.anarsoul@gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vasily Khoruzhick wrote:
> On Friday 19 November 2010 11:15:39 Marek Belisko wrote:
>> Make mini2440_defconfig. During kernel startup there is:
>> gpiochip_add: gpios 288..303 (GPIOK) failed to register
>> gpiochip_add: gpios 320..334 (GPIOL) failed to register
>> gpiochip_add: gpios 352..353 (GPIOM) failed to register
>>
>> because s3c2440 doesn't have following gpios. Gpios are
>> available only at upper cpu version (s3c2443).
> 
> These warnings are harmless, and your patch prevents building single binary 
> kernel for all s3c24xx socs (however, it's already broken by latest pull-
> up/pull-down changes)
> 
> Regards
> Vasily
> 

Hi

Well it actually causes problems on systems with external gpio expanders, because now
the additional banks will take up the space which was meant for the gpio expander
chip and peripherals connected to it wont be accessible.

I sent a patch[1] about this some time ago, but I guess it was never applied...

- Lars
[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2010-September/026382.html

> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

