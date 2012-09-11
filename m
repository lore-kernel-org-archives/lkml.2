Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab2IKHnx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 03:43:53 -0400
Received: from canardo.mork.no ([148.122.252.1]:51173 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752257Ab2IKHnv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 03:43:51 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Thomas =?utf-8?Q?Sch=C3=A4fer?= <tschaefer@t-online.de>
Cc: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Subject: Re: [ 34/95] USB: option: add ZTE K5006-Z
Organization: m
References: <20120909224155.514234762@decadent.org.uk>
	<201209101911.27928.tschaefer@t-online.de>
Date: Tue, 11 Sep 2012 09:43:30 +0200
In-Reply-To: <201209101911.27928.tschaefer@t-online.de> ("Thomas
 =?utf-8?Q?Sch=C3=A4fer=22's?=
	message of "Mon, 10 Sep 2012 19:11:27 +0200")
Message-ID: <87zk4xm2cd.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Schäfer <tschaefer@t-online.de> writes:

> Am Montag, 10. September 2012 um 00:42:24 schrieb Ben Hutchings:
>> 3.2-stable review patch.  If anyone has any objections, please let me know.
>
>
>
> referring to
>
> http://www.spinics.net/lists/linux-usb/msg70131.html
>
> it should not be done with ff ff ff


Yes, sorry about not getting around to fixing that in time.  I've just
submitted a proposed fix.  But as my fix removes the bogus entry, you
may just as well go ahead and add this patch to stable so that the fixup
applies cleanly later. If accepted...



Bjørn
 
>> ------------------
>> 
>> From: Bjørn Mork <bjorn@mork.no>
>> 
>> commit f1b5c997e68533df1f96dcd3068a231bca495603 upstream.
>> 
>> The ZTE (Vodafone) K5006-Z use the following
>> interface layout:
>> 
>> 00 DIAG
>> 01 secondary
>> 02 modem
>> 03 networkcard
>> 04 storage
>> 
>> Ignoring interface #3 which is handled by the qmi_wwan
>> driver.
>> 
>> Cc: Thomas Schäfer <tschaefer@t-online.de>
>> Signed-off-by: Bjørn Mork <bjorn@mork.no>
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
>> ---
>>  drivers/usb/serial/option.c |    2 ++
>>  1 file changed, 2 insertions(+)
>> 
>> diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
>> index 9930628..cc40f47 100644
>> --- a/drivers/usb/serial/option.c
>> +++ b/drivers/usb/serial/option.c
>> @@ -886,6 +886,8 @@ static const struct usb_device_id option_ids[] = {
>>  	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1010, 0xff, 0xff, 
> 0xff),
>>  	  .driver_info = (kernel_ulong_t)&net_intf4_blacklist },
>>  	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1012, 0xff, 0xff, 0xff)
>> }, +	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1018, 0xff, 0xff,
>> 0xff), +	  .driver_info = (kernel_ulong_t)&net_intf3_blacklist },
>>  	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1057, 0xff, 0xff, 0xff)
>> }, { USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1058, 0xff, 0xff,
>> 0xff) }, { USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1059, 0xff,
>> 0xff, 0xff) },
