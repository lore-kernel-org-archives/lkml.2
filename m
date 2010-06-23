Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168Ab0FWSHy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 14:07:54 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:39686 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327Ab0FWSHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 14:07:53 -0400
Message-ID: <4C224D26.1020307@oracle.com>
Date: Wed, 23 Jun 2010 11:06:30 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de,
       devel@driverdev.osuosl.org, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for June 21 (staging/easycap)
References: <20100621170056.2fcf10ad.sfr@canb.auug.org.au> <20100621090049.c7f11c2d.randy.dunlap@oracle.com> <20100622223612.GB3898@kroah.com>
In-Reply-To: <20100622223612.GB3898@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090201.4C224D6F.00E1:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Mon, Jun 21, 2010 at 09:00:49AM -0700, Randy Dunlap wrote:
>> On Mon, 21 Jun 2010 17:00:56 +1000 Stephen Rothwell wrote:
>>
>>> Hi all,
>>>
>>> Changes since 20100618:
>>
>> When CONFIG_USB is not enabled:
>>
>> ERROR: "usb_kill_urb" [drivers/staging/easycap/easycap.ko] undefined!
>> ERROR: "usb_deregister_dev" [drivers/staging/easycap/easycap.ko] undefined!
>> ERROR: "video_register_device" [drivers/staging/easycap/easycap.ko] undefined!
>> ERROR: "usb_deregister" [drivers/staging/easycap/easycap.ko] undefined!
>> ERROR: "video_unregister_device" [drivers/staging/easycap/easycap.ko] undefined!
>> ERROR: "usb_set_interface" [drivers/staging/easycap/easycap.ko] undefined!
>> ERROR: "usb_register_dev" [drivers/staging/easycap/easycap.ko] undefined!
>> ERROR: "usb_control_msg" [drivers/staging/easycap/easycap.ko] undefined!
>> ERROR: "usb_submit_urb" [drivers/staging/easycap/easycap.ko] undefined!
>> ERROR: "usb_get_dev" [drivers/staging/easycap/easycap.ko] undefined!
>> ERROR: "usb_find_interface" [drivers/staging/easycap/easycap.ko] undefined!
>> ERROR: "usb_register_driver" [drivers/staging/easycap/easycap.ko] undefined!
>> ERROR: "usb_free_urb" [drivers/staging/easycap/easycap.ko] undefined!
>> ERROR: "usb_alloc_urb" [drivers/staging/easycap/easycap.ko] undefined!
>>
>>
>> Adding "depends on USB" to EASYCAP is a good start.
>> After that and enabling CONFIG_USB, build of easycap gets:
>>
>> ERROR: "video_register_device" [drivers/staging/easycap/easycap.ko] undefined!
>> ERROR: "video_unregister_device" [drivers/staging/easycap/easycap.ko] undefined!
>>
>> because there is no media/video support enabled.  Also no SOUND enabled,
>> so I expect there to be build errors associated with sound also, meaning that
>> the Kconfig file should probably modified with something like
>>
>> config EASYCAP
>> +	depends on USB && VIDEO_DEV && SND
>>
>>
>> This is something that the driver author should know the answer to and submit a
>> patch for.
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

> 
> You are right, care to make up a patch for this?

No thanks, please see my last statement above.
IOW, I want the driver developer (not you) to act responsibly on this.
