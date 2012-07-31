Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856Ab2GaITg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 04:19:36 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61309 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755809Ab2GaITd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 04:19:33 -0400
Date: Tue, 31 Jul 2012 11:19:22 +0300
From: Shmulik Ladkani <shmulik.ladkani@gmail.com>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>,
        Richard Genoud <richard.genoud@gmail.com>
Subject: Re: [PATCH 0/5] ubi: Fix bad PEBs reserve caclulation
Message-ID: <20120731111922.2cfbcc7a@pixies.home.jungo.com>
In-Reply-To: <1343656610.1513.14.camel@kyv>
References: <1341389164-24409-1-git-send-email-shmulik.ladkani@gmail.com>
	<1343656610.1513.14.camel@kyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Artem,

On Mon, 30 Jul 2012 16:56:50 +0300 Artem Bityutskiy <dedekind1@gmail.com> wrote:
> Hi Shmulik, I've separated out the defconfig changes and pushed patches
> 1,2, and 3 to the UBI tree (the master branch). Patches 4 and 5 are
> already merged upstream. I did a couple of minor modifications in
> commentaries and messages and I think in variables declaration section,
> nothing else. I'll send you the patches separately.

Thanks!

I've noticed a diff in the Kconfig describing MTD_UBI_BEB_LIMIT.

In my original [PATCH 2/5] "ubi: Limit amount of reserved eraseblocks
for bad PEB handling" I've amended the MTD_UBI_BEB_LIMIT explanation a
bit.

The diff between what's on linux-ubi and my suggested description is:

-	  This option specifies the maximum bad physical eraseblocks UBI
-	  expects on the UBI device (percents of total number of physical
-	  eraseblocks on this MTD partition). If the underlying flash does not
-	  admit of bad eraseblocks (e.g. NOR flash), this value is ignored.
+	  If the MTD device admits of bad eraseblocks (e.g. NAND flash), UBI
+	  reserves some amount of physical eraseblocks to handle new bad
+	  eraseblocks.
+	  This option specifies the maximum bad eraseblocks UBI expects on the
+	  ubi device (percents of total number of flash eraseblocks).
+	  This limit is used in order to derive amount of eraseblock UBI
+	  reserves for handling new bad blocks.
+	  If the device has more bad eraseblocks than this limit, UBI does not
+	  reserve any physical eraseblocks for new bad eraseblocks, but
+	  attempts to use available eraseblocks (if any).
+	  If the underlying flash does not admit of bad eraseblocks (e.g. NOR
+	  flash), this value is ignored.

Just wanted to make sure you deliberately discarded these amendments.

Regards,
Shmulik
