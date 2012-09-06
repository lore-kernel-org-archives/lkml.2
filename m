Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388Ab2IFPNs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 11:13:48 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55844 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756626Ab2IFPNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 11:13:46 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: target-devel@vger.kernel.org, nab@linux-iscsi.org
Subject: [PATCH 3.6 0/2] More PSCSI fixes
Date: Thu,  6 Sep 2012 17:13:28 +0200
Message-Id: <1346944410-19850-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.7.11.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

here are two more fixes for SCSI passthrough.  The first removes an
(IMO) ill-conceived functionality and fixes passthrough of protection
information.  The second started as a fix for START STOP UNIT, and ended
up as a more general change in transport_kmap_data_sg.

Please review!

Paolo

Paolo Bonzini (2):
  target: remove pscsi_clear_cdb_lun
  target: use a bounce buffer in transport_kmap_data_sg for 0 or 1-page sglist

 drivers/target/target_core_pscsi.c     |   26 -------------
 drivers/target/target_core_transport.c |   62 ++++++++++++++-----------------
 2 files changed, 28 insertions(+), 60 deletions(-)

