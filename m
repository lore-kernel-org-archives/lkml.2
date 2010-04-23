Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198Ab0DWCKd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 22:10:33 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:49491 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755101Ab0DWCK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 22:10:26 -0400
Date: Fri, 23 Apr 2010 11:06:32 +0900
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [BUG] rmap: fix page_address_in_vma() to walk through
 anon_vma_chain
Message-ID: <20100423020632.GA7383@spritzerA.linux.bs1.fc.nec.co.jp>
References: <20100422054241.GB10957@spritzerA.linux.bs1.fc.nec.co.jp>
 <4BD0688A.7050806@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
In-Reply-To: <4BD0688A.7050806@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> However, for anonymous pages, page_address_in_vma only
> ever determined whether the page _could_ be part of the
> VMA, never whether it actually was.
>
> The function page_address_in_vma has always given
> false positives, which means all of the callers already
> check that the page is actually part of the process.

I see.

> This means we may be able to get away with not verifying
> the anon_vma at all.  After all, verifying that the VMA
> has the anon_vma mapped does not mean the VMA has this
> page...
> 
> Doing away with that check gets rid of your locking
> conundrum :)

I get it, thank you :)
I'll rewrite fix patch based on your comments.

Thanks,
Naoya Horiguchi
