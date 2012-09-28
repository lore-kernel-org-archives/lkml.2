Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031441Ab2I1W02 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 18:26:28 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:34607 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932191Ab2I1W00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 18:26:26 -0400
MIME-Version: 1.0
In-Reply-To: <50654F6E.7090000@cn.fujitsu.com>
References: <1348728470-5580-1-git-send-email-laijs@cn.fujitsu.com>
 <1348728470-5580-3-git-send-email-laijs@cn.fujitsu.com> <5064CD7F.1040507@gmail.com>
 <0000013a09dec004-497e7afa-8c0f-46ff-bf8e-056f7df1ed0b-000000@email.amazonses.com>
 <50654F6E.7090000@cn.fujitsu.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Fri, 28 Sep 2012 18:26:05 -0400
Message-ID: <CAHGf_=pUMDm2M2wGvnsqrDgnhj0oHUO4JVuG=u3Qcn3TLvGRgg@mail.gmail.com>
Subject: Re: [PATCH 2/3] slub, hotplug: ignore unrelated node's hot-adding and hot-removing
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Christoph <cl@linux.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 3:19 AM, Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> HI, Christoph, KOSAKI
>
> SLAB always allocates kmem_list3 for all nodes(N_HIGH_MEMORY), also node bug/bad things happens.
> SLUB always requires kmem_cache_node on the correct node, so these fix is needed.
>
> SLAB uses for_each_online_node() to travel nodes and do maintain,
> and it tolerates kmem_list3 on alien nodes.
> SLUB uses for_each_node_state(node, N_NORMAL_MEMORY) to travel nodes and do maintain,
> and it does not tolerate kmem_cache_node on alien nodes.
>
> Maybe we need to change SLAB future and let it use
> for_each_node_state(node, N_NORMAL_MEMORY), But I don't want to change SLAB
> until I find something bad in SLAB.

SLAB can't use highmem. then traverse zones which don't have normal
memory is silly IMHO.
If this is not bug, current slub behavior is also not bug. Is there
any difference?

If I understand correctly, current code may waste some additional
memory on corner case. but it doesn't make memory leak both when slab
and slub.
