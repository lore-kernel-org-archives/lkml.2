Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab2LRBNN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 20:13:13 -0500
Received: from order.stressinduktion.org ([87.106.68.36]:36691 "EHLO
	order.stressinduktion.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577Ab2LRBNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 20:13:11 -0500
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: linux-kernel@vger.kernel.org
Cc: npiggin@kernel.dk
Subject: [PATCH v2 0/4] brd: sanity checks and dynamic ram disk creation/destroying
Date: Tue, 18 Dec 2012 02:13:03 +0100
Message-Id: <1355793187-2638-1-git-send-email-hannes@stressinduktion.org>
X-Mailer: git-send-email 1.8.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While toying around with a library which needs small block devices for
quorum management, I came up with these patches to dynamically create
and destroy ram disks (I wanted to have non-swappable backed devices).

Change log (since RFC patch <20121014024836.GB27966@order.stressinduktion.org>):
1) module parameters(rd_nr, rd_size, max_part) are now unsigned ints
2) check for active users of ram disk before BLKFLSBUFing
3) switched from lists to idrs for device management

Change log (since patch v1 <1350757943-24981-1-git-send-email-hannes@stressinduktion.org>):
1) rebase to v3.7 (in conformance to uapi-header changes)
2) convert simple_stroul to kstrtoul
3) make rd_size static as the last user has vanished

These patches are diffed against v3.7:

 Documentation/ioctl/ioctl-number.txt |   1 +
 block/partition-generic.c            |   1 +
 drivers/block/brd.c                  | 361 +++++++++++++++++++++++++++++------
 include/linux/miscdevice.h           |   1 +
 include/uapi/linux/Kbuild            |   1 +
 include/uapi/linux/brd.h             |  12 ++
 6 files changed, 314 insertions(+), 63 deletions(-)

