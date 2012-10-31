Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509Ab2JaHKE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 03:10:04 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:40431 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560Ab2JaHKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 03:10:00 -0400
MIME-Version: 1.0
In-Reply-To: <1351071840-5060-3-git-send-email-laijs@cn.fujitsu.com>
References: <1351071840-5060-1-git-send-email-laijs@cn.fujitsu.com>
	<1351071840-5060-3-git-send-email-laijs@cn.fujitsu.com>
Date: Wed, 31 Oct 2012 09:09:58 +0200
X-Google-Sender-Auth: SUbKsWUthOCyaJI7HkHgTPzZBtI
Message-ID: <CAOJsxLFm3UXqz12_0kAXq7f+BkNAwY1a=rExgZTweD1dkT4yJg@mail.gmail.com>
Subject: Re: [PATCH 2/2 V2] slub, hotplug: ignore unrelated node's hot-adding
 and hot-removing
From: Pekka Enberg <penberg@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiang Liu <jiang.liu@huawei.com>, Kay Sievers <kay.sievers@vrfy.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Mel Gorman <mgorman@suse.de>,
        FNST-Wen Congyang <wency@cn.fujitsu.com>, linux-doc@vger.kernel.org,
        linux-mm@kvack.org, Christoph Lameter <cl@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 12:43 PM, Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> SLUB only fucus on the nodes which has normal memory, so ignore the other
> node's hot-adding and hot-removing.
>
> Aka: if some memroy of a node(which has no onlined memory) is online,
> but this new memory onlined is not normal memory(HIGH memory example),
> we should not allocate kmem_cache_node for SLUB.
>
> And if the last normal memory is offlined, but the node still has memroy,
> we should remove kmem_cache_node for that node.(current code delay it when
> all of the memory is offlined)
>
> so we only do something when marg->status_change_nid_normal > 0.
> marg->status_change_nid is not suitable here.
>
> The same problem doesn't exsit in SLAB, because SLAB allocates kmem_list3
> for every node even the node don't have normal memory, SLAB tolerates
> kmem_list3 on alien nodes. SLUB only fucus on the nodes which has normal
> memory, it don't tolerates alien kmem_cache_node, the patch makes
> SLUB become self-compatible and avoid WARN and BUG in a rare condition.
>
> CC: David Rientjes <rientjes@google.com>
> Cc: Minchan Kim <minchan.kim@gmail.com>
> CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> CC: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> CC: Rob Landley <rob@landley.net>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Jiang Liu <jiang.liu@huawei.com>
> CC: Kay Sievers <kay.sievers@vrfy.org>
> CC: Greg Kroah-Hartman <gregkh@suse.de>
> CC: Mel Gorman <mgorman@suse.de>
> CC: 'FNST-Wen Congyang' <wency@cn.fujitsu.com>
> CC: linux-doc@vger.kernel.org
> CC: linux-kernel@vger.kernel.org
> CC: linux-mm@kvack.org
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

The patch looks OK but changelog doesn't say what problem this fixes,
how you found about it, and do we need this in stable.
