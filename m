Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab2J1RaZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 13:30:25 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:36427 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096Ab2J1RaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 13:30:23 -0400
MIME-Version: 1.0
In-Reply-To: <20121024135834.GA4368@breakpoint.cc>
References: <1349729943-28995-1-git-send-email-milinevskyy@gmail.com> <20121024135834.GA4368@breakpoint.cc>
From: Dmytro Milinevskyy <milinevskyy@gmail.com>
Date: Sun, 28 Oct 2012 18:30:02 +0100
X-Google-Sender-Auth: nTfQt-_B95Fnnn9wacx9exIiJJQ
Message-ID: <CAOUdcc9PwMg34n_W14ctgW2qqP1P+STan6JBH3uyO+y+jWZ0FQ@mail.gmail.com>
Subject: Re: [PATCH] usb: gadget: ncm: correct endianess conversion
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian,
I was trying to keep 2 tabs but checkpatch didn't accept long line
that's why I killed extra tab.

>How does it work? Is the test on host side not strict enough?
The host part(cdc_ncm) does not check this field.
However I agree that at least on device side this should be corrected.

Felipe, do you want me to send another patch or resend previous one
with this correction?

Thanks,
-- dmytro

On Wed, Oct 24, 2012 at 3:58 PM, Sebastian Andrzej Siewior
<sebastian@breakpoint.cc> wrote:
> On Mon, Oct 08, 2012 at 11:59:03PM +0300, Dmytro Milinevskyy wrote:
>> Convert USB descriptor's fields to CPU byte order before using locally in USB NCM gadget driver.
>> Tested on MIPS32 big-endian device.
>>
>> Signed-off-by: Dmytro Milinevskyy <milinevskyy@gmail.com>
>> ---
>>  drivers/usb/gadget/f_ncm.c | 10 +++++-----
>>  1 file changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/usb/gadget/f_ncm.c b/drivers/usb/gadget/f_ncm.c
>> index b651b52..fce45ab 100644
>> --- a/drivers/usb/gadget/f_ncm.c
>> +++ b/drivers/usb/gadget/f_ncm.c
>> @@ -869,11 +869,11 @@ static struct sk_buff *ncm_wrap_ntb(struct gether *port,
>>       struct sk_buff  *skb2;
>>       int             ncb_len = 0;
>>       __le16          *tmp;
>> -     int             div = ntb_parameters.wNdpInDivisor;
>> -     int             rem = ntb_parameters.wNdpInPayloadRemainder;
>> -     int             pad;
>> -     int             ndp_align = ntb_parameters.wNdpInAlignment;
>> -     int             ndp_pad;
>> +     int     div = le16_to_cpu(ntb_parameters.wNdpInDivisor);
>> +     int     rem = le16_to_cpu(ntb_parameters.wNdpInPayloadRemainder);
>> +     int     pad;
>> +     int     ndp_align = le16_to_cpu(ntb_parameters.wNdpInAlignment);
>> +     int     ndp_pad;
>
> It would be nice to keep the two tabs between int and variable. One question:
> In ntb_parameters the member wLength is 16bit and not using cpu_to_le16(). How
> does it work? Is the test on host side not strict enough?
>
>>       unsigned        max_size = ncm->port.fixed_in_len;
>>       struct ndp_parser_opts *opts = ncm->parser_opts;
>>       unsigned        crc_len = ncm->is_crc ? sizeof(uint32_t) : 0;
>
> Sebastian
