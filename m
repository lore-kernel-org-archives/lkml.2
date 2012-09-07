Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751222Ab2IGPaz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 11:30:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52113 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab2IGPax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 11:30:53 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: target-devel@vger.kernel.org, nab@linux-iscsi.org, hch@lst.de,
        roland@kernel.org
Subject: [PATCH 00/11] lots of fixes for zero allocation length
Date: Fri,  7 Sep 2012 17:30:31 +0200
Message-Id: <1347031842-2531-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.7.11.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are the fixes for zero-length commands, that ultimately let
all command go through normal processing, even if they have
zero length.

The first patch is for PSCSI, the others are for IBLOCK and friends.
I tried to order them so that the safest come first.  So for 3.6 you
could choose to stop at patch 1, 2, 3 or 6, or not apply anything
at all.

Testcases included in each patch, when relevant.

Paolo

Paolo Bonzini (11):
  target: go through normal processing for zero-length PSCSI commands
  target: report too-small parameter lists everywhere
  target: fail REPORT LUNS with less than 16 bytes of payload
  target: support zero-size allocation lengths in transport_kmap_data_sg
  target: support zero allocation length in REQUEST SENSE
  target: go through normal processing for zero-length REQUEST_SENSE
  target: support zero allocation length in INQUIRY
  target: fix truncation of mode data, support zero allocation length
  target: support zero allocation length in SBC commands
  target: do not submit a zero-bio I/O request
  target: go through normal processing for all zero-length commands

 drivers/target/target_core_alua.c      |    7 +++
 drivers/target/target_core_device.c    |    7 +++
 drivers/target/target_core_iblock.c    |   17 ++++++-
 drivers/target/target_core_pr.c        |    8 +++
 drivers/target/target_core_pscsi.c     |    8 ++--
 drivers/target/target_core_sbc.c       |   23 ++++++---
 drivers/target/target_core_spc.c       |   81 +++++++++++--------------------
 drivers/target/target_core_transport.c |   35 ++++----------
 include/target/target_core_base.h      |    1 +
 9 files changed, 95 insertions(+), 92 deletions(-)

