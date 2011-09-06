Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751314Ab1IFQRB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 12:17:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:49849 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746Ab1IFQQy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 12:16:54 -0400
Subject: Re: [PATCH 15/18] writeback: charge leaked page dirties to active
 tasks
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        Dave Chinner <david@fromorbit.com>, Greg Thelen <gthelen@google.com>,
        Minchan Kim <minchan.kim@gmail.com>, Vivek Goyal <vgoyal@redhat.com>,
        Andrea Righi <arighi@develer.com>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 06 Sep 2011 18:16:36 +0200
In-Reply-To: <20110904020916.588150387@intel.com>
References: <20110904015305.367445271@intel.com>
	 <20110904020916.588150387@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1315325796.14232.20.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-09-04 at 09:53 +0800, Wu Fengguang wrote:
> The solution is to charge the pages dirtied by the exited gcc to the
> other random gcc/dd instances.

random dirtying task, seeing it lacks a !strcmp(t->comm, "gcc") || !
strcmp(t->comm, "dd") clause.

>  It sounds not perfect, however should
> behave good enough in practice. 

Seeing as that throttled tasks aren't actually running so those that are
running are more likely to pick it up and get throttled, therefore
promoting an equal spread.. ?
