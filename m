Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751561Ab0DVGFF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 02:05:05 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:42025 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab0DVGFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 02:05:02 -0400
Date: Thu, 22 Apr 2010 15:03:47 +0900
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: linux-mm <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [BUG] rmap: fix page_address_in_vma() to walk through
 anon_vma_chain
Message-ID: <20100422060347.GA10601@spritzerA.linux.bs1.fc.nec.co.jp>
References: <20100422054241.GB10957@spritzerA.linux.bs1.fc.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
In-Reply-To: <20100422054241.GB10957@spritzerA.linux.bs1.fc.nec.co.jp>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>                            mmap_sem      page_table_lock
>   mm/ksm.c:
>     write_protect_page()   hold          not hold
>     replace_page()         hold          not hold
>   mm/memory-failure.c:
>     add_to_kill()          not hold      hold
                                           ^^^^
Sorry, I misread here. This is "not hold".

Thanks,
Naoya Horiguchi
