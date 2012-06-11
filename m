Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499Ab2FKPFG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 11:05:06 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:35711 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752148Ab2FKPFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 11:05:01 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: jyKnJEMVM1lqdQJ18xq3Tb2qXzYVog6_rIB2obIHy_jGgxT
 JVHm4_PKyPdZgYH71A.xQerwaJF9J2qDJT.DXWVFNpX5LUc8Jg7IEP5fTBCs
 UNQLcUQQL0xKQZgaqd_sUWOqQ3PiF_2nSoxYgw5gmq2aXJl.e_75_8TwtOwb
 CyOHfQyev9jrpxWhnyLsnQDfRPIj9KMr_8a1C7H4kBtuesmjmbOBeKo20efu
 iWR_mN7w5ZZoJxgLpBuuM27EWfdjA.SaYcecYzSc1_iXt8XMiJgl51TzjA0p
 0mhYuU_o0j3F_4MwSBTdAyODzLoVfAyZPlQdeNvVmTju0KVNWm_yD.qDQX0T
 iRwIr3xzhsJiazvrCdDrCBoCB9oABE71VMXSKZYruw1gXf8fxAL8bHt8VGkc
 E29QkPOyoxWdYMWuk4.rPg3ndvgdiKj4SUevf
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 11 Jun 2012 10:04:58 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: JoonSoo Kim <js1304@gmail.com>
cc: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 1/4] slub: change declare of get_slab() to inline at all
 times
In-Reply-To: <CAAmzW4Nt2ev-M_Mw=xTaJEsRgKxrPNnz=rXrJenNA-6bEvZKtQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1206111004190.31180@router.home>
References: <1339176197-13270-1-git-send-email-js1304@gmail.com> <alpine.DEB.2.00.1206081401090.28466@router.home> <CAAmzW4Nt2ev-M_Mw=xTaJEsRgKxrPNnz=rXrJenNA-6bEvZKtQ@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Jun 2012, JoonSoo Kim wrote:

> 2012/6/9 Christoph Lameter <cl@linux.com>:
> > On Sat, 9 Jun 2012, Joonsoo Kim wrote:
> >
> >> -static struct kmem_cache *get_slab(size_t size, gfp_t flags)
> >> +static __always_inline struct kmem_cache *get_slab(size_t size, gfp_t flags)
> >
> > I thought that the compiler felt totally free to inline static functions
> > at will? This may be a matter of compiler optimization settings. I can
> > understand the use of always_inline in a header file but why in a .c file?
>
> Yes, but the compiler with -O2 doesn't inline get_slab() which
> declared just 'static'.
> I think that inlining get_slab() have a performance benefit, so add
> '__always_inline' to declare of get_slab().
> Other functions like slab_alloc, slab_free also use 'always_inline' in
> .c file (slub.c)

Yea I thought about removing those since I would think that the compiler
should be doing the right thing.

Does gcc inline with higher optimization settings?

