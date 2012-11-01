Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761997Ab2KAP0b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 11:26:31 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:42446 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761448Ab2KAP03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 11:26:29 -0400
MIME-Version: 1.0
In-Reply-To: <20121031133514.GU10998@arwen.pp.htv.fi>
References: <508FA17B.7060308@gmail.com> <20121031133514.GU10998@arwen.pp.htv.fi>
From: Dmytro Milinevskyy <milinevskyy@gmail.com>
Date: Thu, 1 Nov 2012 16:26:08 +0100
X-Google-Sender-Auth: BN9Zxe53pXSonYGr6HNWkQ3DAjs
Message-ID: <CAOUdcc8R43LkwYv3y7kVz2RfeBKZTEsosDWptQh3Z-k=cMC4xA@mail.gmail.com>
Subject: Re: [PATCH] usb: gadget: ncm: correct endianess conversion
To: balbi@ti.com
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,
resent with requested formatting changes.

cheers,
-- dmytro

On Wed, Oct 31, 2012 at 2:35 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Tue, Oct 30, 2012 at 10:44:27AM +0100, Dmytro Milinevskyy wrote:
>> Convert USB descriptor's fields to CPU byte order before using locally in USB NCM gadget driver.
>> Tested on MIPS32 big-endian device.
>>
>> Signed-off-by: Dmytro Milinevskyy <milinevskyy@gmail.com>
>> ---
>>  drivers/usb/gadget/f_ncm.c | 12 ++++++------
>>  1 file changed, 6 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/usb/gadget/f_ncm.c b/drivers/usb/gadget/f_ncm.c
>> index b651b52..0b9e2ad 100644
>> --- a/drivers/usb/gadget/f_ncm.c
>> +++ b/drivers/usb/gadget/f_ncm.c
>> @@ -102,7 +102,7 @@ static inline unsigned ncm_bitrate(struct usb_gadget *g)
>>                                USB_CDC_NCM_NTB32_SUPPORTED)
>>  static struct usb_cdc_ncm_ntb_parameters ntb_parameters = {
>> -     .wLength = sizeof ntb_parameters,
>> +     .wLength = cpu_to_le16(sizeof(ntb_parameters)),
>>       .bmNtbFormatsSupported = cpu_to_le16(FORMATS_SUPPORTED),
>>       .dwNtbInMaxSize = cpu_to_le32(NTB_DEFAULT_IN_SIZE),
>>       .wNdpInDivisor = cpu_to_le16(4),
>> @@ -869,15 +869,15 @@ static struct sk_buff *ncm_wrap_ntb(struct gether *port,
>>       struct sk_buff  *skb2;
>>       int             ncb_len = 0;
>>       __le16          *tmp;
>> -     int             div = ntb_parameters.wNdpInDivisor;
>> -     int             rem = ntb_parameters.wNdpInPayloadRemainder;
>> -     int             pad;
>> -     int             ndp_align = ntb_parameters.wNdpInAlignment;
>> -     int             ndp_pad;
>> +     int             div, rem, pad, ndp_align, ndp_pad;
>
> I would not combine them in a single line. Keep them one per line.
>
> cheers
>
> --
> balbi
