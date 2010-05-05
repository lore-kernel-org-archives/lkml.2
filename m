Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934342Ab0EEMVX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 08:21:23 -0400
Received: from mail.gmx.net ([213.165.64.20]:12747 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933964Ab0EEMVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 08:21:21 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18mSX4c6jwmiRixRVNk2MSXbMNdtS8J8fOOVKhuN/
	V5c+kZZTvdq8sA
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: devel@driverdev.osuosl.org
Subject: Re: [PATCH -next] staging/cxt1e1: Convert bare printks to pr_<level>
Date: Wed, 5 May 2010 14:21:14 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.33.2; KDE/4.3.5; x86_64; ; )
Cc: Joe Perches <joe@perches.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       devel@driverdev.osuosl.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       gregkh@suse.de, support@sbei.com, LKML <linux-kernel@vger.kernel.org>,
       linux-next@vger.kernel.org, support@onestopsystems.com
References: <20100503151619.f75e3a80.sfr@canb.auug.org.au> <20100503110657.00b4e140.randy.dunlap@oracle.com> <1272915196.30040.163.camel@Joe-Laptop.home>
In-Reply-To: <1272915196.30040.163.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005051421.14647.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 03 Mai 2010 21:33:16 schrieb Joe Perches:
> Added #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> A few line splits for long arguments
> A couple of embedded function names converted to "%s", __func__
> Removed some uses of THIS_MODULE->name
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Hi, 
I applied Joe's patch, but unfortunately it misses out one part of Randy's 
original patch, i.e. the conversion in line 286 of hwprobe.c.

Joe: Can you perhaps add this to your patch?

Thanks, 
Peter

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
Copied from original Patch by Randy dunlap

--- linux-next-20100503.orig/drivers/staging/cxt1e1/hwprobe.c
+++ linux-next-20100503/drivers/staging/cxt1e1/hwprobe.c
@@ -282,7 +283,7 @@ c4_hdw_init (struct pci_dev * pdev, int 
          */
         char       *cp = hi->devname;
 
-        strcpy (cp, THIS_MODULE->name);
+        strcpy (cp, KBUILD_MODNAME);
         cp += strlen (cp);          /* reposition */
         *cp++ = '-';
         *cp++ = '0' + (found / 2);  /* there are two found interfaces per





