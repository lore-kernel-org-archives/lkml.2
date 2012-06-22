Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761967Ab2FVJ6M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 05:58:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:35507 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761949Ab2FVJ6L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 05:58:11 -0400
Message-ID: <1340359079.18025.56.camel@twins>
Subject: Re: [PATCH -mm v2 01/11] mm: track free size between VMAs in VMA
 rbtree
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@surriel.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, aarcange@redhat.com,
        minchan@gmail.com, kosaki.motohiro@gmail.com, andi@firstfloor.org,
        hannes@cmpxchg.org, mel@csn.ul.ie, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>
Date: Fri, 22 Jun 2012 11:57:59 +0200
In-Reply-To: <1340315835-28571-2-git-send-email-riel@surriel.com>
References: <1340315835-28571-1-git-send-email-riel@surriel.com>
	 <1340315835-28571-2-git-send-email-riel@surriel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-21 at 17:57 -0400, Rik van Riel wrote:
> +/*
> + * Use the augmented rbtree code to propagate info on the largest
> + * free gap between VMAs up the VMA rbtree.
> + */
> +static void adjust_free_gap(struct vm_area_struct *vma)
> +{
> +       rb_augment_erase_end(&vma->vm_rb, vma_rb_augment_cb, NULL);
> +} 

I was more thinking along the lines of:

/*
 * Abuse rb_augment_erase_end() to propagate a modification up
 * the tree by pretending the modified node is the deepest node
 * still in the tree.
 */


Alternatively, we could add rb_augment_mod() or somesuch.
