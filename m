Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab0KXRqa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 12:46:30 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47507 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051Ab0KXRq3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 12:46:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=a+wfqbhG8+32Nm96vFf6BFGEnZBd3ZnsEBNpDicKyNtRFTMY73sunprNSzpgsBfnN9
         +Ik3hgabPRFn1NE8/Pd8pK8qXzL6JOhap4yTN+kTsvez5Gx+hNmYHuBBlYd1A6RhpBnn
         Hf2x/qvCtOnVV0zAYSIcKd8SqG0ypwyc3n8dA=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=yV02oY5AmNAYr+ZF0RUgVv8gkeP+D9_CcOfLi@mail.gmail.com>
References: <AANLkTikg-sR97tkG=ST9kjZcHe6puYSvMGh-eA3cnH7X@mail.gmail.com>
	<20101122161158.02699d10.akpm@linux-foundation.org>
	<1290501502.2390.7029.camel@nimitz>
	<AANLkTik2Fn-ynUap2fPcRxRdKA=5ZRYG0LJTmqf80y+q@mail.gmail.com>
	<1290529171.2390.7994.camel@nimitz>
	<AANLkTikCn-YvORocXSJ1Z+ovYNMhKF7TaX=BHWKwrQup@mail.gmail.com>
	<AANLkTi=mgTHPEYFsryDYnxPa78f-Nr+H7i4+0KPZbxh3@mail.gmail.com>
	<AANLkTimo1BR=mSJ6wPQwrL4FDNv=_TfanPPTT7uWx7hQ@mail.gmail.com>
	<AANLkTi=yV02oY5AmNAYr+ZF0RUgVv8gkeP+D9_CcOfLi@mail.gmail.com>
Date: Wed, 24 Nov 2010 19:46:28 +0200
X-Google-Sender-Auth: 9294wgu7DDnWi3fyhwryRtLpQXg
Message-ID: <AANLkTi=PXoMA0gv53_7h16u1259sh1uOxg2cSXYSXThv@mail.gmail.com>
Subject: Re: Sudden and massive page cache eviction
From: Pekka Enberg <penberg@kernel.org>
To: =?ISO-8859-1?Q?Peter_Sch=FCller?= <scode@spotify.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Mattias de Zalenski <zalenski@spotify.com>, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

2010/11/24 Peter Schüller <scode@spotify.com>:
>>> I forgot to address the second part of this question: How would I best
>>> inspect whether the kernel is doing that?
>>
>> You can, for example, record
>>
>>  cat /proc/meminfo | grep Huge
>>
>> for large page allocations.
>
> Those show zero a per my other post. However I got the impression Dave
> was asking about regular but larger-than-one-page allocations internal
> to the kernel, while the Huge* lines in /proc/meminfo refers to
> allocations specifically done by userland applications doing huge page
> allocation on a system with huge pages enabled - or am I confused?

He was asking about both (large page allocations and higher order allocations).

>> The "pagesperslab" column of /proc/slabinfo tells you how many pages
>> slab allocates from the page allocator.
>
> Seems to be what vmstat -m reports.

No, "vmstat -m" reports _total number_ of pages allocated. We're
interested in how many pages slab allocator whenever it needs to
allocate memory for a new slab. That's represented by the
"pagesperslab" column of /proc/slabinfo from which you can deduce the
page allocation order.

                        Pekka
