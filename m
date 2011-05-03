Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993Ab1ECJNB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 05:13:01 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43794 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab1ECJM7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 05:12:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=fpOpCgwEZumtZzxndYvScfrDcY+JEqKqCbYitqVFW5f5aqXZy9sruE1KXjJD26rG2v
         oDLB5gfB/HV0zAtA/j/XtU/B3XMfwWqA79k1gixPHyVer8MNChnyilqv5iCPYdLlKifU
         FcgwXzvGbuWKh3eXWZLfbC4g/aS40+A8hJu/8=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=CmYOisOqMejU2qVGnB4c6Z7yHsA@mail.gmail.com>
References: <1303910411-15793-1-git-send-email-akinobu.mita@gmail.com>
	<1303910411-15793-2-git-send-email-akinobu.mita@gmail.com>
	<4DBFA78F.9060001@snapgear.com>
	<BANLkTi=CmYOisOqMejU2qVGnB4c6Z7yHsA@mail.gmail.com>
Date: Tue, 3 May 2011 11:12:58 +0200
X-Google-Sender-Auth: yYv_gqCOZ77DqWMS8UtybtJCkDk
Message-ID: <BANLkTinkEHjrBW1GJSJhBnbgxXm5Vtw7BQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/7] m68knommu: fix build error due to the lack of find_next_bit_le()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Greg Ungerer <gerg@snapgear.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, akpm@linux-foundation.org, arnd@arndb.de,
        Greg Ungerer <gerg@uclinux.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 3, 2011 at 11:11, Akinobu Mita <akinobu.mita@gmail.com> wrote:
> 2011/5/3, Greg Ungerer <gerg@snapgear.com>:
>> Hi Akinobu,
>>
>> On 27/04/11 23:20, Akinobu Mita wrote:
>>> m68knommu can't build ext4, udf, and ocfs2 due to the lack of
>>> find_next_bit_le().
>>>
>>> This implements find_next_bit_le() on m68knommu by duplicating the
>>> generic find_next_bit_le() in lib/find_next_bit.c.
>>
>> Wouldn't the m68k specific implementation of this in
>> arch/m68k/include/asm/bitops_mm.h be better?
>
> find_next_bit_le() in bitops_mm.h has a bug
> (Please see https://lkml.org/lkml/2011/4/3/43) and it is not fixed
> in mainline yet. So I decided to use generic one for the safety.

Yeah, I still have to create a for-2.6.40 branch and add it there.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
