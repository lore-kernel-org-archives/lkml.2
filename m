Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056Ab0C2KHY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 06:07:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:52675 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754795Ab0C2KHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 06:07:22 -0400
Subject: Re: [PATCH 1/7] arch/arm: Use set_cpus_allowed_ptr
From: Peter Zijlstra <peterz@infradead.org>
To: Julia Lawall <julia@diku.dk>
Cc: mingo@elte.hu, tglx@linutronix.de, oleg@redhat.com,
       Russell King <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.1003262301300.6480@ask.diku.dk>
References: <Pine.LNX.4.64.1003262301300.6480@ask.diku.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Mar 2010 12:07:19 +0200
Message-ID: <1269857239.12097.250.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-26 at 23:01 +0100, Julia Lawall wrote:
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

Thanks for doing this Julia!

