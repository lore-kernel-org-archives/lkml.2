Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab1AYSAr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 13:00:47 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:11951 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764Ab1AYR7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 12:59:46 -0500
From: David Daney <ddaney@caviumnetworks.com>
To: linux-usb@vger.kernel.org, gregkh@suse.de, dbrownell@users.sourceforge.net
Cc: linux-kernel@vger.kernel.org, David Daney <ddaney@caviumnetworks.com>
Subject: [PATCH 1/4] USB: EHCI: Remove dead code from ehci-sched.c
Date: Tue, 25 Jan 2011 09:59:34 -0800
Message-Id: <1295978377-22930-1-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.2.3
X-OriginalArrivalTime: 25 Jan 2011 17:59:46.0275 (UTC) FILETIME=[A6BFCB30:01CBBCB9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pre-release GCC-4.6 now correctly flags this code as dead.

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
---
 drivers/usb/host/ehci-sched.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/ehci-sched.c b/drivers/usb/host/ehci-sched.c
index aa46f57..30fbdbe 100644
--- a/drivers/usb/host/ehci-sched.c
+++ b/drivers/usb/host/ehci-sched.c
@@ -1048,8 +1048,6 @@ iso_stream_put(struct ehci_hcd *ehci, struct ehci_iso_stream *stream)
 	 * not like a QH -- no persistent state (toggle, halt)
 	 */
 	if (stream->refcount == 1) {
-		int		is_in;
-
 		// BUG_ON (!list_empty(&stream->td_list));
 
 		while (!list_empty (&stream->free_list)) {
@@ -1076,7 +1074,6 @@ iso_stream_put(struct ehci_hcd *ehci, struct ehci_iso_stream *stream)
 			}
 		}
 
-		is_in = (stream->bEndpointAddress & USB_DIR_IN) ? 0x10 : 0;
 		stream->bEndpointAddress &= 0x0f;
 		if (stream->ep)
 			stream->ep->hcpriv = NULL;
-- 
1.7.2.3

