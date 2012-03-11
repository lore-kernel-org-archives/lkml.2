Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318Ab2CKWqj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 18:46:39 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:41850 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517Ab2CKWqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 18:46:31 -0400
Date: Sun, 11 Mar 2012 15:42:19 -0700 (PDT)
Message-Id: <20120311.154219.270150852508281564.davem@davemloft.net>
To: julia.lawall@lip6.fr
Cc: chas@cmf.nrl.navy.mil, kernel-janitors@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] drivers/atm/eni.c: ensure arguments to request_irq
 and free_irq are compatible
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.DEB.2.02.1203112215250.1958@localhost6.localdomain6>
References: <201203112058.q2BKwBCS024617@cmf.nrl.navy.mil>
	<alpine.DEB.2.02.1203112215250.1958@localhost6.localdomain6>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 11 Mar 2012 15:42:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia.lawall@lip6.fr>
Date: Sun, 11 Mar 2012 22:16:25 +0100 (CET)

> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Convert calls to free_irq so that the second argument is the same as
> the
> last argument of the corresponding call to request_irq.  Without this
> property, free_irq does nothing.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Applied, but this driver also has a larger problem, it doesn't
free the IRQ (nor do any other kind of chip shutdown and cleanups)
when the driver is unloaded.  The unload function is just one empty
function with a comment.
