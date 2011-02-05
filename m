Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722Ab1BEUwQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 15:52:16 -0500
Received: from mailout1.go2.pl ([193.17.41.11]:45297 "EHLO mailout1.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753363Ab1BEUwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 15:52:15 -0500
Message-ID: <4D4DB870.2080904@o2.pl>
Date: Sat, 05 Feb 2011 21:52:00 +0100
From: Maciej Szmigiero <mhej@o2.pl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101204 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Greg Kroah-Hartman <gregkh@suse.de>, Oliver Neukum <oneukum@suse.de>,
        Hans de Goede <hdegoede@redhat.com>,
        Paul Mortier <mortier@btinternet.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [USB]Add quirk for Samsung Android phone modem
References: <Pine.LNX.4.44L0.1102051514150.4210-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1102051514150.4210-100000@netrider.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-O2-Trust: 2, 64
X-O2-SPF: neutral
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 05.02.2011 21:15, Alan Stern pisze:
> On Sat, 5 Feb 2011, Maciej Szmigiero wrote:
> 
>> [USB]Add quirk for Samsung Android phone modem
>>
>> My Galaxy Spica needs this quirk when in modem mode, otherwise
>> it causes endless USB bus resets and is unusable in this mode.
>>
>> Unfortunately Samsung decided to reuse ID of its old CDMA phone SGH-I500
>> for the modem part.
>> That's why in addition to this patch the visior driver must be prevented
>> from binding to SPH-I500 ID, so ACM driver can do that.
>>
>> Signed-off-by: Maciej Szmigiero <mhej@o2.pl>
>>
>> diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
>> index 44c5954..363355b 100644
>> --- a/drivers/usb/core/quirks.c
>> +++ b/drivers/usb/core/quirks.c
>> @@ -88,6 +88,10 @@ static const struct usb_device_id usb_quirk_list[] = {
>>      /* INTEL VALUE SSD */
>>      { USB_DEVICE(0x8086, 0xf1a5), .driver_info = USB_QUIRK_RESET_RESUME },
>>  
>> +    /* Samsung Android phone modem - ID conflict with SPH-I500 */
>> +    { USB_DEVICE(0x04e8, 0x6601), .driver_info =
>> +            USB_QUIRK_CONFIG_INTF_STRINGS },
>> +
>>      { }  /* terminating entry must be last */
>>  };
> 
> Please follow the directions at the start of the source file: Keep the 
> list ordered by vendor ID, then product ID.
> 
> Alan Stern

Sorry for that, should have read the whole file before adding new quirk.
Here is a sorted version:

[USB]Add quirk for Samsung Android phone modem

My Galaxy Spica needs this quirk when in modem mode, otherwise
it causes endless USB bus resets and is unusable in this mode.

Unfortunately Samsung decided to reuse ID of its old CDMA phone SGH-I500
for the modem part.
That's why in addition to this patch the visor driver must be prevented
from binding to SPH-I500 ID, so ACM driver can do that.

Signed-off-by: Maciej Szmigiero <mhej@o2.pl>

diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index 44c5954..63b1f21 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -48,6 +48,10 @@ static const struct usb_device_id usb_quirk_list[] = {
 	{ USB_DEVICE(0x04b4, 0x0526), .driver_info =
 			USB_QUIRK_CONFIG_INTF_STRINGS },
 
+	/* Samsung Android phone modem - ID conflict with SPH-I500 */
+	{ USB_DEVICE(0x04e8, 0x6601), .driver_info =
+			USB_QUIRK_CONFIG_INTF_STRINGS },
+
 	/* Roland SC-8820 */
 	{ USB_DEVICE(0x0582, 0x0007), .driver_info = USB_QUIRK_RESET_RESUME },
 
 


