Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642Ab2KHP17 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 10:27:59 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:48345 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898Ab2KHP15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 10:27:57 -0500
MIME-Version: 1.0
Date: Thu, 8 Nov 2012 21:27:56 +0600
Message-ID: <CAAF_D9g6yVTjicJ+8hmumNkd1ko2eek9+OaskDeyjrKFwqzN_A@mail.gmail.com>
Subject: Re: [PATCH] bcm_wimax.ko - Modified supported device list [Correction]
From: Muhammad Minhazul Haque <mdminhazulhaque@gmail.com>
To: Kevin McKinney <klmckinney1@gmail.com>, linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rinat Camalov <richman1000000d@gmail.com>, devel@driverdev.osuosl.org
Content-Type: multipart/mixed; boundary=f46d0438905bbe2da304cdfd7a37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f46d0438905bbe2da304cdfd7a37
Content-Type: text/plain; charset=UTF-8

Mr. Kevin and everyone,

There was a serious mistake in the previous message. I forgot to
attach the patch. Please ignore it. I am posting it again.

I was never reported for that product id 0x0132. Yet you can continue
support for it if it is rare. In the meantime, we can add more devices
to the header and add those names to "usb_device_id" table in
"InterfaceInit.c". I added a new product string
"BCM_USB_PRODUCT_ID_ZTE_326" and also modified the device id table.

Again, I removed product if 0xbccd because Beceem, ZTE, Sprint use
this id for the block device containing device driver. Again, this is
always switched to base product id via udev. Here is my dmesg output
when udev is turned off.
=====
root@inspiron:~# dmesg -c
[24449.439134] cdrom: issuing MRW background format suspend
[24459.102669] usb 2-1.2: new high-speed USB device number 11 using ehci_hcd
[24459.336258] scsi11 : usb-storage 2-1.2:1.0
[24460.334906] scsi 11:0:0:0: CD-ROM            BCM-CD V 01.02 01.01
1.13      PQ: 0 ANSI: 2
[24460.336721] sr0: scsi3-mmc drive: 0x/0x xa/form2 tray
[24460.336971] sr 11:0:0:0: Attached scsi CD-ROM sr0
[24460.337167] sr 11:0:0:0: Attached scsi generic sg1 type 5

root@inspiron:~# mount /dev/sr1 /media/tmp
mount: block device /dev/sr1 is write-protected, mounting read-only
=====

I did build after these changes and probed the module. It works
perfectly. I also tested 0x0172 and 0x0173. No error is reported. So I
assure that these products are valid. Not sure about 0x0132. Here is
the modinfo output.
=====
license:        GPL
version:        5.2.45
description:    Beceem Communications Inc. WiMAX driver
srcversion:     6968AC3635745331FE6470D
alias:          usb:v19D2p0132d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v19D2p0007d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v19D2p0173d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v19D2p0172d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0489pE017d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v198Fp015Ed*dc*dsc*dp*ic*isc*ip*
alias:          usb:v198Fp0300d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v198Fp0220d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v198Fp0210d*dc*dsc*dp*ic*isc*ip*
depends:
vermagic:       3.2.0-32-generic-pae SMP mod_unload modversions 686
parm:           debug:Debug level (0=none,...,16=all) (uint)
=====

This patch is currently against a linux 3.7-rc4 kernel, for the x86
architecture.

