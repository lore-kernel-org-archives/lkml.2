Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598Ab1CPKRt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 06:17:49 -0400
Received: from h1047321.serverkompetenz.net ([85.214.67.163]:42539 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445Ab1CPKRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 06:17:44 -0400
Message-ID: <4D808E41.8040402@ahsoftware.de>
Date: Wed, 16 Mar 2011 11:17:37 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: balbi@ti.com
CC: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: musb as module broken in 2.6.38
References: <4D8018A9.6000800@ahsoftware.de> <20110316090327.GA2325@legolas.emea.dhcp.ti.com> <4D808729.9060608@ahsoftware.de> <20110316095541.GD2325@legolas.emea.dhcp.ti.com>
In-Reply-To: <20110316095541.GD2325@legolas.emea.dhcp.ti.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 16.03.2011 10:55, schrieb Felipe Balbi:
> On Wed, Mar 16, 2011 at 10:47:21AM +0100, Alexander Holler wrote:
>> ------------
>> beagle linux # grep -i MUSB .config
>> CONFIG_USB_MUSB_HDRC=m
>> # CONFIG_USB_MUSB_TUSB6010 is not set
>> CONFIG_USB_MUSB_OMAP2PLUS=y
>> # CONFIG_USB_MUSB_AM35X is not set
>> # CONFIG_USB_MUSB_HOST is not set
>> # CONFIG_USB_MUSB_PERIPHERAL is not set
>> CONFIG_USB_MUSB_OTG=y
>> CONFIG_USB_GADGET_MUSB_HDRC=y
>> CONFIG_USB_MUSB_HDRC_HCD=y
>> # CONFIG_MUSB_PIO_ONLY is not set
>> CONFIG_USB_MUSB_DEBUG=y
>> beagle linux # modprobe musb_hdrc
>> FATAL: Error inserting musb_hdrc (/lib/modules/2.6.38-beagleboard-00002-g0017ea0-dirty/kernel/drivers/usb/musb/musb_hdrc.ko):
>> No such device
>> beagle linux # tail -n 1 /var/log/messages
>> Mar 16 10:37:51 beagle kernel: [  177.302825] musb-hdrc: version 6.0,
>> musb-dma, otg (peripheral+host), debug=5
>> beagle linux # ls /sys/devices/platform/ | grep musb
>> musb-omap2430
>> ------------
>>
>> The problem in detail:
>>
>> Through modprobe musb_core.c:musb_init() is called, and this calls
>> platform_driver_probe() with a pointer to a struct of platform_device
>> where the name is musb-hdrc.
>> drivers/base/platform.c:platform_driver_probe() fails with -ENODEV
>> because it doesn't find a platform device with the name musb-hdrc
>> (list_empty()) which is understandable because the platform-device
>> has the name musb-omap2430.
>
> look further, omap2430.c allocates musb-hdrc platform_device. The
> problem is a different one.
>
> static int __init omap2430_probe(struct platform_device *pdev)

Neither omap2430_init() nor omap2430_probe() will be called here.

Regards,

Alexander Holler
