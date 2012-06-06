Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757073Ab2FFQWT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 12:22:19 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:56419 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225Ab2FFQWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 12:22:16 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-160.messagelabs.com!1338999729!8676722!10
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Ian Abbott <abbotti@mev.co.uk>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Date: Wed, 6 Jun 2012 11:22:08 -0500
Subject: RE: [PATCH] staging: comedi: ni_mio_common.c: local functions
 should be static
Thread-Topic: [PATCH] staging: comedi: ni_mio_common.c: local functions
 should be static
Thread-Index: Ac1DzXq5aFk0IruMSV+hnvQQuNJj9wAMjyEA
Message-ID: <ADE657CA350FB648AAC2C43247A983F0020698D12BFE@AUSP01VMBX24.collaborationhost.net>
References: <201206051120.22177.hartleys@visionengravers.com>
 <4FCF2E07.1090401@mev.co.uk>
In-Reply-To: <4FCF2E07.1090401@mev.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q56GMN7k011251

On Wednesday, June 06, 2012 3:17 AM, Ian Abbott wrote:
> On 2012-06-05 19:20, H Hartley Sweeten wrote:
>> Local functions should be marked static to prevent them from
>> being exposed globally.
>>
>> This quiets the following sparse warnings:
>>
>> warning: symbol 'ni_release_gpct_mite_channel' was not declared. Should it be static?
>> warning: symbol 'ni_prime_channelgain_list' was not declared. Should it be static?
>>
>> Signed-off-by: H Hartley Sweeten<hsweeten@visionengravers.com>
>> Cc: Ian Abbott<abbotti@mev.co.uk>
>> Cc: Mori Hess<fmhess@users.sourceforge.net>
>> Cc: Greg Kroah-Hartman<gregkh@linuxfoundation.org>
>>
>> ---
>>
>> diff --git a/drivers/staging/comedi/drivers/ni_mio_common.c b/drivers/staging/comedi/drivers/ni_mio_common.c
>> index fd232bc..3b3a0b1 100644
>> --- a/drivers/staging/comedi/drivers/ni_mio_common.c
>> +++ b/drivers/staging/comedi/drivers/ni_mio_common.c
>> @@ -644,7 +644,7 @@ static void ni_release_ao_mite_channel(struct comedi_device *dev)
>>   #endif /*  PCIDMA */
>>   }
>>
>> -void ni_release_gpct_mite_channel(struct comedi_device *dev,
>> +static void ni_release_gpct_mite_channel(struct comedi_device *dev,
>>   				  unsigned gpct_index)
>>   {
>>   #ifdef PCIDMA
>> @@ -1880,7 +1880,7 @@ static int ni_ai_insn_read(struct comedi_device *dev,
>>   	return insn->n;
>>   }
>
> This results in a compiler warning about the unused function 
> ni_release_gpct_mite_channel when compiling ni_atmio.c.  It was unused 
> before of course, but now it is static, the compiler realizes it!

Ugh... c code including c code... I didn't notice that until now.

> It could be fixed for now by moving the '#ifdef PCIDMA' and matching 
> '#endif' to surround the whole function, though I guess we want to try 
> and get rid of the #ifdef's eventually.  It's tricky because 
> ni_mio_common.c isn't a standalone compilation unit, it's #include'd by 
> some other .c files.  We might need to have a go at splitting it up at 
> some point.

The ni_mio_common.c file should just get turned into a library module.

Right now it's a bit of a mess. The individual drivers define PCIDMA
before including ni_mio_common.c. The only one that sets the define
is ni_pcimio but it's also included by ni_atmio and ni_mio_cs.

I'll look it over and see what might be done to fix it.

Regards,
Hartley



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
