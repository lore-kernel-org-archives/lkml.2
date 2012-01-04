Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267Ab2ADAqx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 19:46:53 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:56304 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754779Ab2ADAqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 19:46:50 -0500
X-Sasl-enc: kCTLv9RBB7Qh4TVI4Uyge/6PkhAfVOeEi4ZJkMLp3BPd 1325638010
Date: Tue, 3 Jan 2012 16:44:52 -0800
From: Greg KH <greg@kroah.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Alessandro Rubini <rubini@gnudd.com>
Subject: Re: [PATCH -next] debugfs: add missing #ifdef HAS_IOMEM
Message-ID: <20120104004452.GA22949@kroah.com>
References: <1324994908-4288-1-git-send-email-heiko.carstens@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324994908-4288-1-git-send-email-heiko.carstens@de.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 27, 2011 at 03:08:28PM +0100, Heiko Carstens wrote:
> "debugfs: add tools to printk 32-bit registers" adds new functions which rely
> on IOMEM functionality which is not present on all architectures and therefore
> result in compile errors:
> 
> fs/debugfs/file.c: In function 'debugfs_print_regs32':
> fs/debugfs/file.c:561:7: error: implicit declaration of function 'readl' [-Werror=implicit-function-declaration]

Who does not have readl()?  Surely there should be a .h file we are just
missing to include?

> Add an #ifdef CONFIG_HAS_IOMEM to fix this

I guess this is ok, thanks for the patch.

greg k-h
