Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163Ab2FIP5u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 11:57:50 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:61284 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649Ab2FIP5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 11:57:48 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1206081401090.28466@router.home>
References: <1339176197-13270-1-git-send-email-js1304@gmail.com>
	<alpine.DEB.2.00.1206081401090.28466@router.home>
Date: Sun, 10 Jun 2012 00:57:48 +0900
Message-ID: <CAAmzW4Nt2ev-M_Mw=xTaJEsRgKxrPNnz=rXrJenNA-6bEvZKtQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] slub: change declare of get_slab() to inline at all times
From: JoonSoo Kim <js1304@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/9 Christoph Lameter <cl@linux.com>:
> On Sat, 9 Jun 2012, Joonsoo Kim wrote:
>
>> -static struct kmem_cache *get_slab(size_t size, gfp_t flags)
>> +static __always_inline struct kmem_cache *get_slab(size_t size, gfp_t flags)
>
> I thought that the compiler felt totally free to inline static functions
> at will? This may be a matter of compiler optimization settings. I can
> understand the use of always_inline in a header file but why in a .c file?

Yes, but the compiler with -O2 doesn't inline get_slab() which
declared just 'static'.
I think that inlining get_slab() have a performance benefit, so add
'__always_inline' to declare of get_slab().
Other functions like slab_alloc, slab_free also use 'always_inline' in
.c file (slub.c)
