Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312Ab2KER6d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 12:58:33 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:48419 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754467Ab2KER6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 12:58:32 -0500
MIME-Version: 1.0
From: Muhammad Minhazul Haque <mdminhazulhaque@gmail.com>
Date: Mon, 5 Nov 2012 23:57:50 +0600
Message-ID: <CAAF_D9h+y1bmgbBnK1CHd5vBa_jjG0Z4JfFivR2=AVgfRcdq-g@mail.gmail.com>
Subject: About Beceem WiMAX Module
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Helo LKML,

I have an issue with a module named "bcm_wimax". This is a staging
module located at linux/drivers/staging/bcm. The problem is that, the
supported devices listed in the module are not all valid or there are
more to be added.

"modinfo bcm_wimax" returns the supported product and vendor ids.

...
alias:          usb:v19D2p0007d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0489pE017d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v19D2p0132d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v198FpBCCDd*dc*dsc*dp*ic*isc*ip*
alias:          usb:v198Fp0220d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v198Fp0210d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v198Fp0300d*dc*dsc*dp*ic*isc*ip*
...

Here the product id 198f:bccd is obsolete cause it is a storage device
to load device driver which uses module "usb_storage". There are more
devices with id 19d2:0172, 19d2:0173 and so on. They all have
"beceXXXX" chip inside and the module "bcm_wimax" works fine with
them. The only problem is, custom modules are to be build before using
them and remove the original one. It would be great if more device id
is added and remove which are rarely used. I often get emails from
people using Virgin Mobile U760, Franklin Wireless u600 etc which have
another device ids.

I did a commit on Sir Linus's repo at
https://github.com/torvalds/linux/blob/master/drivers/staging/bcm/InterfaceInit.h.

At line 14, the following text

#define BCM_USB_PRODUCT_ID_226 0x0132 /* not sure if this is valid */

was changed to

#define BCM_USB_PRODUCT_ID_226 0x0173 /* ZTE AX326 */

Shouldn't this be approved?

I have devices with id 19d2:0172, 19d2:0173, 198f:015e also. So if any
help will be provided if anyone is interested. Feel free to ask any
question regarding this device/module/api.

Thank you.

--
MD: Minhazul Haque,
CSE 10, RUET, Rajshahi
about.me/mdminhazulhaque
