Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184Ab0HQIZQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 04:25:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:59447 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411Ab0HQIZO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 04:25:14 -0400
Subject: Re: [RFC][PATCH] Per file dirty limit throttling
From: Peter Zijlstra <peterz@infradead.org>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: Wu Fengguang <fengguang.wu@intel.com>, Bill Davidsen <davidsen@tmr.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
In-Reply-To: <201008171039.23701.knikanth@suse.de>
References: <201008160949.51512.knikanth@suse.de>
	 <1281956742.1926.1217.camel@laptop>  <201008171039.23701.knikanth@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 17 Aug 2010 10:24:35 +0200
Message-ID: <1282033475.1926.2093.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-17 at 10:39 +0530, Nikanth Karthikesan wrote:
> Oh, nice.  Per-task limit is an elegant solution, which should help during 
> most of the common cases.
> 
> But I just wonder what happens, when
> 1. The dirtier is multiple co-operating processes
> 2. Some app like a shell script, that repeatedly calls dd with seek and skip? 
> People do this for data deduplication, sparse skipping etc..
> 3. The app dies and comes back again. Like a VM that is rebooted, and 
> continues writing to a disk backed by a file on the host.
> 
> Do you think, in those cases this might still be useful? 

Those cases do indeed defeat the current per-task-limit, however I think
the solution to that is to limit the amount of writeback done by each
blocked process.

Jan Kara had some good ideas in that department.
