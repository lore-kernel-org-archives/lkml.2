Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940Ab2AEMtn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 07:49:43 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:46984 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751184Ab2AEMtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 07:49:42 -0500
MIME-Version: 1.0
In-Reply-To: <84FF21A720B0874AA94B46D76DB9826904554270@008-AM1MPN1-003.mgdnok.nokia.com>
References: <cover.1325696593.git.leonid.moiseichuk@nokia.com>
	<e78b4ac9d3d51ac16180114c08733e4bf62ec65e.1325696593.git.leonid.moiseichuk@nokia.com>
	<20120105155950.9e49651b.kamezawa.hiroyu@jp.fujitsu.com>
	<84FF21A720B0874AA94B46D76DB9826904554270@008-AM1MPN1-003.mgdnok.nokia.com>
Date: Thu, 5 Jan 2012 14:49:42 +0200
X-Google-Sender-Auth: 0KdYv0BiTBsQs-PcqrzNL8UKu4Y
Message-ID: <CAOJsxLF706VeThxqWostJr84N_8q8UXoQzxGmMXj8mpgTLCagg@mail.gmail.com>
Subject: Re: [PATCH 3.2.0-rc1 2/3] MM hook for page allocation and release
From: Pekka Enberg <penberg@kernel.org>
To: leonid.moiseichuk@nokia.com
Cc: kamezawa.hiroyu@jp.fujitsu.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, cesarb@cesarb.net, emunson@mgebm.net,
        aarcange@redhat.com, riel@redhat.com, mel@csn.ul.ie,
        rientjes@google.com, dima@android.com, gregkh@suse.de,
        rebecca@android.com, san@google.com, akpm@linux-foundation.org,
        vesa.jaaskelainen@nokia.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 5, 2012 at 1:26 PM,  <leonid.moiseichuk@nokia.com> wrote:
> I agree that hooking alloc_pages is ugly way. So alternatives I see:
>
> - shrinkers (as e.g. Android OOM used) but shrink_slab called only from
> try_to_free_pages only if we are on slow reclaim path on memory allocation,
> so it cannot be used for e.g. 75% memory tracking or when pages released to
> notify user space that we are OK. But according to easy to use it will be the
> best approach.
>
> - memcg-kind of changes like mem_cgroup_newpage_charge/uncharge_page but
> without blocking decision making logic. Seems to me more changes. Threshold
> currently in memcg set 128 pages per CPU, that is quite often for level
> tracking needs.
>
> - tracking situation using timer? Maybe not due to will impact battery.

Can we hook into mm/vmscan.c and mm/page-writeback.c for this?

                                Pekka
