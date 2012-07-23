Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493Ab2GWLSO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 07:18:14 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:44985 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189Ab2GWLSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 07:18:13 -0400
Date: Mon, 23 Jul 2012 14:17:57 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: wei_wang@realsil.com.cn
Cc: gregkh@linuxfoundation.org, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] drivers/misc: Add realtek card reader core driver
Message-ID: <20120723111757.GC4352@mwanda>
References: <1343036558-8189-1-git-send-email-wei_wang@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343036558-8189-1-git-send-email-wei_wang@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2012 at 05:42:38PM +0800, wei_wang@realsil.com.cn wrote:
> +
> +#define wait_timeout_x(task_state, msecs)			\
> +do {								\
> +	set_current_state((task_state));			\
> +	schedule_timeout(msecs_to_jiffies(msecs));		\
> +} while (0)
> +
> +#define wait_timeout(msecs)	wait_timeout_x(TASK_INTERRUPTIBLE, (msecs))
> +
> +#define GET_BE32(ptr)	(((u32)((ptr)[0]) << 24) | ((u32)((ptr)[1]) << 16) | \
> +				((u32)((ptr)[2]) << 8) | (ptr)[3])
> +

This will break on big endian systems.  Use be32_to_cpu().

Use Sparse to check your work:
http://lwn.net/Articles/205624/

regards,
dan carpenter
