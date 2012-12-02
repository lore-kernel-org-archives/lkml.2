Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab2LBCrR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 21:47:17 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:64715 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab2LBCrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 21:47:16 -0500
From: Cyril Roelandt <tipecaml@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, Cyril Roelandt <tipecaml@gmail.com>
Subject: [PATCH 0/6] Remove useless calls to memset().
Date: Sun,  2 Dec 2012 03:40:16 +0100
Message-Id: <1354416022-20189-1-git-send-email-tipecaml@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following six patches remove useless calls to memset(). They have been found
with this Coccinelle script:

<spml>
@@
expression E;
expression S;
@@
-memset(E, 0, S);
 memcpy(E, ..., S);
</spml>

They have only been tested by compilation.

WBR,
Cyril Roelandt.


Cyril Roelandt (6):
  bna: remove useless calls to memset().
  scsi: bfa: remove useless calls to memset().
  scsi: bnx2fc: remove useless calls to memset().
  scsi: megaraid: remove a useless call to memset().
  rtl8712: remove useless calls to memset().
  vt6656: remove a useless call to memset().

 drivers/net/ethernet/brocade/bna/bfa_ioc.c  |    4 ----
 drivers/scsi/bfa/bfa_ioc.c                  |    1 -
 drivers/scsi/bfa/bfad_bsg.c                 |    1 -
 drivers/scsi/bnx2fc/bnx2fc_hwi.c            |    4 ----
 drivers/scsi/megaraid/megaraid_sas_fusion.c |    2 --
 drivers/staging/rtl8712/mlme_linux.c        |    2 --
 drivers/staging/rtl8712/rtl871x_cmd.c       |    1 -
 drivers/staging/rtl8712/rtl871x_ioctl_set.c |    2 --
 drivers/staging/rtl8712/rtl871x_mlme.c      |    5 -----
 drivers/staging/vt6656/bssdb.c              |    1 -
 10 files changed, 23 deletions(-)

-- 
1.7.10.4

