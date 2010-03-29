Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903Ab0C2DRh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 23:17:37 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:57137 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697Ab0C2DRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 23:17:35 -0400
Date: Mon, 29 Mar 2010 12:16:17 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Julia Lawall <julia@diku.dk>
Cc: peterz@infradead.org, mingo@elte.hu, tglx@linutronix.de, oleg@redhat.com,
       linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 6/7] arch/sh/kernel: Use set_cpus_allowed_ptr
Message-ID: <20100329031617.GB26500@linux-sh.org>
References: <Pine.LNX.4.64.1003262303300.6480@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1003262303300.6480@ask.diku.dk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 11:03:49PM +0100, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Use set_cpus_allowed_ptr rather than set_cpus_allowed.
> 
> The semantic patch that makes this change is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression E1,E2;
> @@
> 
> - set_cpus_allowed(E1, cpumask_of_cpu(E2))
> + set_cpus_allowed_ptr(E1, cpumask_of(E2))
> 
> @@
> expression E;
> identifier I;
> @@
> 
> - set_cpus_allowed(E, I)
> + set_cpus_allowed_ptr(E, &I)
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
Applied, thanks.
