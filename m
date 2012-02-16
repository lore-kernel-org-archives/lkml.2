Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993Ab2BPAyO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 19:54:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56173 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472Ab2BPAyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 19:54:10 -0500
Date: Wed, 15 Feb 2012 16:54:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: linux-mm@kvack.org, David Rientjes <rientjes@google.com>,
        Andi Kleen <andi@firstfloor.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] introduce pmd_to_pte_t()
Message-Id: <20120215165408.a111eefa.akpm@linux-foundation.org>
In-Reply-To: <1328716302-16871-6-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1328716302-16871-1-git-send-email-n-horiguchi@ah.jp.nec.com>
	<1328716302-16871-6-git-send-email-n-horiguchi@ah.jp.nec.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  8 Feb 2012 10:51:41 -0500
Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:

> Casting pmd into pte_t to handle thp is strongly architecture dependent.
> This patch introduces a new function to separate this dependency from
> independent part.
> 
>
> ...
>
> --- 3.3-rc2.orig/include/asm-generic/pgtable.h
> +++ 3.3-rc2/include/asm-generic/pgtable.h
> @@ -434,6 +434,10 @@ static inline int pmd_trans_splitting(pmd_t pmd)
>  {
>  	return 0;
>  }
> +static inline pte_t pmd_to_pte_t(pmd_t *pmd)
> +{
> +	return 0;
> +}

This doesn't compile.

And I can't think of a sensible way of generating a stub for this
operation - if you have a pmd_t and want to convert it to a pte_t then
just convert it, dammit.  And there's no rationality behind making that
conversion unavailable or inoperative if CONFIG_TRANSPARENT_HUGEPAGE=n?

Shudder.  I'll drop the patch.  Rethink, please.
