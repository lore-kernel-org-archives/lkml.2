Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393Ab1CUIeZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 04:34:25 -0400
Received: from mtagate5.uk.ibm.com ([194.196.100.165]:46770 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123Ab1CUIeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 04:34:22 -0400
Date: Mon, 21 Mar 2011 09:34:12 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Prasad Joshi <prasadjoshi124@gmail.com>
Cc: heiko.carstens@de.ibm.com, linux390@de.ibm.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, mitra@kqinfotech.com
Subject: Re: [RFC][PATCH v3 09/22] mm, s390: add gfp flags variant of pud,
 pte, and pte allocations
Message-ID: <20110321093412.2776a69f@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <20110318195643.GJ4746@prasad-kvm>
References: <20110318194135.GA4746@prasad-kvm>
	<20110318194341.GB4746@prasad-kvm>
	<20110318194600.GC4746@prasad-kvm>
	<20110318194740.GD4746@prasad-kvm>
	<20110318194929.GE4746@prasad-kvm>
	<20110318195035.GF4746@prasad-kvm>
	<20110318195141.GG4746@prasad-kvm>
	<20110318195307.GH4746@prasad-kvm>
	<20110318195507.GI4746@prasad-kvm>
	<20110318195643.GJ4746@prasad-kvm>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Mar 2011 19:56:44 +0000
Prasad Joshi <prasadjoshi124@gmail.com> wrote:

> - Added function __crst_table_alloc() which is similar to crst_table_alloc()
>   but accepts an extra argument gfp_t. The function uses given allocation
>   flag to allocate pages.
> 
> - Added a function __page_table_alloc() to allocate page table entries. This
>   function is allows caller to specify the page allocation flag. The
>   allocation flag is then passed to alloc_page(). The rest of the function is
>   copy of the original page_table_alloc().

The approach of this patch series seems straightforward, the only nitpick I
have is the fact that two new functions __crst_table_alloc/__page_table_alloc
are introduced. There aren't many call sites for the two original functions,
namely 4 for crst_table_alloc and 3 for page_table_alloc. Why not add the
gfp flag GFP_KERNEL to these call sites? Then the two additional functions
would not be needed.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