The first patch is
=====
diff --git a/bcm.orig/InterfaceInit.c b/bcm/InterfaceInit.c
index b05f5f7..7da666e 100644
--- a/bcm.orig/InterfaceInit.c
+++ b/bcm/InterfaceInit.c
@@ -4,11 +4,12 @@ static struct usb_device_id InterfaceUsbtable[] = {
 	{ USB_DEVICE(BCM_USB_VENDOR_ID_T3, BCM_USB_PRODUCT_ID_T3) },
 	{ USB_DEVICE(BCM_USB_VENDOR_ID_T3, BCM_USB_PRODUCT_ID_T3B) },
 	{ USB_DEVICE(BCM_USB_VENDOR_ID_T3, BCM_USB_PRODUCT_ID_T3L) },
-	{ USB_DEVICE(BCM_USB_VENDOR_ID_T3, BCM_USB_PRODUCT_ID_SM250) },
-	{ USB_DEVICE(BCM_USB_VENDOR_ID_ZTE, BCM_USB_PRODUCT_ID_226) },
+	{ USB_DEVICE(BCM_USB_VENDOR_ID_T3, BCM_USB_PRODUCT_ID_SYM) },
 	{ USB_DEVICE(BCM_USB_VENDOR_ID_FOXCONN, BCM_USB_PRODUCT_ID_1901) },
+	{ USB_DEVICE(BCM_USB_VENDOR_ID_ZTE, BCM_USB_PRODUCT_ID_226) },
 	{ USB_DEVICE(BCM_USB_VENDOR_ID_ZTE, BCM_USB_PRODUCT_ID_ZTE_TU25) },
 	{ USB_DEVICE(BCM_USB_VENDOR_ID_ZTE, BCM_USB_PRODUCT_ID_ZTE_226) },
+	{ USB_DEVICE(BCM_USB_VENDOR_ID_ZTE, BCM_USB_PRODUCT_ID_ZTE_326) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, InterfaceUsbtable);
=====

And the second patch is
=====
diff --git a/bcm.orig/InterfaceInit.h b/bcm/InterfaceInit.h
index 866924e..1486608 100644
--- a/bcm.orig/InterfaceInit.h
+++ b/bcm/InterfaceInit.h
@@ -8,11 +8,11 @@
 #define BCM_USB_PRODUCT_ID_T3	0x0300
 #define BCM_USB_PRODUCT_ID_T3B	0x0210
 #define BCM_USB_PRODUCT_ID_T3L	0x0220
-#define BCM_USB_PRODUCT_ID_SM250	0xbccd
 #define BCM_USB_PRODUCT_ID_SYM	0x15E
-#define BCM_USB_PRODUCT_ID_1901	0xe017
+#define BCM_USB_PRODUCT_ID_1901	0xe017 /* Sprint U1901 */
 #define BCM_USB_PRODUCT_ID_226	0x0132 /* not sure if this is valid */
 #define BCM_USB_PRODUCT_ID_ZTE_226 0x172
+#define BCM_USB_PRODUCT_ID_ZTE_326 0x173 /* ZTE AX326 */
 #define BCM_USB_PRODUCT_ID_ZTE_TU25	0x0007

 #define BCM_USB_MINOR_BASE	192
=====

diffstat for this patch is:
=====
 {bcm => bcm.orig}/InterfaceInit.c |    5 ++---
 {bcm => bcm.orig}/InterfaceInit.h |    4 ++--
 2 files changed, 4 insertions(+), 5 deletions(-)
=====

To use the patch, remove module if it is probed. Build, and then probe.

About the TODO: I currently have a solution to make the device work.
It is not from Intel's wimax stack. I used Beceem's API. Can we
discuss on this?

Please let me know any feedback you have on this patch or the approach used.

Thanks,
Muhammad Minhazul Haque

Signed-off-by: Muhammad Minhazul Haque <mdminhazulhaque@gmail.com>


On 11/8/12, Muhammad Minhazul Haque <mdminhazulhaque@gmail.com> wrote:
> Mr. Kevin,
>
> I was never reported for that product id 0x0132. Yet you can continue
> support for it if it is rare. In the meantime, we can add more devices
> to the header and add those names to "usb_device_id" table in
> "InterfaceInit.c". I added a new product string
> "BCM_USB_PRODUCT_ID_ZTE_326" and also modified the device id table.
>
> Again, I removed product if 0xbccd because Beceem, ZTE, Sprint use
> this id for the block device containing device driver. Again, this is
> always switched to base product id via udev. Here is my dmesg output
> when udev is turned off.
> =====
> root@inspiron:~# dmesg -c
> [24449.439134] cdrom: issuing MRW background format suspend
> [24459.102669] usb 2-1.2: new high-speed USB device number 11 using
> ehci_hcd
> [24459.336258] scsi11 : usb-storage 2-1.2:1.0
> [24460.334906] scsi 11:0:0:0: CD-ROM            BCM-CD V 01.02 01.01
> 1.13      PQ: 0 ANSI: 2
> [24460.336721] sr0: scsi3-mmc drive: 0x/0x xa/form2 tray
> [24460.336971] sr 11:0:0:0: Attached scsi CD-ROM sr0
> [24460.337167] sr 11:0:0:0: Attached scsi generic sg1 type 5
>
> root@inspiron:~# mount /dev/sr1 /media/tmp
> mount: block device /dev/sr1 is write-protected, mounting read-only
> =====
>
> I did build after these changes and probed the module. It works
> perfectly. I also tested 0x0172 and 0x0173. No error is reported. So I
> assure that these products are valid. Not sure about 0x0132. Here is
> the modinfo output.
> =====
> license:        GPL
> version:        5.2.45
> description:    Beceem Communications Inc. WiMAX driver
> srcversion:     6968AC3635745331FE6470D
> alias:          usb:v19D2p0132d*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v19D2p0007d*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v19D2p0173d*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v19D2p0172d*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v0489pE017d*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v198Fp015Ed*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v198Fp0300d*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v198Fp0220d*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v198Fp0210d*dc*dsc*dp*ic*isc*ip*
> depends:
> vermagic:       3.2.0-32-generic-pae SMP mod_unload modversions 686
> parm:           debug:Debug level (0=none,...,16=all) (uint)
> =====
>
> This patch is currently against a linux 3.7-rc4 kernel, for the x86
> architecture.
>
> diffstat for this patch is:
> =====
>  {bcm => bcm.orig}/InterfaceInit.c |    5 ++---
>  {bcm => bcm.orig}/InterfaceInit.h |    4 ++--
>  2 files changed, 4 insertions(+), 5 deletions(-)
> =====
>
> To use the patch, remove module if it is probed. Build, and then probe.
>
> About the TODO: I currently have a solution to make the device work.
> It is not from Intel's wimax stack. I used Beceem's API. Can we
> discuss on this?
>
> Please let me know any feedback you have on this patch or the approach
> used.
>
> Thanks,
> Muhammad Minhazul Haque
>
> Signed-off-by: Muhammad Minhazul Haque <mdminhazulhaque@gmail.com>
>
> On Wed, Nov 7, 2012 at 10:06 PM, Kevin McKinney <klmckinney1@gmail.com>
> wrote:
>> On Wed, Nov 7, 2012 at 3:21 AM, Greg Kroah-Hartman
>> <gregkh@linux-foundation.org> wrote:
>>> Hi Muhammad, Linus forwarded me your email about this topic, hope that's
>>> ok.  See the bottom for my comments, the entire email is quoted to get
>>> Kevin up to speed on this.
>>>
>>>> ---------- Forwarded message ----------
>>>> From: "Muhammad Minhazul Haque" <mdminhazulhaque@gmail.com>
>>>> Date: Nov 5, 2012 7:00 PM
>>>> Subject: About Beceem WiMAX Module
>>>> To: <torvalds@linux-foundation.org>
>>>>
>>>> Hello Sir,
>>>>
>>>> I have an issue with a module named "bcm_wimax". This is a staging
>>>> module located at linux/drivers/staging/bcm. The problem is that, the
>>>> supported devices listed in the module are not all valid or there are
>>>> more to be added.
>>>>
>>>> "modinfo bcm_wimax" returns the supported product and vendor ids.
>>>>
>>>> ...
>>>> alias:          usb:v19D2p0007d*dc*dsc*dp*ic*isc*ip*
>>>> alias:          usb:v0489pE017d*dc*dsc*dp*ic*isc*ip*
>>>> alias:          usb:v19D2p0132d*dc*dsc*dp*ic*isc*ip*
>>>> alias:          usb:v198FpBCCDd*dc*dsc*dp*ic*isc*ip*
>>>> alias:          usb:v198Fp0220d*dc*dsc*dp*ic*isc*ip*
>>>> alias:          usb:v198Fp0210d*dc*dsc*dp*ic*isc*ip*
>>>> alias:          usb:v198Fp0300d*dc*dsc*dp*ic*isc*ip*
>>>> ...
>>>>
>>>> Here the product id 198f:bccd is obsolete cause it is a storage device
>>>> to load device driver which uses module "usb_storage". There are more
>>>> devices with id 19d2:0172, 19d2:0173 and so on. They all have
>>>> "beceXXXX" chip inside and the module "bcm_wimax" works fine with
>>>> them. The only problem is, custom modules are to be build before using
>>>> them and remove the original one. It would be great if more device id
>>>> is added and remove which are rarely used. I often get emails from
>>
>> If device id "0x132" is rarely used, then I think we still have to support
>> it.
>>
>>>> people using Virgin Mobile U760, Franklin Wireless u600 etc which have
>>>> another device ids.
>>>>
>>>> I did a commit on your repo at
>>>> https://github.com/torvalds/linux/blob/master/drivers/staging/bcm/
>>>> InterfaceInit.h.
>>>>
>>>> At line 14, the following text
>>>>
>>>> #define BCM_USB_PRODUCT_ID_226 0x0132 /* not sure if this is valid */
>>>>
>>>> was changed to
>>>>
>>>> #define BCM_USB_PRODUCT_ID_226 0x0173 /* ZTE AX326 */
>>>>
>>>> Shouldn't this be approved?
>>>>
>>>> I have devices with id 19d2:0172, 19d2:0173, 198f:015e also. So if any
>>>> help will be provided if anyone is interested. Feel free to ask any
>>>> question regarding this device/module/api.
>>>
>>> Kevin, you added the "not sure if this is valid" comment here, should it
>>> be removed?  And we should just add the 0x173 device id also, right?
>>
>> I submitted a patch a while back (Sep 11, 2012) to add device id of
>> "0x172" to the staging-next branch.  I did not remove device id of
>> "0x132" because I was not certain if it was valid. If Muhammad can
>> confirm that this device id is not needed, then we should remove it.
>> However, if it is used, but only rarely; I think we still need to
>> support it.
>>
>> Muhammad, is that device id totally invalid, or is it valid but rarely
>> used?
>>
>>> Muhammad, can you send me a patch for this in the format described in
>>> Documentation/SubmittingPatches so that I can add the new device id to
>>> the driver?  And if you have people reporting other device ids, please
>>> also send on those changes as well.
>>>
>>
>> Thanks,
>> Kevin
>


-- 

*MD: Minhazul Haque,*
CSE 10, RUET
Rajshahi
about.me/mdminhazulhaque

--f46d0438905bbe2da304cdfd7a37
Content-Type: text/x-patch; charset=US-ASCII; name="001-InterfaceInit.c.patch"
Content-Disposition: attachment; filename="001-InterfaceInit.c.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: file1

ZGlmZiAtLWdpdCBhL2JjbS5vcmlnL0ludGVyZmFjZUluaXQuYyBiL2JjbS9JbnRlcmZhY2VJbml0
LmMKaW5kZXggYjA1ZjVmNy4uN2RhNjY2ZSAxMDA2NDQKLS0tIGEvYmNtLm9yaWcvSW50ZXJmYWNl
SW5pdC5jCisrKyBiL2JjbS9JbnRlcmZhY2VJbml0LmMKQEAgLTQsMTEgKzQsMTIgQEAgc3RhdGlj
IHN0cnVjdCB1c2JfZGV2aWNlX2lkIEludGVyZmFjZVVzYnRhYmxlW10gPSB7CiAJeyBVU0JfREVW
SUNFKEJDTV9VU0JfVkVORE9SX0lEX1QzLCBCQ01fVVNCX1BST0RVQ1RfSURfVDMpIH0sCiAJeyBV
U0JfREVWSUNFKEJDTV9VU0JfVkVORE9SX0lEX1QzLCBCQ01fVVNCX1BST0RVQ1RfSURfVDNCKSB9
LAogCXsgVVNCX0RFVklDRShCQ01fVVNCX1ZFTkRPUl9JRF9UMywgQkNNX1VTQl9QUk9EVUNUX0lE
X1QzTCkgfSwKLQl7IFVTQl9ERVZJQ0UoQkNNX1VTQl9WRU5ET1JfSURfVDMsIEJDTV9VU0JfUFJP
RFVDVF9JRF9TTTI1MCkgfSwKLQl7IFVTQl9ERVZJQ0UoQkNNX1VTQl9WRU5ET1JfSURfWlRFLCBC
Q01fVVNCX1BST0RVQ1RfSURfMjI2KSB9LAorCXsgVVNCX0RFVklDRShCQ01fVVNCX1ZFTkRPUl9J
RF9UMywgQkNNX1VTQl9QUk9EVUNUX0lEX1NZTSkgfSwKIAl7IFVTQl9ERVZJQ0UoQkNNX1VTQl9W
RU5ET1JfSURfRk9YQ09OTiwgQkNNX1VTQl9QUk9EVUNUX0lEXzE5MDEpIH0sCisJeyBVU0JfREVW
SUNFKEJDTV9VU0JfVkVORE9SX0lEX1pURSwgQkNNX1VTQl9QUk9EVUNUX0lEXzIyNikgfSwKIAl7
IFVTQl9ERVZJQ0UoQkNNX1VTQl9WRU5ET1JfSURfWlRFLCBCQ01fVVNCX1BST0RVQ1RfSURfWlRF
X1RVMjUpIH0sCiAJeyBVU0JfREVWSUNFKEJDTV9VU0JfVkVORE9SX0lEX1pURSwgQkNNX1VTQl9Q
Uk9EVUNUX0lEX1pURV8yMjYpIH0sCisJeyBVU0JfREVWSUNFKEJDTV9VU0JfVkVORE9SX0lEX1pU
RSwgQkNNX1VTQl9QUk9EVUNUX0lEX1pURV8zMjYpIH0sCiAJeyB9CiB9OwogTU9EVUxFX0RFVklD
RV9UQUJMRSh1c2IsIEludGVyZmFjZVVzYnRhYmxlKTsK
--f46d0438905bbe2da304cdfd7a37
Content-Type: text/x-patch; charset=US-ASCII; name="002-InterfaceInit.h.patch"
Content-Disposition: attachment; filename="002-InterfaceInit.h.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: file2

ZGlmZiAtLWdpdCBhL2JjbS5vcmlnL0ludGVyZmFjZUluaXQuaCBiL2JjbS9JbnRlcmZhY2VJbml0
LmgKaW5kZXggODY2OTI0ZS4uMTQ4NjYwOCAxMDA2NDQKLS0tIGEvYmNtLm9yaWcvSW50ZXJmYWNl
SW5pdC5oCisrKyBiL2JjbS9JbnRlcmZhY2VJbml0LmgKQEAgLTgsMTEgKzgsMTEgQEAKICNkZWZp
bmUgQkNNX1VTQl9QUk9EVUNUX0lEX1QzCTB4MDMwMAogI2RlZmluZSBCQ01fVVNCX1BST0RVQ1Rf
SURfVDNCCTB4MDIxMAogI2RlZmluZSBCQ01fVVNCX1BST0RVQ1RfSURfVDNMCTB4MDIyMAotI2Rl
ZmluZSBCQ01fVVNCX1BST0RVQ1RfSURfU00yNTAJMHhiY2NkCiAjZGVmaW5lIEJDTV9VU0JfUFJP
RFVDVF9JRF9TWU0JMHgxNUUKLSNkZWZpbmUgQkNNX1VTQl9QUk9EVUNUX0lEXzE5MDEJMHhlMDE3
CisjZGVmaW5lIEJDTV9VU0JfUFJPRFVDVF9JRF8xOTAxCTB4ZTAxNyAvKiBTcHJpbnQgVTE5MDEg
Ki8KICNkZWZpbmUgQkNNX1VTQl9QUk9EVUNUX0lEXzIyNgkweDAxMzIgLyogbm90IHN1cmUgaWYg
dGhpcyBpcyB2YWxpZCAqLwogI2RlZmluZSBCQ01fVVNCX1BST0RVQ1RfSURfWlRFXzIyNiAweDE3
MgorI2RlZmluZSBCQ01fVVNCX1BST0RVQ1RfSURfWlRFXzMyNiAweDE3MyAvKiBaVEUgQVgzMjYg
Ki8KICNkZWZpbmUgQkNNX1VTQl9QUk9EVUNUX0lEX1pURV9UVTI1CTB4MDAwNwogCiAjZGVmaW5l
IEJDTV9VU0JfTUlOT1JfQkFTRQkxOTIK
--f46d0438905bbe2da304cdfd7a37--
