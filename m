Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212Ab1LPLzK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 06:55:10 -0500
Received: from relay2.sgi.com ([192.48.179.30]:60342 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751499Ab1LPLzB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 06:55:01 -0500
Date: Fri, 16 Dec 2011 05:55:00 -0600
From: Robin Holt <holt@sgi.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Robin Holt <holt@sgi.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] sgi-xp: nested calls to spin_lock_irqsave()
Message-ID: <20111216115500.GD2547@sgi.com>
References: <20111215064805.GA2776@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111215064805.GA2776@elgon.mountain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 09:48:05AM +0300, Dan Carpenter wrote:
> The code here has a nested spin_lock_irqsave().  It's not needed since
> IRQs are already disabled and it causes a problem because it means that
> IRQs won't be enabled again at the end.  The second call to
> spin_lock_irqsave() will overwrite the value of irq_flags and we can't
> restore the proper settings.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Acked-by: Robin Holt <holt@sgi.com>
