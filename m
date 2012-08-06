Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525Ab2HFCNF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 22:13:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5087 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755452Ab2HFCND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 22:13:03 -0400
Message-ID: <501F2812.70303@redhat.com>
Date: Sun, 05 Aug 2012 22:12:34 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: peterz@infradead.org, daniel.santos@pobox.com, aarcange@redhat.com,
        dwmw2@infradead.org, akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH v2 8/9] rbtree: faster augmented rbtree manipulation
References: <1343946858-8170-1-git-send-email-walken@google.com> <1343946858-8170-9-git-send-email-walken@google.com>
In-Reply-To: <1343946858-8170-9-git-send-email-walken@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2012 06:34 PM, Michel Lespinasse wrote:
> Introduce new augmented rbtree APIs that allow minimal recalculation of
> augmented node information.
>
> A new callback is added to the rbtree insertion and erase rebalancing
> functions, to be called on each tree rotations. Such rotations preserve
> the subtree's root augmented value, but require recalculation of the one
> child that was previously located at the subtree root.
>
> In the insertion case, the handcoded search phase must be updated to
> maintain the augmented information on insertion, and then the rbtree
> coloring/rebalancing algorithms keep it up to date.
>
> In the erase case, things are more complicated since it is library
> code that manipulates the rbtree in order to remove internal nodes.
> This requires a couple additional callbacks to copy a subtree's
> augmented value when a new root is stitched in, and to recompute
> augmented values down the ancestry path when a node is removed from
> the tree.
>
> In order to preserve maximum speed for the non-augmented case,
> we provide two versions of each tree manipulation function.
> rb_insert_augmented() is the augmented equivalent of rb_insert_color(),
> and rb_erase_augmented() is the augmented equivalent of rb_erase().
>
> Signed-off-by: Michel Lespinasse<walken@google.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
