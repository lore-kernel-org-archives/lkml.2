Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610Ab0JPP64 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 11:58:56 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:60857 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431Ab0JPP6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 11:58:53 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Linux\/m68k" <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH 22/22] bitops: remove minix bitops from asm/bitops.h
References: <1287135981-17604-1-git-send-email-akinobu.mita@gmail.com>
	<1287135981-17604-23-git-send-email-akinobu.mita@gmail.com>
	<201010151253.15653.arnd@arndb.de>
	<AANLkTi=cA=yf7NmPVKXaZdoTBYmwdmy_frk7b_feG-WG@mail.gmail.com>
	<m262x24j2y.fsf@igel.home>
	<AANLkTimHYYLZHOxgco3jotD7ikVhaPh8FVcSqeZwtrVc@mail.gmail.com>
	<AANLkTimtyW8AbOj+w=mjPbpP1j0LB9JXdo7cb=nQAXQ8@mail.gmail.com>
	<m2aamepa5s.fsf@igel.home>
	<AANLkTimB77RRcJfNcX-w7E+mKiKmNzR661SrP8G09y7A@mail.gmail.com>
X-Yow: I know th'MAMBO!!  I have a TWO-TONE CHEMISTRY SET!!
Date: Sat, 16 Oct 2010 17:58:50 +0200
In-Reply-To: <AANLkTimB77RRcJfNcX-w7E+mKiKmNzR661SrP8G09y7A@mail.gmail.com>
	(Akinobu Mita's message of "Sat, 16 Oct 2010 22:47:49 +0900")
Message-ID: <m2wrpinn7p.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Akinobu Mita <akinobu.mita@gmail.com> writes:

> 2010/10/16 Andreas Schwab <schwab@linux-m68k.org>:
>> Akinobu Mita <akinobu.mita@gmail.com> writes:
>>
>>> m68knommu is big-endian minixfs but m68k (mmu) is little-endian minixfs
>>> if I read arch/m68k/include/asm/bitops_{mm,no}.h correctly.
>>
>> Don't be confused by ^16, this is for the 16bit/32bit indexing
>> correction.  The nommu version uses big-endian 32bit indexing which yet
>> another format.
>
> Oh, I see. I misunderstood.
>
> So we need a special handling for it to keep compatibility.

IMHO we only need two versions: big-endian filesystem with big-endian
16bit indexed bitmaps and little-endian filesystem with little-endian
bitmaps.  The rest is just the result of careless copying.  Note that
the minix filesystem does no byte swapping, so native byte order is the
only sensible mode.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
