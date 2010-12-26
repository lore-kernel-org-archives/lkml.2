Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751541Ab0LZB0G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Dec 2010 20:26:06 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:51892 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab0LZB0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Dec 2010 20:26:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=mChvYKferVhFnh4BNFs7LqOjrg/FRJ+3zivZg26BPQeLolj1BovaMA/ytQn8QmwUET
         4RdyshonGatuftRdQXN/4bY9mCiU3iBNZav1pVdqndN2qgpDMYBs1PdI4Lzetzr59i0G
         zf6zEQ19VeUfXbrMMEScQafTLs/KGYCkA4b1c=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1012252020000.10759@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1012252020000.10759@swampdragon.chaosbits.net>
Date: Sat, 25 Dec 2010 20:26:03 -0500
X-Google-Sender-Auth: K2eRu6DuqixrpmmhvQ2dS3ZtNnk
Message-ID: <AANLkTinkzVs3XSp7cHP0Qhhd8+wuZs-X-yKt1dnZeSiO@mail.gmail.com>
Subject: Re: [PATCH] befs: Don't pass huge structs by value.
From: Will Dyson <will_dyson@pobox.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, Makoto Kato <m_kato@ga2.so-net.ne.jp>,
        "Sergey S. Kostyliov" <rathamahata@php4.ru>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 25, 2010 at 2:27 PM, Jesper Juhl <jj@chaosbits.net> wrote:
> Hi there,
>
> 'struct befs_disk_data_stream' is huge (~144 bytes) and it's being passed
> by value in fs/befs/endian.h::cpu_to_fsrun().
>
> It seems to me that it would be better to pass a pointer, no?
> This patch changes the function to take a pointer to the large struct.
>
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Seems very reasonable to me. Unfortunately, I have no longer have any
befs filesystems to test on either.

-- 
Will Dyson
