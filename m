Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563Ab2FMD70 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 23:59:26 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:28101 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751986Ab2FMD7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 23:59:23 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ak4JAHgP2E95LKXc/2dsb2JhbABFtAUEgS2BCIIYAQEFJxMcIxAIAxUDLhQNGAMhE4d9Awqvew2JThSKMWJJhUgDlSCLAIR9gnI
Date: Wed, 13 Jun 2012 13:59:20 +1000
From: Dave Chinner <david@fromorbit.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Wanpeng Li <liwp.linux@gmail.com>, linux-kernel@vger.kernel.org,
        Gavin Shan <shangw@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] writeback: avoid race when update bandwidth
Message-ID: <20120613035920.GV22848@dastard>
References: <1339501561-4570-1-git-send-email-liwp.linux@gmail.com>
 <20120612115219.GA17348@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120612115219.GA17348@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 07:52:19PM +0800, Fengguang Wu wrote:
> On Tue, Jun 12, 2012 at 07:46:01PM +0800, Wanpeng Li wrote:
> > From: Wanpeng Li <liwp@linux.vnet.ibm.com>
> > 
> > "V1 -> V2"
> > * remove dirty_lock
> > 
> > Since bdi->wb.list_lock is used to protect the b_* lists,
> > so the flushers who call wb_writeback to writeback pages will
> > stuck when bandwidth update policy holds this lock. In order
> > to avoid this race we can introduce a new bandwidth_lock who
> > is responsible for protecting bandwidth update policy.
> > 
> > Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
> 
> Applied with a new title "writeback: use a standalone lock for
> updating write bandwidth". "race" is sensitive because it often
> refers to some locking error.

Fengguang - can we get some evidence that this is a contended lock
before changing the scope of it? All of the previous "breaking up
global locks" have been done based on lock contention data, so
moving back to a global lock for this needs to have the same
analysis provided...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
