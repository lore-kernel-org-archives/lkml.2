Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724Ab2JTSc2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 14:32:28 -0400
Received: from order.stressinduktion.org ([87.106.68.36]:60877 "EHLO
	order.stressinduktion.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab2JTSc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 14:32:26 -0400
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] brd: sanity checks and dynamic ram disk creation/destroying
Date: Sat, 20 Oct 2012 20:32:19 +0200
Message-Id: <1350757943-24981-1-git-send-email-hannes@stressinduktion.org>
X-Mailer: git-send-email 1.7.12.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

While toying around with a library which needs small block devices for
quorum management, I came up with these patches to dynamically create
and destroy ram disks (I wanted to have non-swappable backed devices).

Feedback is appreciated!

Change log (since RFC patch <20121014024836.GB27966@order.stressinduktion.org>):
1) module parameters(rd_nr, rd_size, max_part) are now unsigned ints
2) check for active users of ram disk before BLKFLSBUFing
3) switched from lists to idrs for device management

The patches apply against v3.6.

 Documentation/ioctl/ioctl-number.txt |   1 +
 block/partition-generic.c            |   1 +
 drivers/block/brd.c                  | 360 +++++++++++++++++++++++++++++------
 include/linux/Kbuild                 |   1 +
 include/linux/brd.h                  |  12 ++
 include/linux/miscdevice.h           |   1 +
 6 files changed, 313 insertions(+), 63 deletions(-)

Greetings,

  Hannes

