Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510Ab0IAXnq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 19:43:46 -0400
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148]:64713
	"EHLO outbound.icp-qv1-irony-out3.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754639Ab0IAXnp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 19:43:45 -0400
X-Greylist: delayed 595 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Sep 2010 19:43:45 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApEBAMZ/fkzL2T1e/2dsb2JhbAAH4wuFOQSNIg
X-IronPort-AV: E=Sophos;i="4.56,306,1280678400"; 
   d="scan'208";a="635655638"
Subject: Re: [UIO]  SMX UIO interface
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Ben Nizette <bn@niasdigital.com>
In-Reply-To: <4C7DFF2C.8070709@steinhoff.de>
Date: Thu, 2 Sep 2010 09:33:47 +1000
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <ABD0E28F-0839-4C6F-A0BD-999A28A6803A@niasdigital.com>
References: <4C7DFF2C.8070709@steinhoff.de>
To: Armin Steinhoff <armin@steinhoff.de>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 01/09/2010, at 5:22 PM, Armin Steinhoff wrote:

> Hi Ben,
> 
> I have a question about the SMX UIO Interface.
> 
> In the SMX module you are reading the data of the platform resourses:
> 
>    regs = platform_get_resource(dev, IORESOURCE_MEM, 0);
>    if (!regs) {
>        dev_err(&dev->dev, "No memory resource specified\n");
>        goto out_free;
>    }
> 
> But who sets these data initially ?

Who ever sets up the platform device that will bind to this driver, usually the board code (eg on avr32 arch/avr32/boards/*/setup.c, ARM is somewhere under arch/arm/mach-*/ I think).

The board code would create an array of struct resource with the appropriate memory regions and an IRQ entry, create a struct platform_device with the right content to bind to that driver, set the platform_device .resource field to the previously created array then call platform_device_register() to kick things off.

	--Ben.

> 
> Cheers
> 
> --Armin
> 

