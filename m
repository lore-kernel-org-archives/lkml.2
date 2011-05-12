Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757864Ab1ELOn2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 10:43:28 -0400
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:23426 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752789Ab1ELOn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 10:43:26 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: IOyCbZoVM1milIbsRFrjM8nJOHK4N2nShG_HLWSmb_LxfKU
 vVAwsiBREaMRZr8og9NxwE4v7S.wI48QOnbrdJDSYCFDTxSF_UKuU5G.ZooS
 zkTOLV9zkx3LHBQYghpzTSKRqo0gHOLyqJ3w0RIcO_SXuTS88HtGfcNOR.70
 UkHaLfO6NXwi2.dibCdKe4yjsFRtcP3tFIrUZKaQxFLvjIvXx8zty2jfoQ6D
 JfmkgS6EifSazH9TymYTfdnBhLor5tY3FHVBHPcCu0tj5ObJPKizYyQGfPtk
 kwf6OZQRXXchlphoLt7faQgzJ.eaoCaLr3pFMRHTTTymhgRoT
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 12 May 2011 09:43:21 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mel Gorman <mgorman@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Colin King <colin.king@canonical.com>,
        Raghavendra D Prabhu <raghu.prabhu13@gmail.com>,
        Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@oracle.com>,
        Pekka Enberg <penberg@kernel.org>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 3/3] mm: slub: Default slub_max_order to 0
In-Reply-To: <1305127773-10570-4-git-send-email-mgorman@suse.de>
Message-ID: <alpine.DEB.2.00.1105120942050.24560@router.home>
References: <1305127773-10570-1-git-send-email-mgorman@suse.de> <1305127773-10570-4-git-send-email-mgorman@suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 May 2011, Mel Gorman wrote:

> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2198,7 +2198,7 @@ EXPORT_SYMBOL(kmem_cache_free);
>   * take the list_lock.
>   */
>  static int slub_min_order;
> -static int slub_max_order = PAGE_ALLOC_COSTLY_ORDER;
> +static int slub_max_order;

If we really need to do this then do not push this down to zero please.
SLAB uses order 1 for the meax. Lets at least keep it theere.

We have been using SLUB for a long time. Why is this issue arising now?
Due to compaction etc making reclaim less efficient?

