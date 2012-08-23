Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934218Ab2HWSor (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 14:44:47 -0400
Received: from noserose.net ([66.220.18.76]:42457 "HELO noserose.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S934166Ab2HWSoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 14:44:44 -0400
Message-Id: <cover.1345743800.git.ecashin@coraid.com>
From: Ed Cashin <ecashin@coraid.com>
Date: Thu, 23 Aug 2012 13:43:20 -0400
Subject: [PATCH 00/14] aoe driver v49 performance and usability improvements
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ecashin@coraid.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches go a long way to updating the in-kernel aoe driver with
the changes that have been in the coraid.com-distributed version,
bringing it from (aoe internal) version 47 to version 49.  They apply
to commit 23dcfa61bac244e1 of the mainline git tree.

These updates have been too long in coming, but there is reason to be
hopeful that once these changes are applied, there is now less of a
chance that such a large update gap will occur again for a couple
reasons.

For one, the changes between 47 and 49 were originally produced in a
form that required a large amount of work before they could be
presented to the list in a form that complies with
Documenation/Submit*.  I have done my best to disentangle the changes
and to clean them up.  Subsequent changes are more amenable to
submission to the LKML and should be easier to prepare soon.  Future
changes from Coraid are expected to be similarly amenable to LKML
submission because of changes we have made for the better in Coraid's
development practices in the past few years.

Second, the users of the aoe driver increasingly demand that the
in-kernel driver have the same high performance and advanced features
as the one distributed at coraid.com.

The plan is to follow up with more changes once this patchset is
merged, until the coraid.com-distributed driver and the in-kernel
drivers are as close as possible.  Some bugfixes from have been
backported to this patchset, though, from post-version-49 development.
The important thing, though, is to get things started with a minimal
and progressive first patchset.

Ed L. Cashin (14):
  aoe: for performance support larger packet payloads
  aoe: kernel thread handles I/O completions for simple locking
  aoe: become I/O request queue handler for increased user control
  aoe: use a kernel thread for transmissions
  aoe: use packets that work with the smallest-MTU local interface
  aoe: failover remote interface based on aoe_deadsecs parameter
  aoe: do revalidation steps in order
  aoe: disallow unsupported AoE minor addresses
  aoe: associate frames with the AoE storage target
  aoe: increase net_device reference count while using it
  aoe: remove unused code and add cosmetic improvements
  aoe: update internal version number to 49
  aoe: update copyright year in touched files
  aoe: update documentation with new URL and VM settings reference

 Documentation/aoe/aoe.txt   |    9 +-
 MAINTAINERS                 |    2 +-
 drivers/block/aoe/aoe.h     |   85 ++--
 drivers/block/aoe/aoeblk.c  |   89 +---
 drivers/block/aoe/aoechr.c  |   11 +-
 drivers/block/aoe/aoecmd.c  | 1227 ++++++++++++++++++++++++++++---------------
 drivers/block/aoe/aoedev.c  |  161 ++++--
 drivers/block/aoe/aoemain.c |   10 +-
 drivers/block/aoe/aoenet.c  |   61 ++-
 9 files changed, 1084 insertions(+), 571 deletions(-)

-- 
1.7.2.5

