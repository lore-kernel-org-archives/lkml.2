Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595Ab2JPK1X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 06:27:23 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:41100 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab2JPK1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 06:27:22 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] mpt: missing break
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 16 Oct 2012 11:50:59 +0100
Message-ID: <20121016105056.27754.71631.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

This happens to do the right thing in all cases on fibre channel but not on
other media types

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/message/fusion/mptscsih.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 0c3ced7..164afa7 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -792,6 +792,7 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 			 * than an unsolicited DID_ABORT.
 			 */
 			sc->result = DID_RESET << 16;
+			break;
 
 		case MPI_IOCSTATUS_SCSI_EXT_TERMINATED:		/* 0x004C */
 			if (ioc->bus_type == FC)

