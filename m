Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304Ab2ADAsa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 19:48:30 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:57520 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738Ab2ADAs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 19:48:28 -0500
Date: Wed, 4 Jan 2012 00:48:23 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Greg KH <greg@kroah.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Alessandro Rubini <rubini@gnudd.com>
Subject: Re: [PATCH -next] debugfs: add missing #ifdef HAS_IOMEM
Message-ID: <20120104004823.GC23916@ZenIV.linux.org.uk>
References: <1324994908-4288-1-git-send-email-heiko.carstens@de.ibm.com>
 <20120104004452.GA22949@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120104004452.GA22949@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 03, 2012 at 04:44:52PM -0800, Greg KH wrote:
> On Tue, Dec 27, 2011 at 03:08:28PM +0100, Heiko Carstens wrote:
> > "debugfs: add tools to printk 32-bit registers" adds new functions which rely
> > on IOMEM functionality which is not present on all architectures and therefore
> > result in compile errors:
> > 
> > fs/debugfs/file.c: In function 'debugfs_print_regs32':
> > fs/debugfs/file.c:561:7: error: implicit declaration of function 'readl' [-Werror=implicit-function-declaration]
> 
> Who does not have readl()?  Surely there should be a .h file we are just
> missing to include?

s390, uml, etc.  What the hell is that kind of stuff doing in fs/*/*, anyway?
