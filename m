Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932330Ab1LOGZ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 01:25:56 -0500
Received: from ozlabs.org ([203.10.76.45]:51795 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755869Ab1LOGZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 01:25:53 -0500
From: David Gibson <david@gibson.dropbear.id.au>
To: alex.williamson@redhat.com
Cc: aik@ozlabs.ru, benh@kernel.crashing.org, joerg.roedel@amd.com,
        dwmw2@infradead.org, chrisw@redhat.com, agraf@suse.de,
        scottwood@freescale.com, B08248@freescale.com, rusty@rustcorp.com.au,
        iommu@lists.linux-foundation.org, qemu-devel@nongnu.org,
        linux-kernel@vger.kernel.org
Subject: [RFC] Device isolation infrastructure v2
Date: Thu, 15 Dec 2011 17:25:37 +1100
Message-Id: <1323930340-24055-1-git-send-email-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the second spin of my preferred approach to handling grouping
of devices for safe assignment to guests.

Changes since v1:
 * Many name changes and file moves for improved consistency
 * Bugfixes and cleanups
 * The interface to the next layer up is considerably fleshed out,
   although it still needs work.
 * Example initialization of groups for p5ioc2 and p7ioc.

TODO:
 * Need sample initialization of groups for intel and/or amd iommus
 * Use of sysfs attributes to control group permission is probably a
   mistake.  Although it seems a bit odd, registering a chardev for
   each group is probably better, because perms can be set from udev
   rules, just like everything else.
 * Need more details of what the binder structure will need to
   contain.
 * Handle complete removal of groups.
 * Clarify what will need to happen on the hot unplug path.

