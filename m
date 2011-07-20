Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535Ab1GTQSD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 12:18:03 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:38596 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752458Ab1GTQSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 12:18:01 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 7AGrbMYVM1m4.GGnujBGHEGKZ4to58f5ZYyi7MXr.IIuO7N
 1eJ7HmEhf2zTmJADcsdTLDsquH817WiiGEnHhUK665NQpAkqJJ8NzGx8XMQU
 vazk2LIycsBAc6eT.e34kDl_qyxtt.CClfIHaZmQeresvcqR8Bjcy_Qs7P7P
 LhzCHErhM93M0jTSplwTiJQjgYU1JgOS6qgJ7Ci2wrJQ7UbaPQmf5fXXAO9P
 ZzR76ojasqdcldensSTJrjYYZWtVrGIpyuFw5o.j1oG4Sad5KVogTDcuqmgE
 47HuNm3J28EQoAJsRaOwFO8PGQOwqSWUx4Z744223PcR1tQRlYbo_YD_BvxF
 LbSLQx67FjTvSAr5m3YfHXIfQ
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 20 Jul 2011 11:17:57 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Mel Gorman <mgorman@suse.de>, Pekka Enberg <penberg@kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH] mm-slab: allocate kmem_cache with __GFP_REPEAT
In-Reply-To: <1311177362.2338.57.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Message-ID: <alpine.DEB.2.00.1107201114480.1472@router.home>
References: <20110720121612.28888.38970.stgit@localhost6>  <alpine.DEB.2.00.1107201611010.3528@tiger> <20110720134342.GK5349@suse.de>  <alpine.DEB.2.00.1107200854390.32737@router.home>  <1311170893.2338.29.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> 
 <alpine.DEB.2.00.1107200950270.1472@router.home>  <1311174562.2338.42.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>  <alpine.DEB.2.00.1107201033080.1472@router.home> <1311177362.2338.57.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jul 2011, Eric Dumazet wrote:

> Note that adding ____cacheline_aligned_in_smp on nodelists[] actually
> helps performance, as all following fields are readonly after kmem_cache
> setup.

Well but that is not addresssing the same issue. Could you separate that
out?

The other question that follows from this is then: Does that
alignment compensate for the loss of performance due to the additional
lookup in hot code paths and the additional cacheline reference required?

The per node pointers are lower priority in terms of performance than the
per cpu pointers. I'd rather have the per node pointers requiring an
additional lookup. Less impact on hot code paths.

