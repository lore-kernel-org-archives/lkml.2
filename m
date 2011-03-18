Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148Ab1CRAcq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 20:32:46 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:56464 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755735Ab1CRAco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 20:32:44 -0400
From: Andres Salomon <dilinger@queued.net>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: devicetree-discuss@lists.ozlabs.org, Daniel Drake <dsd@laptop.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] switch DT creation to using of_attach_node (v2)
Date: Thu, 17 Mar 2011 17:32:32 -0700
Message-Id: <1300408356-15253-1-git-send-email-dilinger@queued.net>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is attempt #2 to make OF core use of_attach_node for both promtree
and flattree building.  This reworks of_attach_node quite a bit to conform
with our expectations of how the DT should look in memory.

It's different in many ways from the original patches, so it's worth
reviewing each in their entirety.


Andres Salomon (4):
      of: rework of_attach_node, removing CONFIG_OF_DYNAMIC
      of/promtree: switch to building the DT using of_attach_node
      of/flattree: minor cleanups
      of/flattree: use of_attach_node to build tree

----
 b/drivers/of/Kconfig |    4 ----
 b/drivers/of/base.c  |   47 ++++++++++++++++++++++++++++++++---------------
 b/drivers/of/fdt.c   |    6 ++++--
 b/drivers/of/pdt.c   |   30 ++++++------------------------
 b/include/linux/of.h |    5 ++---
 drivers/of/fdt.c     |   35 ++++++++++++++---------------------
 include/linux/of.h   |    1 -
 7 files changed, 58 insertions(+), 70 deletions(-)



