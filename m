Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844Ab1KRMuL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 07:50:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32825 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755027Ab1KRMuK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 07:50:10 -0500
Date: Fri, 18 Nov 2011 13:52:02 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-mm@kvack.org, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] mm,x86: remove debug_pagealloc_enabled
Message-ID: <20111118125201.GC2203@redhat.com>
References: <1321458232-6823-1-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321458232-6823-1-git-send-email-sgruszka@redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
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

Note this is more like fix than cleanup. Without patch, pages are not
protected until they are allocated and then freed again, what may
not happen if system is not used intensively.

If that patch can not be accepted, I think we should just go through
all free pages and mark then as not-presen in enable_debug_pagealloc()

Stanislaw
