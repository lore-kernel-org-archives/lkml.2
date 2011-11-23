Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596Ab1KWTHY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 14:07:24 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49803 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885Ab1KWTHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 14:07:23 -0500
Date: Wed, 23 Nov 2011 11:07:05 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Cong Wang <amwang@redhat.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Pekka Enberg <penberg@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay.sievers@vrfy.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org
Subject: Re: [V3 PATCH 1/2] tmpfs: add fallocate support
In-Reply-To: <1322038412-29013-1-git-send-email-amwang@redhat.com>
Message-ID: <alpine.LSU.2.00.1111231100110.2226@sister.anvils>
References: <1322038412-29013-1-git-send-email-amwang@redhat.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Nov 2011, Cong Wang wrote:
> +
> +	while (index < end) {
> +		ret = shmem_getpage(inode, index, &page, SGP_WRITE, NULL);
> +		if (ret) {
> +			if (ret == -ENOSPC)
> +				goto undo;
...
> +undo:
> +	while (index > start) {
> +		shmem_truncate_page(inode, index);
> +		index--;
> +	}

As I said before, I won't actually be reviewing and testing this for
a week or two; but before this goes any further, must point out how
wrong it is.  Here you'll be deleting any pages in the range that were
already present before the failing fallocate().

Hugh
