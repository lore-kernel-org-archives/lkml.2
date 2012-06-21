Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758827Ab2FULC1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 07:02:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60599 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758399Ab2FULC0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 07:02:26 -0400
Message-ID: <1340276491.21745.170.camel@twins>
Subject: Re: [PATCH -mm 1/7] mm: track free size between VMAs in VMA rbtree
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, aarcange@redhat.com,
        minchan@gmail.com, kosaki.motohiro@gmail.com, andi@firstfloor.org,
        hannes@cmpxchg.org, mel@csn.ul.ie, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@surriel.com>
Date: Thu, 21 Jun 2012 13:01:31 +0200
In-Reply-To: <1340057126-31143-2-git-send-email-riel@redhat.com>
References: <1340057126-31143-1-git-send-email-riel@redhat.com>
	 <1340057126-31143-2-git-send-email-riel@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-18 at 18:05 -0400, Rik van Riel wrote:
> +static void adjust_free_gap(struct vm_area_struct *vma)
> +{
> +       rb_augment_erase_end(&vma->vm_rb, vma_rb_augment_cb, NULL);
> +} 

This is a somewhat unorthodox usage of the rb_augment_erase_end()
function, at the very least that wants a comment.
