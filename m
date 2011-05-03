Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970Ab1ECJLY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 05:11:24 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:48549 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab1ECJLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 05:11:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Eg9MuSF1fRXzm1aLQxO+Hk+oa2TB9UEDI6leUnKKrj9ca5mXy5gOeSGVgrDBQ+CiUR
         RN//6oK3q8VOGprTzL/j/ZjjRnvFdBetL4K9DtVUPeTgDg7R5LyMG6YhWp05ngZt8idT
         hDoeqEoT45zn4OqQaWbYN5JRMpLtvCEOVsxoE=
MIME-Version: 1.0
In-Reply-To: <4DBFA78F.9060001@snapgear.com>
References: <1303910411-15793-1-git-send-email-akinobu.mita@gmail.com>
	<1303910411-15793-2-git-send-email-akinobu.mita@gmail.com>
	<4DBFA78F.9060001@snapgear.com>
Date: Tue, 3 May 2011 17:11:20 +0800
Message-ID: <BANLkTi=CmYOisOqMejU2qVGnB4c6Z7yHsA@mail.gmail.com>
Subject: Re: [PATCH v3 1/7] m68knommu: fix build error due to the lack of find_next_bit_le()
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Greg Ungerer <gerg@snapgear.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        akpm@linux-foundation.org, arnd@arndb.de,
        Greg Ungerer <gerg@uclinux.org>, geert@linux-m68k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/3, Greg Ungerer <gerg@snapgear.com>:
> Hi Akinobu,
>
> On 27/04/11 23:20, Akinobu Mita wrote:
>> m68knommu can't build ext4, udf, and ocfs2 due to the lack of
>> find_next_bit_le().
>>
>> This implements find_next_bit_le() on m68knommu by duplicating the
>> generic find_next_bit_le() in lib/find_next_bit.c.
>
> Wouldn't the m68k specific implementation of this in
> arch/m68k/include/asm/bitops_mm.h be better?

find_next_bit_le() in bitops_mm.h has a bug
(Please see https://lkml.org/lkml/2011/4/3/43) and it is not fixed
in mainline yet. So I decided to use generic one for the safety.
