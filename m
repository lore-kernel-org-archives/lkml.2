Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769Ab1DMRiS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 13:38:18 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62765 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868Ab1DMRiQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 13:38:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=K/Ok6RzZOdd8abH7+17hZZjm8TxqBxzK0TUbbETR5dVmZpF2btkWcAedbJ/mDjL+bS
         ZRYBv309X08dBgehFQfcdUgivcCLYJWO091P/OIP/xBjThXXLYjXM+4m2UgvXcNsG/75
         RQMv7dIRxajrE/w3lgHKhIaEdisisk7ShYS3Q=
MIME-Version: 1.0
In-Reply-To: <20110413.103233.193707113.davem@davemloft.net>
References: <alpine.DEB.2.00.1104131835280.32045@ayla.of.borg>
	<20110413.103233.193707113.davem@davemloft.net>
Date: Wed, 13 Apr 2011 19:38:14 +0200
X-Google-Sender-Auth: d7G3DZ-OerV_7LcHQ6aIFOEfILQ
Message-ID: <BANLkTinT09RGg5XDUGy76Kpa8yX3DNUoQw@mail.gmail.com>
Subject: Re: Build regressions/improvements in v2.6.39-rc3
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, Michael Ellerman <michael@ellerman.id.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 19:32, David Miller <davem@davemloft.net> wrote:
> From: Geert Uytterhoeven <geert@linux-m68k.org>
> Date: Wed, 13 Apr 2011 18:35:45 +0200 (CEST)
>
>> 47 regressions:
>>   + build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/ethtool.h: error: expected specifier-qualifier-list before '__u32': 104, 90, 21, 282, 389, 460, 521, 444, 96, 297, 82, 57, 291, 258, 231, 482, 209, 510, 265, 113 => 104, 538, 90, 21, 523, 552, 266, 445, 292, 96, 82, 512, 563, 57, 259, 283, 298, 484, 390, 231, 209, 462, 574, 113
>
> I do allmodconfig builds on sparc64 systems every single day using
> various versions of gcc-4.4, gcc-4.5, and gcc-4.6
>
> And I never ever see this build error.  Never.
>
> If you're using a cross build environment, maybe something isn't quite
> right with that?

As it mentions `/usr/include/linux/ethtool.h', it seems to be an
include that's part of the
cross build environment.

There's a similar issue with:

| src/Documentation/accounting/getdelays.c: error: 'struct nlattr' has
no member named 'nla_len': 464, 495, 142, 187, 140, 469 => 464, 495,
142, 508, 187, 140, 469

which only triggers on the same sparc64 cross build environment...

I'm just using the logs from the linux-next build service...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
