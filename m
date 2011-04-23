Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189Ab1DWUhA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 16:37:00 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:48522 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755889Ab1DWUg6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 16:36:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type:content-transfer-encoding;
        b=LZf9Eh+izo7YHVEXO5DxPmpUC1sZMpLintKL+P9NNjaINd4afkMjHXJOi/0buig+QO
         JmS2pk/u0OkfiZGcpBoJ1MJupRXIuhJ7eNAGrbtFVjYwRZn4GJd7L4SlRDSxF82f/fu+
         OxK8E2NfzzyWhmDj52APd09/abuqq3QM1cZK8=
MIME-Version: 1.0
In-Reply-To: <AANLkTinApC_rSNWax7fND-vGdLr-UrhNLFekvnVTqKiF@mail.gmail.com>
References: <AANLkTinApC_rSNWax7fND-vGdLr-UrhNLFekvnVTqKiF@mail.gmail.com>
From: Tommaso Massimi <tmassimi@gmail.com>
Date: Sat, 23 Apr 2011 22:36:37 +0200
Message-ID: <BANLkTimYBw5BfZWinUy0OtyhJFXygxKnmg@mail.gmail.com>
Subject: Fwd: [PATCH] Platform: add Samsung Laptop platform driver
To: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

my samsung laptop would be very happy if you add
these lines to the file drivers/platform/x86/samsung-laptop.c

Thanks
Tommaso Massimi

@@ -666,6 +666,15 @@
                },
                .callback = dmi_check_cb,
        },
+               {
+               .ident = "X520",
+               .matches = {
+                       DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS
CO., LTD."),
+                       DMI_MATCH(DMI_PRODUCT_NAME, "X520"),
+                       DMI_MATCH(DMI_BOARD_NAME, "X520"),
+               },
+               .callback = dmi_check_cb,
+       },
        { },
 };
 MODULE_DEVICE_TABLE(dmi, samsung_dmi_table);


---------- Forwarded message ----------
From: Tommaso Massimi <tmassimi@gmail.com>
Date: Fri, Mar 11, 2011 at 6:57 PM
Subject: Re: [PATCH] Platform: add Samsung Laptop platform driver
To: linux-kernel@vger.kernel.org


On 03/10/2011 08:09 PM, Greg KH wrote:
>On Thu, Mar 10, 2011 at 07:28:00PM +0200, Nikolai Kondrashov wrote:
> > On 03/10/2011 07:19 PM, Greg KH wrote:
> > >Can you provide me the output of:
> > > grep . /sys/class/dmi/id/*
> > >so I can try to add support for this machine to the driver?
> > Sure, here it is.
>
> Great, here's a new version of the samsung-laptop.c file, can you
> replace it whereever you were building the previous one, rebuild it and
> test it for this machine to see if it works?

Hi,
here the output you required from my laptop:

tom@localhost tom_samsung]$ grep . /sys/class/dmi/id/*
/sys/class/dmi/id/bios_date:09/21/2009
/sys/class/dmi/id/bios_vendor:Phoenix Technologies Ltd.
/sys/class/dmi/id/bios_version:04IA.M005.20090921.KSY
/sys/class/dmi/id/board_name:X420/X520
grep: /sys/class/dmi/id/board_serial: Permission denied
/sys/class/dmi/id/board_vendor:SAMSUNG ELECTRONICS CO., LTD.
/sys/class/dmi/id/board_version:Not Applicable
/sys/class/dmi/id/chassis_asset_tag:No Asset Tag
grep: /sys/class/dmi/id/chassis_serial: Permission denied
/sys/class/dmi/id/chassis_type:10
/sys/class/dmi/id/chassis_vendor:SAMSUNG ELECTRONICS CO., LTD.
/sys/class/dmi/id/chassis_version:N/A
/sys/class/dmi/id/modalias:dmi:bvnPhoenixTechnologiesLtd.:bvr04IA.M005.20090921.KSY:bd09/21/2009:svnSAMSUNGELECTRONICSCO.,LTD.:pnX420/X520:pvrNotApplicable:rvnSAMSUNGELECTRONICSCO.,LTD.:rnX420/X520:rvrNotApplicable:cvnSAMSUNGELECTRONICSCO.,LTD.:ct10:cvrN/A:
/sys/class/dmi/id/product_name:X420/X520
grep: /sys/class/dmi/id/product_serial: Permission denied
grep: /sys/class/dmi/id/product_uuid: Permission denied
/sys/class/dmi/id/product_version:Not Applicable
/sys/class/dmi/id/sys_vendor:SAMSUNG ELECTRONICS CO., LTD.
/sys/class/dmi/id/uevent:MODALIAS=dmi:bvnPhoenixTechnologiesLtd.:bvr04IA.M005.20090921.KSY:bd09/21/2009:svnSAMSUNGELECTRONICSCO.,LTD.:pnX420/X520:pvrNotApplicable:rvnSAMSUNGELECTRONICSCO.,LTD.:rnX420/X520:rvrNotApplicable:cvnSAMSUNGELECTRONICSCO.,LTD.:ct10:cvrN/A:

I have added these lines to your source file

668a669,677
>               {
>               .ident = "X520",
>               .matches = {
>                       DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
>                       DMI_MATCH(DMI_PRODUCT_NAME, "X520"),
>                       DMI_MATCH(DMI_BOARD_NAME, "X520"),
>               },
>               .callback = dmi_check_cb,
>       },

When I load the module with the option debug=1,
it turns on and off my backligth and my wireless card,
so I think it is working fine.
Here what dmesg says:

samsung_laptop: module is from the staging directory, the quality is
unknown, you have been warned.
samsung_laptop: found laptop model 'X520'
This computer supports SABI==f48b4
SABI header:
 SMI Port Number = 0x00b2
 SMI Interface Function = 0xc0
 SMI enable memory buffer = 0xc1
 SMI restore memory buffer = 0xc2
 SABI data offset = 0x0f00
 SABI data segment = 0xdf01
ifaceP = 0x000dff10
sabi_iface = ffff8800000dff10
backlight = 0x01
backlight should be off
backlight = 0x00
backlight should be on
backlight = 0x01
wireless led = 0x01
wireless led should be off
wireless led = 0x00
wireless led should be on
wireless led = 0x01
brightness = 0x08
atkbd serio0: Unknown key pressed (translated set 2, code 0x89 on
isa0060/serio0).
atkbd serio0: Use 'setkeycodes e009 <keycode>' to make it known.

Now I think I need only to use the setkeycodes command to have
these new commands under my fingers :)

Thanks for that!!

Tom

PS: I'm not subscribed to the list, so please CC me if you need some other info



-- 
With sufficient thrust, pigs fly just fine. However, this is not
necessarily a good idea. It is hard to be sure where they are going to
land, and it could be  dangerous sitting under them as they fly
overhead. -- RFC 1925
