Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702Ab1HHO1U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 10:27:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:46402 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564Ab1HHO1S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 10:27:18 -0400
Subject: Re: [PATCH 4/5] writeback: per task dirty rate limit
From: Peter Zijlstra <peterz@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, Andrea Righi <arighi@develer.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Date: Mon, 08 Aug 2011 16:26:52 +0200
In-Reply-To: <20110808142318.GC22080@localhost>
References: <20110806084447.388624428@intel.com>
	 <20110806094527.002914580@intel.com> <1312811234.10488.34.camel@twins>
	 <20110808142318.GC22080@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1312813612.10488.36.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-08 at 22:23 +0800, Wu Fengguang wrote:
> +       preempt_disable();
> +       p = &__get_cpu_var(dirty_leaks);

 p = &get_cpu_var(dirty_leaks);

> +       if (*p > 0 && current->nr_dirtied < ratelimit) {
> +               nr_pages_dirtied = min(*p, ratelimit - current->nr_dirtied);
> +               *p -= nr_pages_dirtied;
> +               current->nr_dirtied += nr_pages_dirtied;
> +       }
> +       preempt_enable(); 

put_cpu_var(dirty_leads);
