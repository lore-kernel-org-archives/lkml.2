Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762103Ab2COVDn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 17:03:43 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51174 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762052Ab2COVDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 17:03:37 -0400
Date: Thu, 15 Mar 2012 14:03:33 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, devel@driverdev.osuosl.org,
        Brian Swetland <swetland@google.com>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for Mar 15 (staging/android/ram_console.c)
Message-ID: <20120315210333.GA6647@kroah.com>
References: <20120315185935.a0c475a30b2836765273a1e5@canb.auug.org.au>
 <4F62118A.2070403@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F62118A.2070403@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 08:58:02AM -0700, Randy Dunlap wrote:
> On 03/15/2012 12:59 AM, Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > News: the build system (see below) has had its toolchains for most
> > architectures updated to gcc 4.6.3.  People might like to check the build
> > results and consider if this change has caused any problems.  There are
> > also a number of architectures that are building today for the first
> > time.  Thanks to Tony Breeds for his efforts in providing toolchains.
> > 
> > Changes since 20120314:
> 
> 
> 
> on x86_64 when CONFIG_PRINTK is not enabled:
> 
> 
> drivers/staging/android/ram_console.c:99:6: error: 'dmesg_restrict' undeclared (first use in this function)

This patch should solve this, right?


diff --git a/drivers/staging/android/ram_console.c b/drivers/staging/android/ram_console.c
index 2918bc1..ce140ff 100644
--- a/drivers/staging/android/ram_console.c
+++ b/drivers/staging/android/ram_console.c
@@ -85,6 +85,10 @@ static int __init ram_console_module_init(void)
 	return platform_driver_probe(&ram_console_driver, ram_console_probe);
 }
 
+#ifndef CONFIG_PRINTK
+#define dmesg_restrict	0
+#endif
+
 static ssize_t ram_console_read_old(struct file *file, char __user *buf,
 				    size_t len, loff_t *offset)
 {
