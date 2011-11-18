Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757908Ab1KRNhG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 08:37:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51082 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756074Ab1KRNhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 08:37:04 -0500
Date: Fri, 18 Nov 2011 13:37:00 +0000
From: Mel Gorman <mgorman@suse.de>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-mm@kvack.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] mm,x86: remove debug_pagealloc_enabled
Message-ID: <20111118133700.GB20840@suse.de>
References: <1321458232-6823-1-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1321458232-6823-1-git-send-email-sgruszka@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 16, 2011 at 04:43:52PM +0100, Stanislaw Gruszka wrote:
> When (no)bootmem finish operation, it pass pages to buddy allocator.
> Since debug_pagealloc_enabled is not set, we will do not protect pages,
> what is not what we want with CONFIG_DEBUG_PAGEALLOC=y.
> 
> To fix remove debug_pagealloc_enabled. That variable was introduced by
> commit 12d6f21e "x86: do not PSE on CONFIG_DEBUG_PAGEALLOC=y" to get
> more CPA (change page attribude) code testing. But currently we have
> CONFIG_CPA_DEBUG, which test CPA.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

If no one objects to the impact on CPA testing, I see no problem with
this. I would assume that many bugs related to CPA would be rattled out
by now

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
