Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758122Ab1EaHrU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 03:47:20 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44774 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064Ab1EaHrR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 03:47:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=VHPBEq5LvkJVbrJt69PjCYut4Rwe0DWliHEqm6bkMwMndlS0XEMexIhRC2359jg2Lc
         pnFNZyxXiYRzROd+zt05gTsJZ1ENGqHXGDnttXF2LwWReDwKofdQVZgeWSVyJhXylcwb
         GZ9je6AK7fp9LcwwvJ/pf6DT2ZvFv+zDEbGmA=
MIME-Version: 1.0
In-Reply-To: <1306006756-32009-1-git-send-email-geert@linux-m68k.org>
References: <1306006756-32009-1-git-send-email-geert@linux-m68k.org>
Date: Tue, 31 May 2011 09:47:15 +0200
X-Google-Sender-Auth: BqyPYEsuDcduP-xy7QxbjM4KsFI
Message-ID: <BANLkTi=YE4fSVQTNaYAwZ1YijqsUfTRmHg@mail.gmail.com>
Subject: Re: [PATCH 0/4] resources: Add lookup_resource()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-m68k@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 21, 2011 at 21:39, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> The resource system is a nice existing subsystem to implement simple allocators
> on top of.
> Unfortunately, there's no official method to find an existing resource by a
> resource start address, which is needed for a freeing function that just takes
> the start address of the region to free.
>
> Currently there are 3 users of the resource subsystem that implement this by
> traversing the resource tree theirselves:
>  - The Amiga Chip RAM allocator on m68k,
>  - iomap()/iounmap() on sparc,
>  - DMA allocation API on sparc.
> They all lack locking of the resource tree, as resource_lock is static in
> kernel/resource.c.
>
> Hence this patchset adds lookup_resource() and converts the above users to it.
>
>  [1/4] sparc: _sparc_find_resource() should check for exact matches
>  [2/4] resources: Add lookup_resource()
>  [3/4] m68k/amiga: Chip RAM - Use lookup_resource()
>  [4/4] sparc: iounmap() and *_free_coherent() - Use lookup_resource()

As I got two acks from David for the sparc bits and no objections, I
queued these
on my for-2.6.41 and for-next branches.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
