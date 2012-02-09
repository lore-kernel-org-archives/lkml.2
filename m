Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932168Ab2BIUMK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 15:12:10 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:56225 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932107Ab2BIUMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 15:12:08 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19z0QNdOEVzRcpuMWf/c5p2myPS0lKKJ7uGZWg+gq
	N2m6m1+J9dCjNR
From: Peter Huewe <peterhuewe@gmx.de>
To: gregkh@linuxfoundation.org
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
Subject: staging/xgifb: Use sis headers and remove duplicated structs and defines (part II)
Date: Thu,  9 Feb 2012 21:11:42 +0100
Message-Id: <1328818309-5103-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the second big chunk of patches which gets rid of (another set of) duplicated structs and
defines in the xgifb driver that are already defined in the sis headers.
This time we tackle the initdef.h.

Since the xgifb driver used the sis driver as a template for development,
a lot of defines and structs were redefined with only slightly different names.
This patchset tries to remove some of these duplicates by including the sis headers
and replacing any xgi struct/define by its identical twin from the sis headers.

The patches should not change any behavior of the driver

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>

git diff --stat origin/staging-next
 drivers/staging/xgifb/XGI_main_26.c |   10 +-
 drivers/staging/xgifb/vb_def.h      |  178 +-------
 drivers/staging/xgifb/vb_init.c     |   18 +-
 drivers/staging/xgifb/vb_setmode.c  |  814 +++++++++++++++++-----------------
 drivers/staging/xgifb/vb_table.h    |  336 +++++++-------
 5 files changed, 602 insertions(+), 754 deletions(-)



