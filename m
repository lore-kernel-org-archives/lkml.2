Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932689Ab0EAQnq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 12:43:46 -0400
Received: from kroah.org ([198.145.64.141]:38645 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756967Ab0EAQnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 12:43:39 -0400
Date: Fri, 30 Apr 2010 14:56:45 -0700
From: Greg KH <greg@kroah.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
       "ss@aao.gov.au" <ss@aao.gov.au>
Subject: Re: [PATCH] Staging: dt3155: Cleanup memory mapped i/o access
Message-ID: <20100430215645.GA12409@kroah.com>
References: <0D753D10438DA54287A00B0270842697636DAFCD14@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0D753D10438DA54287A00B0270842697636DAFCD14@AUSP01VMBX24.collaborationhost.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 28, 2010 at 12:23:09PM -0500, H Hartley Sweeten wrote:
> The macros ReadMReg and WriteMReg are really just private versions of
> the kernel's readl and writel functions.  Use the kernel's functions
> instead.  And since ioremap returns a (void __iomem *) not a (u8 *),
> change all the uses of dt3155_lbase to reflect this.
> 
> While here, make dt3155_lbase static since it is only used in the
> dt3155_drv.c file.  Also, remove the global variable dt3155_bbase
> since it is not used anywhere in the code.
> 
> Where is makes sense, create a local 'mmio' variable instead of using
> dt3155_lbase[minor] to make the code more readable.
> 
> This change also affects the {Read|Write}I2C functions so they are
> also modified as needed.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: Scott Smedley <ss@aao.gov.au>
> 
> --- a/drivers/staging/dt3155/dt3155_drv.c

This doesn't apply at all against the latest linux-next tree.  Care to
redo it and resend it (not in base64 please.)

thanks,

greg k-h
