Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584Ab1FVMPV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 08:15:21 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:42781
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752552Ab1FVMPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 08:15:20 -0400
Date: Wed, 22 Jun 2011 08:15:16 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Michel Lespinasse <walken@google.com>
Subject: Re: [PATCH] mm: Do not keep page locked during page fault while
 charging it for memcg
Message-ID: <20110622121516.GA28359@infradead.org>
References: <20110622120635.GB14343@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110622120635.GB14343@tiehlicka.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +
> +			/* We have to drop the page lock here because memcg
> +			 * charging might block for unbound time if memcg oom
> +			 * killer is disabled.
> +			 */
> +			unlock_page(vmf.page);
> +			ret = mem_cgroup_newpage_charge(page, mm, GFP_KERNEL);
> +			lock_page(vmf.page);

This introduces a completely poinless unlock/lock cycle for non-memcg
pagefaults.  Please make sure it only happens when actually needed.

