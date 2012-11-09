Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751Ab2KIOR6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 09:17:58 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:62287 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534Ab2KIORz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 09:17:55 -0500
MIME-Version: 1.0
In-Reply-To: <CAKPrQY8mgiihYSfH3qDmchny5EfjfBxXDtC0=fBRiQ3VAhdewA@mail.gmail.com>
References: <CAAF_D9g6yVTjicJ+8hmumNkd1ko2eek9+OaskDeyjrKFwqzN_A@mail.gmail.com>
	<CAKPrQY8mgiihYSfH3qDmchny5EfjfBxXDtC0=fBRiQ3VAhdewA@mail.gmail.com>
Date: Fri, 9 Nov 2012 09:17:52 -0500
Message-ID: <CAKPrQY_fMr3-uQYOKo7z7_DCx+vfzCc3dQf9y-0keJWGhB=NYw@mail.gmail.com>
Subject: Re: [PATCH] bcm_wimax.ko - Modified supported device list [Correction]
From: Kevin McKinney <klmckinney1@gmail.com>
To: Muhammad Minhazul Haque <mdminhazulhaque@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rinat Camalov <richman1000000d@gmail.com>, devel@driverdev.osuosl.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 8, 2012 at 11:30 PM, Kevin McKinney <klmckinney1@gmail.com> wrote:
> On Thu, Nov 8, 2012 at 10:27 AM, Muhammad Minhazul Haque
> <mdminhazulhaque@gmail.com> wrote:
>> Mr. Kevin and everyone,

Also, no need to call me "Mr." ; I am not that important :)

