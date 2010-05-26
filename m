Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835Ab0EZQcm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 12:32:42 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:34880 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752528Ab0EZQcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 12:32:41 -0400
Date: Wed, 26 May 2010 17:32:27 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Julia Lawall <julia@diku.dk>, "Kevin D. Kissell" <kevink@paralogos.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/17] arch/mips/kernel: Add missing read_unlock
Message-ID: <20100526163227.GA17043@linux-mips.org>
References: <Pine.LNX.4.64.1005261754390.23743@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1005261754390.23743@ask.diku.dk>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 05:54:55PM +0200, Julia Lawall wrote:

> From: Julia Lawall <julia@diku.dk>
> 
> Add a read_unlock missing on the error path.  Other ways of reaching
> out_unlock have tasklist_lock unlocked.
> 
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression E1;
> @@
> 
> * read_lock(E1,...);
>   <+... when != E1
>   if (...) {
>     ... when != E1
> *   return ...;
>   }
>   ...+>
> * read_unlock(E1,...);
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
> I wasn't able to find what security_task_setscheduler actually does.  
> If it releases tasklist_lock in an error case, then ignire this patch.

Your patch appears correct - and mipsmt_sys_sched_setaffinity() even
more broken than you thought.  It duplicates some code from kernel/sched.c
and has gotten out of sync.

Fixing that up.

   Ralf
