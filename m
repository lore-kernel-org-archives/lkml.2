Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760636Ab2EPUxw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 16:53:52 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755330Ab2EPUwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 16:52:13 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: tglx@linutronix.de, dedekind1@gmail.com, linux-kernel@vger.kernel.org,
        Heinz.Egger@linutronix.de, tim.bird@am.sony.com
Subject: [RFC v5] UBI: Fastmap support (aka checkpointing)
Date: Wed, 16 May 2012 22:51:55 +0200
Message-Id: <1337201522-86521-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a bug-fix release. v4 handled static volumes wrong.
v6 will address everything that Artem pointed out.

v1: https://lwn.net/Articles/481612/
v2: https://lwn.net/Articles/496586/
v3: Didn't release it to linux-mtd
v4: http://article.gmane.org/gmane.linux.kernel/1297626

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
	
git://git.kernel.org/pub/scm/linux/kernel/git/rw/ubi2.git ubi2/v5

[PATCH 1/7] [RFC] UBI: Export next_sqnum()
[PATCH 2/7] [RFC] UBI: Export compare_lebs()
[PATCH 3/7] [RFC] UBI: Add fastmap on-flash layout
[PATCH 4/7] [RFC] UBI: Add fastmap structs to ubi_device
[PATCH 5/7] [RFC] UBI: Make wl subsystem fastmap aware
[PATCH 6/7] [RFC] UBI: Implement fastmapping support
[PATCH 7/7] [RFC] UBI: Wire up fastmap support

Thanks,
//richard
