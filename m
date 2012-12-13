Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756320Ab2LMS2T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 13:28:19 -0500
Received: from host-176-100-244-43.masterbit.su ([176.100.244.43]:47271 "EHLO
	tservice.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755909Ab2LMS2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 13:28:18 -0500
Date: Thu, 13 Dec 2012 22:28:17 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        GregKH <greg@kroah.com>
Subject: Re: [PATCH 1/2] drivers/w1/masters/mxc_w1.c: use devm_ functions
Message-ID: <20121213182817.GB30828@ioremap.net>
References: <1354835724-26945-2-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354835724-26945-2-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 07, 2012 at 12:15:24AM +0100, Julia Lawall (Julia.Lawall@lip6.fr) wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> The various devm_ functions allocate memory that is released when a driver
> detaches.  This patch uses these functions for data that is allocated in
> the probe function of a platform device and is only freed in the remove
> function.
> 
> At the same time, this fixes two faults.  First, mdev, the result of
> kzalloc, was never freed.  Second, on failure of ioremap, 0 was returned.
> This has been replaced by -EBUSY, which was the failure value for the call
> to request_mem_region, with which the call to ioremap has been combined.
> 
> The warning message on failure of ioremap is dropped, because
> devm_request_and_ioremap already gives such messages on failure.
> 
> Finally, the initial call to platform_get_resource is moved closer to the
> call to devm_request_and_ioremap, which takes care of checking whether its
> result is NULL, implying that a test on the result of this call to
> platform_get_resource is not needed.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Looks good. Greg, please pull both patches into your tree.
Thank you.

Acked-by: Evgeniy Polyakov <zbr@ioremap.net>

-- 
	Evgeniy Polyakov
