Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779Ab1BXMiQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 07:38:16 -0500
Received: from casper.infradead.org ([85.118.1.10]:54857 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296Ab1BXMiP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 07:38:15 -0500
Subject: Re: [PATCH] mm: remove worrying dead code from find_get_pages()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Hugh Dickins <hughd@google.com>
Cc: Nick Piggin <npiggin@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Salman Qazi <sqazi@google.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <alpine.LSU.2.00.1102232127590.2239@sister.anvils>
References: <alpine.LSU.2.00.1102232127590.2239@sister.anvils>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 24 Feb 2011 13:38:00 +0100
Message-ID: <1298551080.2428.42.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-23 at 21:31 -0800, Hugh Dickins wrote:
> The radix_tree_deref_retry() case in find_get_pages() has a strange
> little excrescence, not seen in the other gang lookups: it looks like
> the start of an abandoned attempt to guarantee forward progress in a
> case that cannot arise.
> 
> ret should always be 0 here: if it isn't, then going back to restart
> will leak references to pages already gotten.  There used to be a
> comment saying nr_found is necessarily 1 here: that's not quite true,
> but the radix_tree_deref_retry() case is peculiar to the entry at index
> 0, when we race with it being moved out of the radix_tree root or back.
> 
> Remove the worrisome two lines, add a brief comment here and in
> find_get_pages_contig() and find_get_pages_tag(), and a WARN_ON
> in find_get_pages() should it ever be seen elsewhere than at 0.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>


