Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759073Ab2CUPDN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 11:03:13 -0400
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:22768 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755236Ab2CUPDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 11:03:11 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: rbs6AhoVM1mhag9Bk.gm54kipY2cYGbqhFkT1UMZ39N3QZD
 6siDR6ynD5FUniRnz0d313LOLD0NCIfdI4K_dkaFBdJaxui3mGC3UW8cIX_p
 og4pk5EKtxxjveNV1II0rsOoGZokpK20FYBTYqqfkck8ZLBRo.ft0QWVA1PQ
 JZS1_Vf.D1hy8oBfLF7DfJsqBKewa61iZCkEpQim8K08TV0BH0hUX7grAaQG
 dPX_wsaF2I8xG05lJ0fhLd70P8KGJMgOGEU84JCVTYP6WaoIiMz.gh_yUZyc
 oHf3wFV1MZ4FiC0D2rrRXJHgtpZ1KEj6lPqbghkTNWhmpoo5iJZvxbSQkjwj
 jgxOPihw7vDhqLY1fwglz6K1_rRcHx3sogNh6lcm2fNuW4BWCPsZN2Fdk78a
 c
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 21 Mar 2012 10:03:07 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: Patch workqueue: create new slab cache instead of hacking
In-Reply-To: <1332341381.7893.17.camel@edumazet-glaptop>
Message-ID: <alpine.DEB.2.00.1203210959500.21932@router.home>
References: <1332238884-6237-1-git-send-email-laijs@cn.fujitsu.com> <1332238884-6237-7-git-send-email-laijs@cn.fujitsu.com> <20120320154619.GA5684@google.com> <4F6944D9.5090002@cn.fujitsu.com> <CAOS58YPydFUap4HjuRATxza6VZgyrXmQHVxR83G7GRJL50ZTRQ@mail.gmail.com>
 <alpine.DEB.2.00.1203210910450.20482@router.home> <1332341381.7893.17.camel@edumazet-glaptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2012, Eric Dumazet wrote:

> Creating a dedicated cache for few objects ? Thats a lot of overhead, at
> least for SLAB (no merges of caches)

Its some overhead for SLAB (a lot is what? If you tune down the per cpu
caches it should be a couple of pages) but its none for SLUB. Maybe we
need to add the merge logic to SLAB?

Or maybe we can extract a common higher handling level for kmem_cache
from all slab allocators and make merging standard.
