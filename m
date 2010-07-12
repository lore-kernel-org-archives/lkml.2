Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab0GLVWp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 17:22:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52744 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753814Ab0GLVWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 17:22:43 -0400
Date: Mon, 12 Jul 2010 14:21:26 -0700
From: Greg KH <gregkh@suse.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for July 12 (debugfs/sysfs/rcu)
Message-ID: <20100712212126.GA2684@suse.de>
References: <20100712155109.d997bf1c.sfr@canb.auug.org.au> <20100712124750.8ab5e870.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100712124750.8ab5e870.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 12, 2010 at 12:47:50PM -0700, Randy Dunlap wrote:
> On Mon, 12 Jul 2010 15:51:09 +1000 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > Changes since 20100709:
> 
> Greg,
> What is there about debugfs that requires sysfs?

Look at commit 3348e05a4f25489908d9f7ed4e80ac291ead18f4 almost 5 years
ago:
    [PATCH] DEBUG_FS must depend on SYSFS
    
    CONFIG_DEBUG_FS=y and CONFIG_SYSFS=n results in the following compile
    error:
    
    <--  snip  -->
    
    ...
      LD      vmlinux
    fs/built-in.o: In function `debugfs_init':
    inode.c:(.init.text+0x31be): undefined reference to `kernel_subsys'
    make: *** [vmlinux] Error 1
    
    <--  snip  -->

But, there is no "kernel_subsys" anymore, it is called kernel_kobj, and
is in kernel/ksysfs.c and always is built now, even if CONFIG_SYSFS is
disabled.

So it should be safe to remove that dependancy if you want to.

thanks,

greg k-h
