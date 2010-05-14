Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763Ab0ENQZO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 12:25:14 -0400
Received: from atlas.linux2go.dk ([88.198.22.52]:35377 "EHLO atlas.linux2go.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751872Ab0ENQZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 12:25:09 -0400
Message-Id: <cover.1273825543.git.soren@linux2go.dk>
From: Soren Hansen <soren@linux2go.dk>
To: linux-kernel@vger.kernel.org
Date: Fri, 14 May 2010 18:11:16 +0200
Subject: [PATCH 0/2] A couple of workarounds for Xen based VPS services
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several Xen based VPS providers (Rackspace Cloud Servers, Slicehost,
and Amazon EC2 just to name a few) are faced with (at least :) ) two
problems with the current Xen support in the kernel.

Mostly, these problems stem from the fact that there are many different
guest distro's with very different levels of flexibility in terms of
being able to find its root device and in terms of being able to use an
hvc based console.

1. Most, if not all (because that's how the infrastructure has presented
   things so far) expect to find their root device on (a partition on)
   /dev/sda. However, without a patch to the current kernel, Xen block
   devices will turn up as /dev/xvda.

2. Very few of the guest systems know to use hvc0 as its console if its
   available. Instead of requiring all the guests to be changed, it's
   simpler to just make any attempt to talk to /dev/tty1 actually talk
   to hvc0.

These two patches add two new configuratin options that lets you work
around these problems. Enjoy.

Soren Hansen (2):
  Allow hvc tty's to pose as vt's
  Make the Xen block device prefix configurable

 drivers/block/Kconfig        |   10 ++++++++++
 drivers/block/xen-blkfront.c |    2 +-
 drivers/char/Kconfig         |    9 ++++++++-
 drivers/char/hvc_console.c   |    9 +++++++++
 4 files changed, 28 insertions(+), 2 deletions(-)

