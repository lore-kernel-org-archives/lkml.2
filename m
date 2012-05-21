Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932740Ab2EUR4x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 13:56:53 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:46848 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932999Ab2EUR4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 13:56:43 -0400
Message-ID: <1337622999.13812.11.camel@joe2Laptop>
Subject: Re: [tip:x86/urgent] x86, printk: Add missing KERN_CONT to NMI
 selftest
From: Joe Perches <joe@perches.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mingo@kernel.org, levinsasha928@gmail.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Date: Mon, 21 May 2012 10:56:39 -0700
In-Reply-To: <4FBA7E95.5040101@zytor.com>
References: <1336492573-17530-3-git-send-email-levinsasha928@gmail.com>
	 <tip-29d679ffd850ea37a303bb930142be14982611e4@git.kernel.org>
	 <1337621394.13812.2.camel@joe2Laptop> <4FBA7E95.5040101@zytor.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-21 at 10:42 -0700, H. Peter Anvin wrote:
> On 05/21/2012 10:29 AM, Joe Perches wrote:
> > I believe this change is no longer required.
> > Kay's printk modifications have been updated.
> > It's somewhat useful, but the commit message
> > but not the commit subject is untrue.
> Still, the KERN_CONT should be there.

True.

All the other printks in the same file
without KERN_ levels should be fixed too.

It might be better to fix them all at once.

$ git grep -w -n printk arch/x86/kernel/nmi_selftest.c|grep -v KERN_|grep '[^"]\\n'
arch/x86/kernel/nmi_selftest.c:146:	printk("----------------\n");
arch/x86/kernel/nmi_selftest.c:147:	printk("| NMI testsuite:\n");
arch/x86/kernel/nmi_selftest.c:148:	printk("--------------------\n");
arch/x86/kernel/nmi_selftest.c:160:		printk("--------------------\n");
arch/x86/kernel/nmi_selftest.c:161:		printk("BUG: %3d unexpected failures (out of %3d) - debugging disabled! |\n",
arch/x86/kernel/nmi_selftest.c:163:		printk("-----------------------------------------------------------------\n");
arch/x86/kernel/nmi_selftest.c:165:		printk("--------------------\n");
arch/x86/kernel/nmi_selftest.c:166:		printk("%3d out of %3d testcases failed, as expected. |\n",
arch/x86/kernel/nmi_selftest.c:168:		printk("----------------------------------------------------\n");
arch/x86/kernel/nmi_selftest.c:170:		printk("--------------------\n");
arch/x86/kernel/nmi_selftest.c:171:		printk("All %3d testcases failed, as expected. |\n",
arch/x86/kernel/nmi_selftest.c:173:		printk("----------------------------------------\n");
arch/x86/kernel/nmi_selftest.c:175:		printk("--------------------\n");
arch/x86/kernel/nmi_selftest.c:176:		printk("Good, all %3d testcases passed! |\n",
arch/x86/kernel/nmi_selftest.c:178:		printk("---------------------------------\n");

There are a couple hundred more in arch/x86.

$ git grep -w printk arch/x86/|grep -v KERN_|wc -l
203


