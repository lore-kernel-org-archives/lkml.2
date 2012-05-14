Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887Ab2ENMXQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 08:23:16 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:31375 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755802Ab2ENMXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 08:23:13 -0400
Date: Mon, 14 May 2012 15:26:28 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] Staging ipack: fix a few sparse warnings
Message-ID: <20120514122628.GH16984@mwanda>
References: <1336992089-2733-1-git-send-email-siglesias@igalia.com>
 <1336992089-2733-2-git-send-email-siglesias@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336992089-2733-2-git-send-email-siglesias@igalia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2012 at 12:41:25PM +0200, Samuel Iglesias Gonsalvez wrote:
>  	/* Read status register */
> -	status_reg = readw((unsigned short *) (tpci200->info->interface_regs +
> +	status_reg = readw((void __iomem *) (tpci200->info->interface_regs +
>  					       TPCI200_STATUS_REG));
>  

Later in the patch, you do the right thing which is to declare this
as an __iomem pointer in the header.  The cast here can be removed
and it all fits on one line.

Remove it in a follow on patch if you want.  Same for several of the
other casts in this patch.

regards,
dan carpenter


