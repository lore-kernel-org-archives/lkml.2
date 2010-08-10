Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757756Ab0HJOuE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 10:50:04 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:26919 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757773Ab0HJOt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 10:49:58 -0400
Message-ID: <4C6166D9.60607@oracle.com>
Date: Tue, 10 Aug 2010 07:48:57 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de,
        lud <linux-usb@vger.kernel.org>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [patch -NEXT] usb/gadget/webcam: fix Kconfig depends again
References: <20100809132314.789e13f3.sfr@canb.auug.org.au> <20100809105520.d17e4795.randy.dunlap@oracle.com> <201008101416.31188.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201008101416.31188.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/10 05:16, Laurent Pinchart wrote:
> Hi Randy,
> 
> Thanks for the patch.
> 
> On Monday 09 August 2010 19:55:20 Randy Dunlap wrote:
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> The USB gadget webcam driver uses V4L2 interfaces, so it should depend
>> on VIDEO_V4L2 instead of VIDEO_DEV.  This fixes a lot of build errors
>> when V4L2 is not enabled:
>>
>> ERROR: "v4l2_event_unsubscribe" [drivers/usb/gadget/g_webcam.ko] undefined!
>> ERROR: "v4l2_event_queue" [drivers/usb/gadget/g_webcam.ko] undefined!
>> ERROR: "video_device_release" [drivers/usb/gadget/g_webcam.ko] undefined!
>> ERROR: "video_usercopy" [drivers/usb/gadget/g_webcam.ko] undefined!
>> ERROR: "v4l2_event_dequeue" [drivers/usb/gadget/g_webcam.ko] undefined!
>> ERROR: "video_register_device" [drivers/usb/gadget/g_webcam.ko] undefined!
>> ERROR: "video_device_alloc" [drivers/usb/gadget/g_webcam.ko] undefined!
>> ERROR: "v4l2_event_subscribe" [drivers/usb/gadget/g_webcam.ko] undefined!
>> ERROR: "video_unregister_device" [drivers/usb/gadget/g_webcam.ko]
>> undefined!
>> ERROR: "v4l2_fh_init" [drivers/usb/gadget/g_webcam.ko] undefined!
>> ERROR: "v4l2_event_pending" [drivers/usb/gadget/g_webcam.ko] undefined!
>> ERROR: "v4l2_event_init" [drivers/usb/gadget/g_webcam.ko] undefined!
>> ERROR: "video_devdata" [drivers/usb/gadget/g_webcam.ko] undefined!
>> ERROR: "v4l2_event_alloc" [drivers/usb/gadget/g_webcam.ko] undefined!
>> ERROR: "v4l2_fh_add" [drivers/usb/gadget/g_webcam.ko] undefined!
>> ERROR: "v4l2_fh_del" [drivers/usb/gadget/g_webcam.ko] undefined!
>> ERROR: "v4l2_fh_exit" [drivers/usb/gadget/g_webcam.ko] undefined!
> 
> All those symbols should be defined when VIDEO_DEV is selected.
> 
>> ERROR: "v4l2_ctrl_fill" [drivers/media/video/v4l2-common.ko] undefined!
>> ERROR: "v4l2_ctrl_get_menu" [drivers/media/video/v4l2-common.ko] undefined!
> 
> Those 2 symbols require VIDEO_V4L2 but are not used by the webcam gadget 
> driver.
> 
>> ERROR: "v4l2_device_unregister_subdev" [drivers/media/video/v4l2-common.ko]
>> undefined!
>> ERROR: "v4l2_device_register_subdev" [drivers/media/video/v4l2-common.ko]
>> undefined!
> 
> Those two symbols should be defined when VIDEO_DEV is selected. They are not 
> used by the webcam gadget driver.
> 

Summary:  I should drop this patch and look elsewhere for the problem,
Right?

Thanks for your help.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
