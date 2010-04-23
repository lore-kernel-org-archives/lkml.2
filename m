Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533Ab0DWNwj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 09:52:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34616 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756419Ab0DWNwe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 09:52:34 -0400
Message-ID: <4BD1A609.4040401@redhat.com>
Date: Fri, 23 Apr 2010 09:52:09 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
CC: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] [BUGFIX] rmap: remove anon_vma check in page_address_in_vma()
References: <20100422054241.GB10957@spritzerA.linux.bs1.fc.nec.co.jp> <4BD0688A.7050806@redhat.com> <20100423020827.GB7383@spritzerA.linux.bs1.fc.nec.co.jp>
In-Reply-To: <20100423020827.GB7383@spritzerA.linux.bs1.fc.nec.co.jp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2010 10:08 PM, Naoya Horiguchi wrote:
> Currently page_address_in_vma() compares vma->anon_vma and page_anon_vma(page)
> for parameter check, but in 2.6.34 a vma can have multiple anon_vmas with
> anon_vma_chain, so current check does not work. (For anonymous page shared by
> multiple processes, some verified (page,vma) pairs return -EFAULT wrongly.)
>
> We can go to checking all anon_vmas in the "same_vma" chain, but it needs
> to meet lock requirement. Instead, we can remove anon_vma check safely
> because page_address_in_vma() assumes that page and vma are already checked
> to belong to the identical process.
>
> Signed-off-by: Naoya Horiguchi<n-horiguchi@ah.jp.nec.com>
> Cc: Andrew Morton<akpm@linux-foundation.org>
> Cc: Rik van Riel<riel@redhat.com>
> Cc: Andi Kleen<andi@firstfloor.org>

Reviewed-by: Rik van Riel <riel@redhat.com>
