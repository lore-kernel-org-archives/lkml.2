Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467Ab1IFMOY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 08:14:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:38111 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424Ab1IFMOS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 08:14:18 -0400
Subject: Re: [PATCH 06/18] writeback: IO-less balance_dirty_pages()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        Dave Chinner <david@fromorbit.com>, Greg Thelen <gthelen@google.com>,
        Minchan Kim <minchan.kim@gmail.com>, Vivek Goyal <vgoyal@redhat.com>,
        Andrea Righi <arighi@develer.com>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 06 Sep 2011 14:13:53 +0200
In-Reply-To: <20110904020915.383842632@intel.com>
References: <20110904015305.367445271@intel.com>
	 <20110904020915.383842632@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1315311233.12533.3.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-09-04 at 09:53 +0800, Wu Fengguang wrote:
> -static inline void task_dirties_fraction(struct task_struct *tsk,
> -               long *numerator, long *denominator)
> -{
> -       prop_fraction_single(&vm_dirties, &tsk->dirties,
> -                               numerator, denominator);
> -} 

it looks like this patch removes all users of tsk->dirties, but doesn't
in fact remove the data member from task_struct.
