Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab2FPGK6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 02:10:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40918 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996Ab2FPGK5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 02:10:57 -0400
MIME-Version: 1.0
In-Reply-To: <20120616045637.GA2331@kernel>
References: <alpine.LSU.2.00.1206151752420.8741@eggly.anvils>
	<20120616045637.GA2331@kernel>
Date: Sat, 16 Jun 2012 14:10:56 +0800
Message-ID: <CAM_iQpXPH2SgjKbj1g5azcddusBmQ0CDvDz_RJe2r2HSTo51yA@mail.gmail.com>
Subject: Re: [PATCH] swap: fix shmem swapping when more than 8 areas
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Wanpeng Li <liwp.linux@gmail.com>
Cc: Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 16, 2012 at 12:56 PM, Wanpeng Li <liwp.linux@gmail.com> wrote:
>>-#define SWP_TYPE_SHIFT(e)     (sizeof(e.val) * 8 - MAX_SWAPFILES_SHIFT)
>>+#define SWP_TYPE_SHIFT(e)     ((sizeof(e.val) * 8) - \
>>+                      (MAX_SWAPFILES_SHIFT + RADIX_TREE_EXCEPTIONAL_SHIFT))
>
> Hi Hugh,
>
> Since SHIFT == MAX_SWAPFILES_SHIFT + RADIX_TREE_EXCEPTIONAL_SHIFT == 7
> and the low two bits used for radix_tree, the available swappages number
> based of 32bit architectures reduce to 2^(32-7-2) = 32GB?
>

The lower two bits are in the 7 bits you calculated,
so it is 2^(32-7), not 2^(32-7-2)
