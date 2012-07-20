Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214Ab2GTIuM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 04:50:12 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:47575 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752566Ab2GTIuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 04:50:09 -0400
Message-ID: <1342774205.2984.9.camel@dabdike.int.hansenpartnership.com>
Subject: Re: linux-next: build failure after merge of the scsi tree
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>,
        Linus <torvalds@linux-foundation.org>
Date: Fri, 20 Jul 2012 09:50:05 +0100
In-Reply-To: <20120720104118.217d9adf6d7fd5253746c73a@canb.auug.org.au>
References: <20120720104118.217d9adf6d7fd5253746c73a@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-20 at 10:41 +1000, Stephen Rothwell wrote:
> Hi James,
> 
> After merging the scsi tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> drivers/base/dd.c:27:28: fatal error: scsi/scsi_scan.h: No such file or directory
> 
> Caused by commit eea03c20ae38 ("Make wait_for_device_probe() also do
> scsi_complete_async_scans()") from Linus' tree interacting with commit
> 758da9dc2be8 ("[SCSI] cleanup usages of scsi_complete_async_scans") from
> the scsi tree.
> 
> I have reverted commit 758da9dc2be8 for today (which may not be the best
> thing to do).

That probably just about works, since 758da9dc2be8 is just removing
redundant code.

I've got this all fixed up properly in for-next now.

James


