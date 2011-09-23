Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab1IWRRO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 13:17:14 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35944 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772Ab1IWRRJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 13:17:09 -0400
MIME-Version: 1.0
In-Reply-To: <4E7C9393.7030804@itanic.dy.fi>
References: <CAHzg1A-RCpZz-6YzON4cNzrSVpvEP=BCQx0AzZe1negcu2zo6g@mail.gmail.com>
	<CABg=csR-JzS0s2h=B9yJDJBsaAJZTR7b5iH-cU1EjQyxAQjd1g@mail.gmail.com>
	<CAHzg1A950qwmUts4nqKn80izXbxhmzoevg5n3g2C4BbwagmA2g@mail.gmail.com>
	<4E7C9393.7030804@itanic.dy.fi>
Date: Fri, 23 Sep 2011 10:17:07 -0700
Message-ID: <CAHzg1A-p0ygfjTsg8ZRREC_OTXs+k=vMm+zqbvmRm76y9c3veQ@mail.gmail.com>
Subject: Re: eMMC low write speed
From: Praveen G K <praveen.gk@gmail.com>
To: Timo Kokkonen <kaapeli@itanic.dy.fi>
Cc: Qiang LIU <godliuqiang@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 23, 2011 at 7:11 AM, Timo Kokkonen <kaapeli@itanic.dy.fi> wrote:
> On 09/23/11 06:03, Praveen G K wrote:
>> Hi Qiang,
>>
>>
>> On Thu, Sep 22, 2011 at 7:16 PM, Qiang LIU <godliuqiang@gmail.com> wrote:
>>> Hi,
>>>
>>> I suggest you change another eMMC card or try SDHC card. It seems like
>>> a card issue.
>>
>> Thanks for the response.  So, do you think this has nothing to do with
>> the caching or any such issues, since it is only every 63rd and 64th
>> transfer causing this issue?
>
> It is very much possible that the card itself does something internally
> on every 63rd or 64th transfer. Such as wear leveling management on the
> nand or perhaps some copy-on-write operations if the transfers are not
> taking place in contiguous blocks.

The way I am testing it is as follows
time -p dd if=/dev/zero of=/dev/mmcblk0 bs=512k count=10 (I have tried
different values for count)

When I especially try for count = 10, I see the request completed in
0.25 seconds or as high as 1 second.  When it is 0.25 s, the speed is
20MBps, and when it is 1s, the speed is 5MBps.  So, I am not sure
whether I am missing something here.
I am using the Sandisk SDIN5C1-4G card for testing.  Any other card of
the same family, I see only a speed of 5MBps.

> As suggested above, you could try with another eMMC or SDCH card if it
> makes a different (if possible).
>
> -Timo
>
