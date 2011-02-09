Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab1BIKHX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 05:07:23 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:51259 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764Ab1BIKHW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 05:07:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=OnKwy2lLXo1dP4bSlGFdDTs/YMNqxOFEgN8ue9z1dy7boPeN7VrbWzJUQ7pvTMps0a
         OtgslwBSPdrxa71uoQIxNAzK12G0EIH8okz/D8x+r5n9nUdrpVC1iO9rCZQS+jUS8hm9
         ljBass+p3o1C6ZtVFpYNvg2vWcEcwTVsixoqQ=
MIME-Version: 1.0
In-Reply-To: <20110208163531.GO4384@bicker>
References: <1296042555-29145-1-git-send-email-marek.belisko@open-nandra.com>
	<1296042555-29145-4-git-send-email-marek.belisko@open-nandra.com>
	<20110126130718.GN2721@bicker>
	<20110126143045.GP2721@bicker>
	<AANLkTi=ygn3Go7kCYe1fAo6OrKQaVVGaV_=xMgxM=u5s@mail.gmail.com>
	<20110208163531.GO4384@bicker>
Date: Wed, 9 Feb 2011 11:07:19 +0100
Message-ID: <AANLkTi=u1M1Gu1y7kmaPSTd4CDUWkgowYLpQRSpwRyEY@mail.gmail.com>
Subject: Re: [PATCH 4/5] staging: ft1000: Fix coding style in write_blk_fifo() function.
From: Belisko Marek <marek.belisko@gmail.com>
To: Dan Carpenter <error27@gmail.com>, Belisko Marek <marek.belisko@gmail.com>,
        Marek Belisko <marek.belisko@open-nandra.com>, gregkh@suse.de,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 8, 2011 at 5:35 PM, Dan Carpenter <error27@gmail.com> wrote:
> On Tue, Feb 08, 2011 at 02:40:49PM +0100, Belisko Marek wrote:
>> On Wed, Jan 26, 2011 at 3:30 PM, Dan Carpenter <error27@gmail.com> wrote:
>> > Also when it does:
>> >        memcpy(ft1000dev->tx_buf, *pUcFile, byte_length);
>> >
>> > That should probably be:
>> >        memcpy(ft1000dev->tx_buf, *pUcFile, word_length * 4);
>> No this shouldn't because before you have additional check:
>> if (byte_length && ((byte_length % 64) == 0))
>>         byte_length += 4;
>>
>> if (byte_length < 64)
>>         byte_length = 68;
>> So in my opinion byte_length should stay.
>
> Yes.  We make byte_length longer than the caller intended.  The caller
> knows the size of the source buffer.  We have to pad the length of the
> other buffer, but we should fill up the last part with zeroes instead
> of reading past the end of the source buffer.
>
> (I am not very familiar with the code and I haven't looked outside this
> function, so I may be wrong).
>
> Also I really bet that the thing where byte_length can't be a multiple
> of 64 is bogus.  I've never heard of anything with a requirement like
> that.
Well I test it and it seems very strange and can't figure out why.
Will remove all byte_length manipulations and device doesn't boot properly
(finish with error). Add some prinkt to code figure out following:

1. byte_length = word_length *4 is < 64 we need to send via usb 68
bytes (despite
4 bytes are behind 64 (without this it can't boot).

2. also when e.g. word_length is 400 (400*4 = 1600) condition
1600%64 == 0 is valid and we send 1604 bytes to usb (also not sure why
but without this change it also doesn't work).

For little explanation when we get to state code load we ask device
how many bytes should send
so we will get reply and send block via usb. So maybe it's related
that we send in our assumption correct data
but usb request something else to properly working ;)
>
> regards,
> dan carpenter
>
>
>

thanks,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
icq: 290551086
web: http://open-nandra.com
