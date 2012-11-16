Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751361Ab2KPAkX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 19:40:23 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50292 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab2KPAkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 19:40:22 -0500
Message-ID: <50A58B6E.8090609@gmail.com>
Date: Fri, 16 Nov 2012 08:40:14 +0800
From: Jaegeuk Hanse <jaegeuk.hanse@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tmpfs: fix shmem_getpage_gfp VM_BUG_ON
References: <20121025023738.GA27001@redhat.com> <alpine.LNX.2.00.1210242121410.1697@eggly.anvils> <20121101191052.GA5884@redhat.com> <alpine.LNX.2.00.1211011546090.19377@eggly.anvils> <20121101232030.GA25519@redhat.com> <alpine.LNX.2.00.1211011627120.19567@eggly.anvils> <20121102014336.GA1727@redhat.com> <alpine.LNX.2.00.1211021606580.11106@eggly.anvils> <alpine.LNX.2.00.1211051729590.963@eggly.anvils> <20121106135402.GA3543@redhat.com> <alpine.LNX.2.00.1211061521230.6954@eggly.anvils> <50A30ADD.9000209@gmail.com> <alpine.LNX.2.00.1211131935410.30540@eggly.anvils> <50A49C46.9040406@gmail.com> <alpine.LNX.2.00.1211151126440.9273@eggly.anvils>
In-Reply-To: <alpine.LNX.2.00.1211151126440.9273@eggly.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2012 03:56 AM, Hugh Dickins wrote:
> Offtopic...
>
> On Thu, 15 Nov 2012, Jaegeuk Hanse wrote:
>> Another question. Why the function shmem_fallocate which you add to kernel
>> need call shmem_getpage?
> Because shmem_getpage(_gfp) is where shmem's
> page lookup and allocation complexities are handled.
>
> I assume the question behind your question is: why does shmem actually
> allocate pages for its fallocate, instead of just reserving the space?

Yeah, this is what I want to know.

>
> I did play with just reserving the space, with more special entries in
> the radix_tree to note the reservations made.  It should be doable for
> the vm_enough_memory and sbinfo->used_blocks reservations.
>
> What absolutely deterred me from taking that path was the mem_cgroup
> case: shmem and swap and memcg are not easy to get working right together,
> and nobody would thank me for complicating memcg just for shmem_fallocate.
>
> By allocating pages, the pre-existing memcg code just works; if we used
> reservations instead, we would have to track their memcg charges in some
> additional new way.  I see no justification for that complication.

Oh, I see, thanks Hugh. :-)

> Hugh

