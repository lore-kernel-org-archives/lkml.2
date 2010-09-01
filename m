Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab0IAJ40 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 05:56:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39356 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754124Ab0IAJ4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 05:56:24 -0400
Message-ID: <4C7E233D.3030002@redhat.com>
Date: Wed, 01 Sep 2010 06:56:13 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: linux-media@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for August 7 (IR)
References: <20100807160710.b7c8d838.sfr@canb.auug.org.au>	<20100807203920.83134a60.randy.dunlap@oracle.com>	<20100808135511.269f670c.randy.dunlap@oracle.com>	<4C5F9C2E.50001@redhat.com>	<20100809075255.97d18a66.randy.dunlap@oracle.com>	<4C603DB1.9030706@redhat.com>	<4C604196.6060100@redhat.com> <20100827094553.f1c9a95d.randy.dunlap@oracle.com>
In-Reply-To: <20100827094553.f1c9a95d.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 27-08-2010 13:45, Randy Dunlap escreveu:
> On Mon, 09 Aug 2010 14:57:42 -0300 Mauro Carvalho Chehab wrote:
> 
>> Em 09-08-2010 14:41, Mauro Carvalho Chehab escreveu:
>>> Em 09-08-2010 11:52, Randy Dunlap escreveu:
>>>>> Hmm... clearly, there are some bad dependencies at the Kconfig. Maybe ir-core were compiled
>>>>> as module, while some drivers as built-in.
>>>>>
>>>>> Could you please pass the .config file for this build?
>>>>
>>>>
>>>> Sorry, config-r5101 is now attached.
>>>
>>> Hmm... when building it, I'm getting an interesting warning:
>>>
>>> warning: (VIDEO_BT848 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_DEV && PCI && I2C && VIDEO_V4L2 && INPUT || VIDEO_SAA7134 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && VIDEO_DEV && PCI && I2C && INPUT || VIDEO_CX88 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && VIDEO_DEV && PCI && I2C && INPUT || VIDEO_IVTV && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && PCI && I2C && INPUT || VIDEO_CX18 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && DVB_CORE && PCI && I2C && EXPERIMENTAL && INPUT || VIDEO_EM28XX && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && V4L_USB_DRIVERS && USB && VIDEO_DEV && I2C && INPUT || VIDEO_TLG2300 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && V4L_USB_DRIVERS && USB && VIDEO_DEV && I2C && INPUT && SND && DVB_CORE || VIDEO_CX231XX && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && V4L_USB_DRIVERS && USB && VIDEO_DEV && I2C && INPUT || DVB_BUDGET_CI && MEDIA_SUPPORT && DVB!

>  _CA
>> PT
>>> URE_DRIVERS && DVB_CORE && DVB_BUDGET_CORE && I2C && INPUT || DVB_DM1105 && MEDIA_SUPPORT && DVB_CAPTURE_DRIVERS && DVB_CORE && PCI && I2C && INPUT || VIDEO_GO7007 && STAGING && !STAGING_EXCLUDE_BUILD && VIDEO_DEV && PCI && I2C && INPUT && SND || VIDEO_CX25821 && STAGING && !STAGING_EXCLUDE_BUILD && DVB_CORE && VIDEO_DEV && PCI && I2C && INPUT) selects VIDEO_IR which has unmet direct dependencies (IR_CORE)
>>>
>>> This warning seems to explain what's going wrong.
>>>
>>> I'll make patch(es) to address this issue.
>>
>>
>> Ok, This patch (together with the previous one) seemed to solve the issue.
>>
> 
> Hi Mauro,
> 
> Have you merged these 2 patches?
> I'm seeing very similar build errors in linux-next 20100827:
> 
> 
> ERROR: "get_rc_map" [drivers/media/video/saa7134/saa7134.ko] undefined!
> ERROR: "ir_input_unregister" [drivers/media/video/saa7134/saa7134.ko] undefined!
> ERROR: "ir_raw_event_store_edge" [drivers/media/video/saa7134/saa7134.ko] undefined!
> ERROR: "__ir_input_register" [drivers/media/video/saa7134/saa7134.ko] undefined!
> ERROR: "ir_raw_event_handle" [drivers/media/video/saa7134/saa7134.ko] undefined!
> ERROR: "get_rc_map" [drivers/media/video/cx88/cx88xx.ko] undefined!
> ERROR: "ir_repeat" [drivers/media/video/cx88/cx88xx.ko] undefined!
> ERROR: "ir_input_unregister" [drivers/media/video/cx88/cx88xx.ko] undefined!
> ERROR: "ir_keydown" [drivers/media/video/cx88/cx88xx.ko] undefined!
> ERROR: "__ir_input_register" [drivers/media/video/cx88/cx88xx.ko] undefined!
> ERROR: "get_rc_map" [drivers/media/video/bt8xx/bttv.ko] undefined!
> ERROR: "ir_input_unregister" [drivers/media/video/bt8xx/bttv.ko] undefined!
> ERROR: "__ir_input_register" [drivers/media/video/bt8xx/bttv.ko] undefined!
> ERROR: "ir_g_keycode_from_table" [drivers/media/IR/ir-common.ko] undefined!
> 
Randy,

I'm out of the town for a few days due to Linuxcon Brazil. I'll double check it
likely at the weekend.

Cheers,
Mauro
