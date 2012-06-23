Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756317Ab2FWWdi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 18:33:38 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:20087 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755906Ab2FWWdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 18:33:36 -0400
Date: Sun, 24 Jun 2012 01:33:19 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Emil Goode <emilgoode@gmail.com>
Cc: FlorianSchandinat@gmx.de, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] grvga: Fix error handling issues
Message-ID: <20120623223319.GG5333@mwanda>
References: <1340381479-6371-1-git-send-email-emilgoode@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340381479-6371-1-git-send-email-emilgoode@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 06:11:19PM +0200, Emil Goode wrote:
> This patch fixes two problems with the error handling in the
> grvga_probe function.
> 
> - If the call to grvga_parse_custom on line 370 fails we use
>   the wrong label so that release_mem_region will be called
>   without a call to request_mem_region being made.
> 
> - If the call to ioremap on line 436 fails we should not try
>   to call iounmap. I added an if statement to check whether or
>   not a call to iounmap should be made.
> 

Doesn't iounmap() have a check for NULL?  On x86 it does.

	if ((void __force *)addr <= high_memory)
		return;

regards,
dan carpenter


