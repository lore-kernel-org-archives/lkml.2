Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911Ab2LLCcW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 21:32:22 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:40022 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754243Ab2LLCcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 21:32:21 -0500
Message-ID: <1355279182.1532.4.camel@kernel.cn.ibm.com>
Subject: Re: livelock in __writeback_inodes_wb ?
From: Simon Jeons <simon.jeons@gmail.com>
To: Dave Jones <davej@redhat.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, linux-mm@kvack.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        linux-fsdevel@vger.kernel.org
Date: Tue, 11 Dec 2012 20:26:22 -0600
In-Reply-To: <20121211142942.GA1943@redhat.com>
References: <20121128145515.GA26564@redhat.com>
	 <20121211082327.GA15706@localhost> <20121211142942.GA1943@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-12-11 at 09:29 -0500, Dave Jones wrote:
> On Tue, Dec 11, 2012 at 04:23:27PM +0800, Fengguang Wu wrote:
>  > On Wed, Nov 28, 2012 at 09:55:15AM -0500, Dave Jones wrote:
>  > > We had a user report the soft lockup detector kicked after 22
>  > > seconds of no progress, with this trace..
>  > 
>  > Where is the original report? The reporter may help provide some clues
>  > on the workload that triggered the bug.
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=880949 
> 
>  > The bug reporter should know best whether there are heavy IO.
>  > 
>  > However I suspect it's not directly caused by heavy IO: we will
>  > release &wb->list_lock before each __writeback_single_inode() call,
>  > which starts writeback IO for each inode.
>  > 
>  > > Should there be something in this loop periodically poking
>  > > the watchdog perhaps ?
>  > 
>  > It seems we failed to release &wb->list_lock in wb_writeback() for
>  > long time (dozens of seconds). That is, the inode_sleep_on_writeback()
>  > is somehow not called. However it's not obvious to me how come this
>  > can happen..
> 
> Right, it seems that we only drop the lock when there is more work to do.
> And if there is no work to do, then we would have bailed from the loop.

If no work to do, lock will be dropped after for loop.

> 
> mysterious.
> 
> 	Dave
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>


