Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136Ab2HQJHg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 05:07:36 -0400
Received: from canardo.mork.no ([148.122.252.1]:41576 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752698Ab2HQJHd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 05:07:33 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        "linux-usb\@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "Lan\, Tianyu" <tianyu.lan@intel.com>
Subject: Re: BUG: unable to handle kernel paging request in usb_match_id()
Organization: m
References: <20120805025938.GA8954@localhost>
	<20120805165826.GB13913@kroah.com> <20120817020046.GA24406@localhost>
	<20120817034825.GC7770@kroah.com> <20120817054441.GA28434@localhost>
	<87wr0xnbnm.fsf@nemi.mork.no>
Date: Fri, 17 Aug 2012 11:07:21 +0200
In-Reply-To: <87wr0xnbnm.fsf@nemi.mork.no> (=?utf-8?Q?=22Bj=C3=B8rn?=
 Mork"'s message of "Fri, 17
	Aug 2012 10:52:13 +0200")
Message-ID: <87sjblnaye.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjørn Mork <bjorn@mork.no> writes:
> Fengguang Wu <fengguang.wu@intel.com> writes:
>
>> @@ -779,6 +780,7 @@ static int usb_device_match(struct devic
>>  		intf = to_usb_interface(dev);
>>  		usb_drv = to_usb_driver(drv);
>>  
>> +               pr_info("%s: device %s, driver %s \n", __func__, dev_name(dev), drv->name);
>>  		id = usb_match_id(intf, usb_drv->id_table);
>>  		if (id)
>>  			return 1;
>> [    1.397745] usb_match_id: id=c1d80820 idVendor=0x18f3 idProduct=0x220
>> [    1.398834] usbcore: registered new interface driver dvb_usb_dtt200u
>> [    1.399943] usb_device_match: device 1-0:1.0, driver dvb_usb_nova_t_usb2 
>> [    1.401095] usb_match_id: id=c1d81b6c idVendor=0x2040 idProduct=0x9300
>> [    1.402195] usb_match_id: id=c1d81b84 idVendor=0x2040 idProduct=0x9301
>> [    1.403270] usbcore: registered new interface driver dvb_usb_nova_t_usb2
>> [    1.404158] usb_device_match: device 1-0:1.0, driver dvb_usb_umt_010 
>> [    1.404861] usb_match_id: id=c1d824f4 idVendor=0x15f4 idProduct=0x1
>> [    1.405547] usb_match_id: id=c1d8250c idVendor=0x15f4 idProduct=0x15
>> [    1.406326] usbcore: registered new interface driver dvb_usb_umt_010
>> [    1.407190] usb_device_match: device 1-0:1.0, driver dvb_usb_gl861 
>
> Why is dev_name(dev) constant here?  That seems more than odd to me.  Is
> this really the same interface matching all these drivers?

Stupid me didn't read your debugging printk's properly.  You are of
course logging this *before* testing for a match, so everything is as
expected. 

But looking at the emi62 driver, I wonder if this will make any
difference:


diff --git a/drivers/usb/misc/emi62.c b/drivers/usb/misc/emi62.c
index ff08015..ae794b9 100644
--- a/drivers/usb/misc/emi62.c
+++ b/drivers/usb/misc/emi62.c
@@ -232,7 +232,7 @@ wraperr:
        return err;
 }
 
-static const struct usb_device_id id_table[] __devinitconst = {
+static const struct usb_device_id id_table[] = {
        { USB_DEVICE(EMI62_VENDOR_ID, EMI62_PRODUCT_ID) },
        { }                                             /* Terminating entry */
 };



Bjørn
