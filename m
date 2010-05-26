Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934346Ab0EZG73 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 02:59:29 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53126 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934264Ab0EZG72 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 02:59:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=wlSnCHfU+xQiH5ca6ZhnepufMqWAw7c/3zKuM7INrExlDJuuNZXAq/97/hhoLatdXc
         fumbbmypPCe/ZiX/tun8X2BqDAGUAejgx6r1tUEKgzFAziYTZYqkuMGTQMHN1fmANt8y
         XERfPpj37kdJVL1WlkbgoiosD1uNvrWwKqBCU=
MIME-Version: 1.0
In-Reply-To: <4BFC8617.9010501@codesourcery.com>
References: <1274815467-14584-1-git-send-email-vapier@gentoo.org>
	 <20100525210755.GA8920@linux-sh.org>
	 <AANLkTinTbJ3yu9ElO32rnavnGwCrsItdDCl58KoeEW3j@mail.gmail.com>
	 <4BFC8617.9010501@codesourcery.com>
Date: Wed, 26 May 2010 08:59:26 +0200
X-Google-Sender-Auth: xzJBaHeoVhSOzkuBBvEOu-ZDbPg
Message-ID: <AANLkTilU133SjYfKGvUiQQ8v-CiecRYmKtH2tzAxL-3u@mail.gmail.com>
Subject: Re: [PATCH] FLAT: allow arches to declare a larger alignment than the 
	slab
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jie Zhang <jie@codesourcery.com>
Cc: Mike Frysinger <vapier.adi@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
       Mike Frysinger <vapier@gentoo.org>, uclinux-dev@uclinux.org,
       David Howells <dhowells@redhat.com>,
       David McCullough <davidm@snapgear.com>, Greg Ungerer <gerg@uclinux.org>,
       uclinux-dist-devel@blackfin.uclinux.org,
       microblaze-uclinux@itee.uq.edu.au, Michal Simek <monstr@monstr.eu>,
       linux-m32r@ml.linux-m32r.org, Hirokazu Takata <takata@linux-m32r.org>,
       linux-kernel@vger.kernel.org,
       Yoshinori Sato <ysato@users.sourceforge.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 04:23, Jie Zhang <jie@codesourcery.com> wrote:
> On 05/26/2010 07:17 AM, Mike Frysinger wrote:
>>
>> i do not believe that is the reason for this, but unfortunately Jie is
>> about the only one atm who knows the inner details as for why shared
>> FLAT libraries requires 0x20 rather than just 0x4 alignment.  i do
>> know that there are some gcc fortran tests that fail otherwise.
>> hopefully he can remember details ;).
>>
> I encountered this issue when investigating some GCC test failures when
> using FLAT. I don't remember if they were in GCC Fortran testsuite. Some
> variables in those test cases were required to be aligned at a large
> boundary, for example 16-byte. I found 0x20 was a reasonably large alignment
> to fix all such failures in GCC testsuite.

I'm no FLAT expert (except for the AmigaOS HUNK loader :-), but isn't
the core of the
issue that alignment requirements in the object file are no longer
fulfilled after loading,
as a FLAT segment in memory is just allocated using kmalloc(), which may now
return 4-byte aligned blocks?

>From looking at <linux/flat.h>, it looks like the FLAT binary format
doesn't contain any
alignment information? So if I put __attribute__((aligned(4096))) in a
file, there's still
no guarantee it will actually be in memory at a 4Ki-aligned address?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
