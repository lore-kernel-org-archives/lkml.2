Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181Ab0EQBej (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 21:34:39 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49302 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763Ab0EQBeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 21:34:36 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: [PATCH 1/9] mm: add generic adaptive large memory allocationAPIs
Cc: kosaki.motohiro@jp.fujitsu.com, peterz@infradead.org, xiaosuo@gmail.com,
       akpm@linux-foundation.org, hnguyen@de.ibm.com, raisch@de.ibm.com,
       rolandd@cisco.com, sean.hefty@intel.com, hal.rosenstock@gmail.com,
       divy@chelsio.com, James.Bottomley@suse.de, tytso@mit.edu,
       adilger@sun.com, viro@zeniv.linux.org.uk, menage@google.com,
       lizf@cn.fujitsu.com, linux-rdma@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-ext4@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
       containers@lists.linux-foundation.org, eric.dumazet@gmail.com
In-Reply-To: <201005132236.ADJ57893.FLFFMtOVJHOOSQ@I-love.SAKURA.ne.jp>
References: <1273756816.5605.3547.camel@twins> <201005132236.ADJ57893.FLFFMtOVJHOOSQ@I-love.SAKURA.ne.jp>
Message-Id: <20100517103050.21B6.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 17 May 2010 10:34:30 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Peter Zijlstra wrote:
> > NAK, I really utterly dislike that inatomic argument. The alloc side
> > doesn't function in atomic context either. Please keep the thing
> > symmetric in that regards.
> 
> Excuse me. kmalloc(GFP_KERNEL) may sleep (and therefore cannot be used in
> atomic context). However, kfree() for memory allocated with kmalloc(GFP_KERNEL)
> never sleep (and therefore can be used in atomic context).
> Why kmalloc() and kfree() are NOT kept symmetric?

In kmalloc case, we need to consider both kmalloc(GFP_KERNEL)/kfree() pair and
kmalloc(GFP_ATOMIC)/kfree() pair. latter is mainly used on atomic context.
To make kfree() atomic help to keep the implementation simple.

But kvmalloc don't have GFP_ATOMIC feautre. that's big difference.