>> There was a serious mistake in the previous message. I forgot to
>> attach the patch. Please ignore it. I am posting it again.
>>
>> I was never reported for that product id 0x0132. Yet you can continue
>> support for it if it is rare. In the meantime, we can add more devices
>> to the header and add those names to "usb_device_id" table in
>> "InterfaceInit.c". I added a new product string
>> "BCM_USB_PRODUCT_ID_ZTE_326" and also modified the device id table.
>>
>> Again, I removed product if 0xbccd because Beceem, ZTE, Sprint use
>> this id for the block device containing device driver. Again, this is
>> always switched to base product id via udev. Here is my dmesg output
>> when udev is turned off.
>> =====
>> root@inspiron:~# dmesg -c
>> [24449.439134] cdrom: issuing MRW background format suspend
>> [24459.102669] usb 2-1.2: new high-speed USB device number 11 using ehci_hcd
>> [24459.336258] scsi11 : usb-storage 2-1.2:1.0
>> [24460.334906] scsi 11:0:0:0: CD-ROM            BCM-CD V 01.02 01.01
>> 1.13      PQ: 0 ANSI: 2
>> [24460.336721] sr0: scsi3-mmc drive: 0x/0x xa/form2 tray
>> [24460.336971] sr 11:0:0:0: Attached scsi CD-ROM sr0
>> [24460.337167] sr 11:0:0:0: Attached scsi generic sg1 type 5
>>
>> root@inspiron:~# mount /dev/sr1 /media/tmp
>> mount: block device /dev/sr1 is write-protected, mounting read-only
>> =====
>>
>> I did build after these changes and probed the module. It works
>> perfectly. I also tested 0x0172 and 0x0173. No error is reported. So I
>> assure that these products are valid. Not sure about 0x0132. Here is
>> the modinfo output.
>> =====
>> license:        GPL
>> version:        5.2.45
>> description:    Beceem Communications Inc. WiMAX driver
>> srcversion:     6968AC3635745331FE6470D
>> alias:          usb:v19D2p0132d*dc*dsc*dp*ic*isc*ip*
>> alias:          usb:v19D2p0007d*dc*dsc*dp*ic*isc*ip*
>> alias:          usb:v19D2p0173d*dc*dsc*dp*ic*isc*ip*
>> alias:          usb:v19D2p0172d*dc*dsc*dp*ic*isc*ip*
>> alias:          usb:v0489pE017d*dc*dsc*dp*ic*isc*ip*
>> alias:          usb:v198Fp015Ed*dc*dsc*dp*ic*isc*ip*
>> alias:          usb:v198Fp0300d*dc*dsc*dp*ic*isc*ip*
>> alias:          usb:v198Fp0220d*dc*dsc*dp*ic*isc*ip*
>> alias:          usb:v198Fp0210d*dc*dsc*dp*ic*isc*ip*
>> depends:
>> vermagic:       3.2.0-32-generic-pae SMP mod_unload modversions 686
>> parm:           debug:Debug level (0=none,...,16=all) (uint)
>> =====
>>
>> This patch is currently against a linux 3.7-rc4 kernel, for the x86
>> architecture.
>>
>> The first patch is
>> =====
>> diff --git a/bcm.orig/InterfaceInit.c b/bcm/InterfaceInit.c
>> index b05f5f7..7da666e 100644
>> --- a/bcm.orig/InterfaceInit.c
>> +++ b/bcm/InterfaceInit.c
>> @@ -4,11 +4,12 @@ static struct usb_device_id InterfaceUsbtable[] = {
>>         { USB_DEVICE(BCM_USB_VENDOR_ID_T3, BCM_USB_PRODUCT_ID_T3) },
>>         { USB_DEVICE(BCM_USB_VENDOR_ID_T3, BCM_USB_PRODUCT_ID_T3B) },
>>         { USB_DEVICE(BCM_USB_VENDOR_ID_T3, BCM_USB_PRODUCT_ID_T3L) },
>> -       { USB_DEVICE(BCM_USB_VENDOR_ID_T3, BCM_USB_PRODUCT_ID_SM250) },
>> -       { USB_DEVICE(BCM_USB_VENDOR_ID_ZTE, BCM_USB_PRODUCT_ID_226) },
>> +       { USB_DEVICE(BCM_USB_VENDOR_ID_T3, BCM_USB_PRODUCT_ID_SYM) },
>>         { USB_DEVICE(BCM_USB_VENDOR_ID_FOXCONN, BCM_USB_PRODUCT_ID_1901) },
>> +       { USB_DEVICE(BCM_USB_VENDOR_ID_ZTE, BCM_USB_PRODUCT_ID_226) },
>>         { USB_DEVICE(BCM_USB_VENDOR_ID_ZTE, BCM_USB_PRODUCT_ID_ZTE_TU25) },
>>         { USB_DEVICE(BCM_USB_VENDOR_ID_ZTE, BCM_USB_PRODUCT_ID_ZTE_226) },
>> +       { USB_DEVICE(BCM_USB_VENDOR_ID_ZTE, BCM_USB_PRODUCT_ID_ZTE_326) },
>>         { }
>>  };
>>  MODULE_DEVICE_TABLE(usb, InterfaceUsbtable);
>> =====
>>
>> And the second patch is
>> =====
>> diff --git a/bcm.orig/InterfaceInit.h b/bcm/InterfaceInit.h
>> index 866924e..1486608 100644
>> --- a/bcm.orig/InterfaceInit.h
>> +++ b/bcm/InterfaceInit.h
>> @@ -8,11 +8,11 @@
>>  #define BCM_USB_PRODUCT_ID_T3  0x0300
>>  #define BCM_USB_PRODUCT_ID_T3B 0x0210
>>  #define BCM_USB_PRODUCT_ID_T3L 0x0220
>> -#define BCM_USB_PRODUCT_ID_SM250       0xbccd
>>  #define BCM_USB_PRODUCT_ID_SYM 0x15E
>> -#define BCM_USB_PRODUCT_ID_1901        0xe017
>> +#define BCM_USB_PRODUCT_ID_1901        0xe017 /* Sprint U1901 */
>>  #define BCM_USB_PRODUCT_ID_226 0x0132 /* not sure if this is valid */
>>  #define BCM_USB_PRODUCT_ID_ZTE_226 0x172
>> +#define BCM_USB_PRODUCT_ID_ZTE_326 0x173 /* ZTE AX326 */
>>  #define BCM_USB_PRODUCT_ID_ZTE_TU25    0x0007
>>
>>  #define BCM_USB_MINOR_BASE     192
>> =====
>>
>> diffstat for this patch is:
>> =====
>>  {bcm => bcm.orig}/InterfaceInit.c |    5 ++---
>>  {bcm => bcm.orig}/InterfaceInit.h |    4 ++--
>>  2 files changed, 4 insertions(+), 5 deletions(-)
>> =====
>
> Thanks for these patches. I see the changes you have made a they look
> good, however I am not able to apply these patches. Can you resubmit
> them in the correct format?
>
>> To use the patch, remove module if it is probed. Build, and then probe.
>>
>> About the TODO: I currently have a solution to make the device work.
>> It is not from Intel's wimax stack. I used Beceem's API. Can we
>> discuss on this?
>
> Sure, lets work together to get this device working.  It should be
> working correctly on 32 bit machines, however there is still an
> outstanding bug that I am trying to track down on 64 bit machines.
> Have you noticed this also?
>
> Thanks,
> Kevin
