Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903Ab1BII1K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 03:27:10 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:64438 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824Ab1BII1I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 03:27:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=Q/KMB51AIDmZRLpinB4NZa7f3xrqy7VUWizSIu2otViKkcH78uUvvKd4SFDJd8O1pf
         A/UrXBdxbcUe7MgPh4NvSKtpTUZ78JsrOtzfzZc0vgKc3mhZMoqdwQ+uktI75cQvQ4sP
         tp3vW7KkDJ93jg/IjRGZYKSRy55lFvzEgh47U=
MIME-Version: 1.0
In-Reply-To: <20110208163531.GO4384@bicker>
References: <1296042555-29145-1-git-send-email-marek.belisko@open-nandra.com>
	<1296042555-29145-4-git-send-email-marek.belisko@open-nandra.com>
	<20110126130718.GN2721@bicker>
	<20110126143045.GP2721@bicker>
	<AANLkTi=ygn3Go7kCYe1fAo6OrKQaVVGaV_=xMgxM=u5s@mail.gmail.com>
	<20110208163531.GO4384@bicker>
Date: Wed, 9 Feb 2011 09:27:07 +0100
Message-ID: <AANLkTikbbawxi01-jK8iQmG0MZwZasHnF1hKZwMZ502Y@mail.gmail.com>
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
You're right. Today will make test when remove all opaque code.
Anyway at the end file position is moved in that way:
*pUsFile = *pUsFile + (word_length << 1);
*pUcFile = *pUcFile + (word_length << 2);

So short pointer multiplied by 2 and char pointer by 4 with
word_length. So my assume
all check and byte_length increasing is not correct (will see what test shows).
>
> regards,
> dan carpenter
>
>
>

regards,

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
