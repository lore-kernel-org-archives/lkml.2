Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505Ab0KXOUc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 09:20:32 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36639 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210Ab0KXOUb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 09:20:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=PvIFn14sufuYMYfbbxJd73S/5UmfyAMCxPoqvFj0VbjI+fXlJHiS7OV84yt8tpdOcF
         schTP6oOlkDwJOzzqYRTrFMG3fWm0Wc9BLzfrZXQIVyKpshLHEW3kn80KLbKcGHUGwP/
         lqug5qDR0q2wgtVN5NtZ/ko2BPqh/ZEkCIBzQ=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=mgTHPEYFsryDYnxPa78f-Nr+H7i4+0KPZbxh3@mail.gmail.com>
References: <AANLkTikg-sR97tkG=ST9kjZcHe6puYSvMGh-eA3cnH7X@mail.gmail.com>
	<20101122161158.02699d10.akpm@linux-foundation.org>
	<1290501502.2390.7029.camel@nimitz>
	<AANLkTik2Fn-ynUap2fPcRxRdKA=5ZRYG0LJTmqf80y+q@mail.gmail.com>
	<1290529171.2390.7994.camel@nimitz>
	<AANLkTikCn-YvORocXSJ1Z+ovYNMhKF7TaX=BHWKwrQup@mail.gmail.com>
	<AANLkTi=mgTHPEYFsryDYnxPa78f-Nr+H7i4+0KPZbxh3@mail.gmail.com>
Date: Wed, 24 Nov 2010 16:20:30 +0200
X-Google-Sender-Auth: sSRHGO7-qgye2ViSE0nSb9HpDeY
Message-ID: <AANLkTimo1BR=mSJ6wPQwrL4FDNv=_TfanPPTT7uWx7hQ@mail.gmail.com>
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
>>> Do you have any large page (hugetlbfs) or other multi-order (> 1 page)
>>> allocations happening in the kernel?
>
> I forgot to address the second part of this question: How would I best
> inspect whether the kernel is doing that?

You can, for example, record

  cat /proc/meminfo | grep Huge

for large page allocations.

> Looking at the kmalloc() sizes from vmstat -m I have the following on
> one of the machines (so very few larger than 4096). But I suspect you
> are asking for something different?

The "pagesperslab" column of /proc/slabinfo tells you how many pages
slab allocates from the page allocator.

                       Pekka
