Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757636Ab2EUOCP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 10:02:15 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756169Ab2EUOCM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 10:02:12 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: tglx@linutronix.de, dedekind1@gmail.com, linux-kernel@vger.kernel.org,
        Heinz.Egger@linutronix.de, tim.bird@am.sony.com
Subject: [RFC v6] UBI: Fastmap support (aka checkpointing)
Date: Mon, 21 May 2012 16:01:55 +0200
Message-Id: <1337608916-49771-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v1: https://lwn.net/Articles/481612/
v2: https://lwn.net/Articles/496586/
v3: Didn't release it to linux-mtd
v4: http://article.gmane.org/gmane.linux.kernel/1297626
v5: http://article.gmane.org/gmane.linux.kernel/1298488

Changes since v1:
       - renamed it to UBIVIS (at least in Kconfig)
       - UBIVIS parameters are now configurable via Kconfig
       - several bugs have been fixed (design and implementation bugs)
       - added lots of comments to make the review process easier
       - made checkpatch.pl happy

Changes since v2:
       - minor bugs have been fixed
       - renamed it to UBI fastmap (as Artem requested)

Changes since v3:
       - changed the on-flash layout (added padding fields, turned the
         EBA storage into an array)
       - fixed some corner cases (the protection queue needed some extra work)
       - removed the data type hint logic
       - rebased to Artems mtd tree

Changes since v4:
       - fixed static volume handling (used_ebs and last_data_bytes contained
         bad values in some cases)

Changes since v5:
       - merged it into a single patch
       - rebased to Artems mtd tree (addressed all renames)
       - fixed issues pointed out by Artem
       - redefined fastmap parameters

The fastmap super block has to be located within the first 64 PEBs.
A fastmap can use up to 32 PEBs.
The fastmap pool (the number of to be scanned PEBs while attaching)
is now derived from the flash size.
The current formular is Np = max(min(5% of total PEBs, 256), 8)
Comments/better ideas?

For now a fastmap contains only used and free PEBs.
Shall we also take care about bad PEBs?
What about bad_peb_count corr_peb_count?

git://git.kernel.org/pub/scm/linux/kernel/git/rw/ubi2.git ubi2/v6

[PATCH] [RFC] UBI: Implement Fastmap support
