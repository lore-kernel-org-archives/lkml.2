Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750945Ab2F2EgS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 00:36:18 -0400
Received: from ozlabs.org ([203.10.76.45]:40407 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750787Ab2F2EgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 00:36:17 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Rafael Aquini <aquini@redhat.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>, Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Rafael Aquini <aquini@redhat.com>
Subject: Re: [PATCH v2 0/4] make balloon pages movable by compaction
In-Reply-To: <cover.1340916058.git.aquini@redhat.com>
References: <cover.1340916058.git.aquini@redhat.com>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Fri, 29 Jun 2012 14:01:52 +0930
Message-ID: <87r4syzqkn.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jun 2012 18:49:38 -0300, Rafael Aquini <aquini@redhat.com> wrote:
> This patchset follows the main idea discussed at 2012 LSFMMS section:
> "Ballooning for transparent huge pages" -- http://lwn.net/Articles/490114/
> 
> to introduce the required changes to the virtio_balloon driver, as well as
> changes to the core compaction & migration bits, in order to allow
> memory balloon pages become movable within a guest.
> 
> Rafael Aquini (4):
>   mm: introduce compaction and migration for virtio ballooned pages
>   virtio_balloon: handle concurrent accesses to virtio_balloon struct
>     elements
>   virtio_balloon: introduce migration primitives to balloon pages
>   mm: add vm event counters for balloon pages compaction
> 
>  drivers/virtio/virtio_balloon.c |  142 +++++++++++++++++++++++++++++++++++----
>  include/linux/mm.h              |   16 +++++
>  include/linux/virtio_balloon.h  |    6 ++
>  include/linux/vm_event_item.h   |    2 +
>  mm/compaction.c                 |  111 ++++++++++++++++++++++++------
>  mm/migrate.c                    |   32 ++++++++-
>  mm/vmstat.c                     |    4 ++
>  7 files changed, 280 insertions(+), 33 deletions(-)
> 
> 
> V2: address Mel Gorman's review comments

If Mel is happy, I am happy.  Seems sensible that the virtio_baloon
changes go in at the same time as the mm changes, so:

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Cheers,
Rusty.
