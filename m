Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238Ab2FSLu1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 07:50:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25787 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344Ab2FSLu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 07:50:26 -0400
Message-ID: <4FE0678C.2050205@redhat.com>
Date: Tue, 19 Jun 2012 13:50:36 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the v4l-dvb tree with Linus' tree
References: <20120619112939.23c80aed8f1db9682e37be87@canb.auug.org.au> <alpine.LNX.2.00.1206191205190.15308@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1206191205190.15308@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 06/19/2012 12:06 PM, Jiri Kosina wrote:
> On Tue, 19 Jun 2012, Stephen Rothwell wrote:
>
>> Hi Mauro,
>>
>> Today's linux-next merge of the v4l-dvb tree got a conflict in
>> drivers/hid/hid-ids.h between commit 9ed326951806 ("HID: multitouch: Add
>> support for Baanto touchscreen") from Linus' tree and commit 110301833d6f
>> ("[media] radio/si470x: Add support for the Axentia ALERT FM USB
>> Receiver") from the v4l-dvb tree.
>>
>> Just context changes.  I fixed it up (see below) and can carry the fix as
>> necessary.
>> --
>> Cheers,
>> Stephen Rothwell                    sfr@canb.auug.org.au
>>
>> diff --cc drivers/hid/hid-ids.h
>> index 6d3037e,70298d1..0000000
>> --- a/drivers/hid/hid-ids.h
>> +++ b/drivers/hid/hid-ids.h
>> @@@ -160,9 -157,9 +160,12 @@@
>>    #define USB_VENDOR_ID_AVERMEDIA		0x07ca
>>    #define USB_DEVICE_ID_AVER_FM_MR800	0xb800
>>
>> + #define USB_VENDOR_ID_AXENTIA		0x12cf
>> + #define USB_DEVICE_ID_AXENTIA_FM_RADIO	0x7111
>> +
>>   +#define USB_VENDOR_ID_BAANTO		0x2453
>>   +#define USB_DEVICE_ID_BAANTO_MT_190W2	0x0100
>>   +
>>    #define USB_VENDOR_ID_BELKIN		0x050d
>>    #define USB_DEVICE_ID_FLIP_KVM		0x3201
>
> Thanks for reporting this, Stephen.
>
> Hmmm ... Mauro, Hans, do you feel it's actually proper to add the device
> ids to hid-ids.h? I am using this file usually solely for the drivers on
> the HID bus, which radio-si470x is not, I believe.

Not sure what you mean with "drivers on the HID bus", radio-si470x drivers
do use a USB-HID class interface, but the driver itself does not use
the kernel hid framework. The ids in hid-ids are used for adding this device
to the hid-core "blacklist" to avoid usb-hid from binding to it, so that
radio-si470x-usn can bind to it.

Regards,

Hans
