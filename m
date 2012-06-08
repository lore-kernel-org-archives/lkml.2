Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725Ab2FHTCQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 15:02:16 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:46489 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752887Ab2FHTCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 15:02:15 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: wTGHZ14VM1kH.S98d9iBg9ZCbSGJHBr7gC3Mm05hGpwjBrI
 O7h6AO4sum3jSrJpRYubjfVyXD8G1A.smXn9lkinZWfrgbvOhUnNygUM6kSC
 f0p7hX7d8RZqB5rGmMRU1go550U30ItpIoqBeeZsSJfAp7aLIAPwx7rx4GYh
 In6EMYMf1UGl7f0Wdpmuw3.KZ4XZIni6gGPUT3vEg3aZsc_noZv4OC7uMWqy
 G48DHFATAa.nw6ur6nKb_KjvVXZOPUUn.2qjNZc6L1En5APxiDxUygyDkWpi
 .Cnz3Z9HG2QARXpP_yBvW8XXKBBls1TofYGfwgJIcs41ukHZlUU8PJkLDIdV
 7myKX6JyoImjX7xSURsas5FHj2w3CtfY_EwrMRd_b9FtXhaEUWL9UK4i8dHA
 vJxAnwmGF7M5JKymCAI.Z3Yhjh7Tj28ClEijQ
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 8 Jun 2012 14:02:11 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Joonsoo Kim <js1304@gmail.com>
cc: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 1/4] slub: change declare of get_slab() to inline at all
 times
In-Reply-To: <1339176197-13270-1-git-send-email-js1304@gmail.com>
Message-ID: <alpine.DEB.2.00.1206081401090.28466@router.home>
References: <yes> <1339176197-13270-1-git-send-email-js1304@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Jun 2012, Joonsoo Kim wrote:

> -static struct kmem_cache *get_slab(size_t size, gfp_t flags)
> +static __always_inline struct kmem_cache *get_slab(size_t size, gfp_t flags)

I thought that the compiler felt totally free to inline static functions
at will? This may be a matter of compiler optimization settings. I can
understand the use of always_inline in a header file but why in a .c file?


