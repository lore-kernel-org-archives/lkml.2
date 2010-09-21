Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203Ab0IUBQG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 21:16:06 -0400
Received: from web37605.mail.mud.yahoo.com ([209.191.87.88]:43947 "HELO
	web37605.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751008Ab0IUBQE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 21:16:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=Z1pj99HebVD12OXwnasqLYuQHylZEK7frB7l4oe1kSv3WnMX0HAXbH4MNST9qCwk4QTl346H97qWjcTIj06wzdQ9+00T/eqOJIkTfmuAsL5Hlwx3MqXn7TUQazeWgxkOnUv9woBgIw+VbWMEL40FzRQRXZa408NYWwkHHMMmwKo=;
Message-ID: <553730.24538.qm@web37605.mail.mud.yahoo.com>
X-YMail-OSG: m522NasVM1m17u5Zfdr9hhfahur9f3V7DuqNNTV4ksvH3aH
 mJaN1jt5wPLgx.tzdI0qUEkcRMpjuRMr0rZpV.ROi9od8_zNOtbUy66pBpNI
 FkCRMtdDyF9Z4tYnfVhgJzVjVaY2fzKv48Usmlequ_36_T.h5NKCou9F9UHG
 .fKmo_KlnT_M6NVDALaKLxHnVYXaTcceidxi2YeusHDYmHmcKhesxfiuxjMU
 Tl7FSEOp1Yqo9ZrYOdwOC5RM7yJlIVI1KNEMAtvCibJmfRLyRDTFQmSPfDVV
 tR3gjsD1RYcn5T7jmNfC31nC00vg2TO3KeiWuTDFJKesukvkwk0_VUg--
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.105.279950
Date: Mon, 20 Sep 2010 18:16:03 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 2/3] MEMSTICK: add support for legacy memorysticks
To: Maxim Levitsky <maximlevitsky@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100920120235.f7b93405.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> None of that explains why we're putting
> non-memstick-specific
> scatterlist infrastructure into the memstick driver, rather
> than into
> the scatterlist code.

In memstick driver this particular approach is used to get the largest
possible chunk of data from the block layer (to minimise the number of
media block accesses, just like with any other flash device driver).

Considering that legacy memstick, in its current state is not part of the
MTD, it well may be that it is not very useful in a general case. I
actually had "iterator style" interface for this sort of thing implemented
(it was operating on bio lists and was intended to mask the
difference between flat buffer and bio list). If there's an interest in
such an interface, either Maxim or me can try and submit it.

> Probably the code you copied from was wrong.  The IDR
> interface is
> really ugly.  All "container class" code which needs
> to allocate memory
> at element-insertion time has this issue.  You
> should've seen all the
> crap we had to do to make insertion of pagecache into
> radix-trees
> reliable :(
> 

It is indeed wrong, but I myself copied it from elsewhere, so back in a
time it was probably the standard approach. However, do you have a quick
advice for a case, were idr_pre_get happens outside spin-locked section,
as opposed to mutex one?




      
