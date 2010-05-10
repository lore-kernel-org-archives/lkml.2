Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506Ab0EJJF7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 05:05:59 -0400
Received: from mga14.intel.com ([143.182.124.37]:63118 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964Ab0EJJF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 05:05:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,361,1270450800"; 
   d="scan'208";a="275203685"
Date: Mon, 10 May 2010 17:17:07 +0800
From: Feng Tang <feng.tang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Joe Perches <joe@perches.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alessandro Zummo <a.zummo@towertech.it>,
       Jacob Pan <jacob.jun.pan@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>,
       "Du, Alek" <alek.du@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/8] x86/mrst: add vrtc driver which serves as a wall
 clock device
Message-ID: <20100510171707.28da6795@feng-i7>
In-Reply-To: <4BE47059.8090101@zytor.com>
References: <1273254108-3234-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<1273254108-3234-8-git-send-email-jacob.jun.pan@linux.intel.com>
	<1273258266.1540.63.camel@Joe-Laptop.home>
	<20100507200208.09b2941d@lxorguk.ukuu.org.uk>
	<1273259187.1540.75.camel@Joe-Laptop.home>
	<4BE47059.8090101@zytor.com>
Organization: intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 May 2010 03:56:09 +0800
"H. Peter Anvin" <hpa@zytor.com> wrote:


> > 
> 
> Probably the right thing to do is to (a) move all this printing to
> common code; (b) change to ISO 8601 format.
> 
> 	-hpa
> 

Thank you all for the comments. please review this follow-on patch.

- Feng
--
diff --git a/arch/x86/kernel/vrtc.c b/arch/x86/kernel/vrtc.c
index fa1eb63..0fbd74d 100644
--- a/arch/x86/kernel/vrtc.c
+++ b/arch/x86/kernel/vrtc.c
@@ -74,8 +74,8 @@ unsigned long vrtc_get_time(void)
 	/* vRTC YEAR reg contains the offset to 1960 */
 	year += 1960;
 
-	printk(KERN_INFO "vRTC: sec: %d min: %d hour: %d day: %d "
-		"mon: %d year: %d\n", sec, min, hour, mday, mon, year);
+	pr_debug("vrtc time: %4d-%02d-%02d %02d:%02d:%02d\n",
+		year, mon, mday, hour, min, sec);
 
 	return mktime(year, mon, mday, hour, min, sec);
 }
