Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933634Ab1AMUGB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 15:06:01 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59190 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933610Ab1AMUFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 15:05:43 -0500
Date: Thu, 13 Jan 2011 20:05:26 +0000
From: Russell King <rmk@arm.linux.org.uk>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: INFO: task rcu_kthread:6 blocked for more than 120 seconds.
Message-ID: <20110113200526.GA31380@flint.arm.linux.org.uk>
References: <20110112174300.GA6504@flint.arm.linux.org.uk> <20110112222219.GA17328@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110112222219.GA17328@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 12, 2011 at 02:22:19PM -0800, Paul E. McKenney wrote:
> Does the following patch help?

Yes it does, thanks.

Tested-by: Russell King <rmk+kernel@arm.linux.org.uk>

> commit 70ce43253a4465211a9c51e33d56a417c759a718
> Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Date:   Wed Jan 12 14:18:11 2011 -0800
> 
>     rcu: avoid pointless blocked-task warnings
>     
>     If the RCU callback-processing kthread has nothing to do, it parks in
>     a wait_event().  If RCU remains idle for more than two minutes, the
>     kernel complains about this.  This commit changes from wait_event()
>     to wait_event_interruptible() to prevent the kernel from complaining
>     just because RCU is idle.
>     
>     Reported-by: Russell King <rmk@arm.linux.org.uk>

Please add '+kernel' in there, thanks.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
