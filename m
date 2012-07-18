Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111Ab2GRIad (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 04:30:33 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:45968 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061Ab2GRIa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 04:30:26 -0400
MIME-Version: 1.0
In-Reply-To: <1342594206.31927.7.camel@brekeke>
References: <1341937423-16516-1-git-send-email-richard.genoud@gmail.com>
 <1341937423-16516-4-git-send-email-richard.genoud@gmail.com> <1342594206.31927.7.camel@brekeke>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Wed, 18 Jul 2012 10:30:08 +0200
Message-ID: <CACQ1gAhMDQPOLhgi24Y8L_OFk35C1e5_1HchrRY3HFuA99+PMA@mail.gmail.com>
Subject: Re: [PATCH 3/4] UBI: use the whole MTD device size to get bad_peb_limit
To: dedekind1@gmail.com
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/7/18 Artem Bityutskiy <dedekind1@gmail.com>:
> On Tue, 2012-07-10 at 18:23 +0200, Richard Genoud wrote:
>>
>> The Kconfig option is in per1024 blocks, thus it can have a default
>> value of 20 which is *very* common for NAND devices.
>
> Why do you prefer per1024? I'd make it centi-percent instead, wouldn't
> that be more human-friendly. It is just %*100. If I am a user, it is
> easy for me to calculate % and multiply that by 100. This per1024 thing
> would make me scratch my head...
All the NAND devices I've seen are a multiple of 1024 erase blocks, so
I thought it'll be easier for the humans to use per1024...
here are 2 random datasheets :
page 14: http://www.micron.com/~/media/Documents/Products/Data%20Sheet/NAND%20Flash/6691NANDXXX%20A%20128Mb_256Mb_528%20byte_or_264%20word_page_3V_SLC_90nm.pdf
2048 blocks 40BEB max => 20per1024
1024 blocks 20BEB max => 20per1024

page 24: http://www.hynix.com/datasheet/pdf/flash/HY27(U_S)S(08_16)121M(Rev0.6).pdf
4096 blocks 80BEB max => 20per1024

If we express the default exact value of 20 per1024 blocks in percent,
that would be 1.953125% (event in per-thousand, we'll have 19.53125).
=> the value have to be rounded to floor or ceiling and that will make
the user unsure about the effective number of bad blocks used for bad
block handling.
(even if we say that the default value 20 per-thousand block will be
used, as the NAND devices have a number of blocks multiple of 1024,
for a 4096 blocks device, we'll have 81.92 reserved blocks, rounded to
82 => we loose 2 blocks for each mtd partition.)
So the per1024 thing was really to stick to the device layout and to
be easier for users (IMHO)

Richard.
