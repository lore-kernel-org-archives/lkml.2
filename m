Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758023Ab0FUQBh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 12:01:37 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:63445 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757152Ab0FUQBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 12:01:34 -0400
Date: Mon, 21 Jun 2010 09:00:49 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de,
       devel@driverdev.osuosl.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for June 21 (staging/easycap)
Message-Id: <20100621090049.c7f11c2d.randy.dunlap@oracle.com>
In-Reply-To: <20100621170056.2fcf10ad.sfr@canb.auug.org.au>
References: <20100621170056.2fcf10ad.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090206.4C1F8CD5.0033:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jun 2010 17:00:56 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20100618:


When CONFIG_USB is not enabled:

ERROR: "usb_kill_urb" [drivers/staging/easycap/easycap.ko] undefined!
ERROR: "usb_deregister_dev" [drivers/staging/easycap/easycap.ko] undefined!
ERROR: "video_register_device" [drivers/staging/easycap/easycap.ko] undefined!
ERROR: "usb_deregister" [drivers/staging/easycap/easycap.ko] undefined!
ERROR: "video_unregister_device" [drivers/staging/easycap/easycap.ko] undefined!
ERROR: "usb_set_interface" [drivers/staging/easycap/easycap.ko] undefined!
ERROR: "usb_register_dev" [drivers/staging/easycap/easycap.ko] undefined!
ERROR: "usb_control_msg" [drivers/staging/easycap/easycap.ko] undefined!
ERROR: "usb_submit_urb" [drivers/staging/easycap/easycap.ko] undefined!
ERROR: "usb_get_dev" [drivers/staging/easycap/easycap.ko] undefined!
ERROR: "usb_find_interface" [drivers/staging/easycap/easycap.ko] undefined!
ERROR: "usb_register_driver" [drivers/staging/easycap/easycap.ko] undefined!
ERROR: "usb_free_urb" [drivers/staging/easycap/easycap.ko] undefined!
ERROR: "usb_alloc_urb" [drivers/staging/easycap/easycap.ko] undefined!


Adding "depends on USB" to EASYCAP is a good start.
After that and enabling CONFIG_USB, build of easycap gets:

ERROR: "video_register_device" [drivers/staging/easycap/easycap.ko] undefined!
ERROR: "video_unregister_device" [drivers/staging/easycap/easycap.ko] undefined!

because there is no media/video support enabled.  Also no SOUND enabled,
so I expect there to be build errors associated with sound also, meaning that
the Kconfig file should probably modified with something like

config EASYCAP
+	depends on USB && VIDEO_DEV && SND


This is something that the driver author should know the answer to and submit a
patch for.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
