Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750855Ab0IWEF3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 00:05:29 -0400
Received: from fieldses.org ([174.143.236.118]:40061 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750702Ab0IWEF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 00:05:28 -0400
Date: Thu, 23 Sep 2010 00:03:55 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Neil Brown <neilb@suse.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the nfsd tree
Message-ID: <20100923040354.GC13554@fieldses.org>
References: <20100923113429.88f865d2.sfr@canb.auug.org.au>
 <20100923023315.GA10764@fieldses.org>
 <20100923125146.01755207@notabene>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100923125146.01755207@notabene>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 23, 2010 at 12:51:46PM +1000, Neil Brown wrote:
> On Wed, 22 Sep 2010 22:33:15 -0400
> "J. Bruce Fields" <bfields@fieldses.org> wrote:
> sched.h says:
> 
> 	char comm[TASK_COMM_LEN]; /* executable name excluding path
> 				     - access with [gs]et_task_comm (which lock
> 				       it with task_lock())
> 				     - initialized normally by setup_new_exec */
> 
> So we should lock...
> 
> But then fs/exec.c says:
> void set_task_comm(struct task_struct *tsk, char *buf)
> {
> 	task_lock(tsk);
> 
> 	/*
> 	 * Threads may access current->comm without holding
> 	 * the task lock, so write the string carefully.
> 	 * Readers without a lock may see incomplete new
> 	 * names but are safe from non-terminating string reads.
> 	 */
>      .....
> 
> So I guess we are safe to use it unlocked for informational purposes.
> That first comment could do with an update, and where-ever it was that I
> copied that code from can probably be simplified too.....

Sounds good.

I've added a quick modular build to my test scripts too, so hopefully
that sort of problem won't slip past me next time....

--b.
