Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678Ab2KDOa1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 09:30:27 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:37004 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319Ab2KDOaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 09:30:25 -0500
MIME-Version: 1.0
In-Reply-To: <5093B29B.8070000@mvista.com>
References: <50929233.7030609@gmail.com> <5093B29B.8070000@mvista.com>
From: Dmytro Milinevskyy <milinevskyy@gmail.com>
Date: Sun, 4 Nov 2012 15:30:05 +0100
X-Google-Sender-Auth: fBYgOpfr72DnaqMxmdWKsArKFj8
Message-ID: <CAOUdcc-5TdxUzysEvacexmDQ6stB7kNo18-B3Y26V8i7i+p-HA@mail.gmail.com>
Subject: Re: [PATCH] usb: gadget: ncm: correct endianess conversion
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hum, you are right. It's pain to send anything via thunderbird.
Resending.

br,
-- dmytro

On Fri, Nov 2, 2012 at 12:46 PM, Sergei Shtylyov <sshtylyov@mvista.com> wrote:
> Hello.
>
>
> On 01-11-2012 19:16, Dmytro Milinevskyy wrote:
>
>> Convert USB descriptor's fields to CPU byte order before using locally in
>> USB
>> NCM gadget driver.
>> Tested on MIPS32 big-endian device.
>
>
>> Signed-off-by: Dmytro Milinevskyy <milinevskyy@gmail.com>
>> ---
>>   drivers/usb/gadget/f_ncm.c | 12 ++++++++----
>>
>>   1 file changed, 8 insertions(+), 4 deletions(-)
>
>
>> diff --git a/drivers/usb/gadget/f_ncm.c b/drivers/usb/gadget/f_ncm.c
>> index b651b52..a7cdd47 100644
>> --- a/drivers/usb/gadget/f_ncm.c
>> +++ b/drivers/usb/gadget/f_ncm.c
>
> [...]
>>
>> @@ -869,15 +869,19 @@ static struct sk_buff *ncm_wrap_ntb(struct gether
>> *port,
>>
>>       struct sk_buff    *skb2;
>>       int        ncb_len = 0;
>>       __le16        *tmp;
>> -    int        div = ntb_parameters.wNdpInDivisor;
>> -    int        rem = ntb_parameters.wNdpInPayloadRemainder;
>> +    int        div;
>> +    int        rem;
>>
>>       int        pad;
>> -    int        ndp_align = ntb_parameters.wNdpInAlignment;
>> +    int        ndp_align;
>>       int        ndp_pad;
>>
>>       unsigned    max_size = ncm->port.fixed_in_len;
>>       struct ndp_parser_opts *opts = ncm->parser_opts;
>>       unsigned    crc_len = ncm->is_crc ? sizeof(uint32_t) : 0;
>>   +    div = le16_to_cpu(ntb_parameters.wNdpInDivisor);
>
>
>     Probably corrupt patch -- there shouldn't be spaces before '+'.
>
> WBR, Sergei
>
