Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322Ab0KVMB5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 07:01:57 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54641 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434Ab0KVMBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 07:01:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=V0xdf7C7qitLq/4249XJrNyu0xKerdUeN+vwwMsLH9gaXGYA5nKpFS8d+DKkMGaq+y
         OB93XEBpkZT3rbl5gqI6AoUXQwEysUTthFLi4I+EOcsrYCyWogE5MkwMMUVj84DEWuj7
         QRspLzpv7MsSP0QlpFMW7Shk/RpfYACiJEgls=
MIME-Version: 1.0
In-Reply-To: <20101119171653.3c476064.kamezawa.hiroyu@jp.fujitsu.com>
References: <20101119171033.a8d9dc8f.kamezawa.hiroyu@jp.fujitsu.com>
	<20101119171653.3c476064.kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 22 Nov 2010 21:01:54 +0900
Message-ID: <AANLkTikWeMH67nOSA-s3+OZqovyNRNoTw8wTr5_ecpOv@mail.gmail.com>
Subject: Re: [PATCH 4/4] alloc_contig_pages() use better allocation function
 for migration
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bob Liu <lliubbo@gmail.com>, fujita.tomonori@lab.ntt.co.jp,
        m.nazarewicz@samsung.com, pawel@osciak.com, andi.kleen@intel.com,
        felipe.contreras@gmail.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 19, 2010 at 5:16 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>
> Old story.
> Because we cannot assume which memory section will be offlined next,
> hotremove_migrate_alloc() just uses alloc_page(). i.e. make no decision
> where the page should be migrate into. Considering memory hotplug's
> nature, the next memory section near to a section which is being removed
> will be removed in the next. So, migrate pages to the same node of original
> page doesn't make sense in many case, it just increases load.
> Migration destination page is allocated from the node where offlining script
> runs.
>
> Now, contiguous-alloc uses do_migrate_range(). In this case, migration
> destination node should be the same node of migration source page.
>
> This patch modifies hotremove_migrate_alloc() and pass "nid" to it.
> Memory hotremove will pass -1. So, if the page will be moved to
> the node where offlining script runs....no behavior changes.
>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>


-- 
Kind regards,
Minchan Kim
