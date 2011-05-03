Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275Ab1ECRw4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 13:52:56 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:36881 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999Ab1ECRwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 13:52:55 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 15/23] intel_sst: make sure the sst_drop_stream() get called
 when needed
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Tue, 03 May 2011 17:34:55 +0100
Message-ID: <20110503163450.24853.41907.stgit@bob.linux.org.uk>
In-Reply-To: <20110503162919.24853.58699.stgit@bob.linux.org.uk>
References: <20110503162919.24853.58699.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Feng Tang <feng.tang@intel.com>

When "aplay test.wav", if we "ctrl+z" to suspend it, the last piece of
sound will be played endlessly. So we need make sure the drop_stream
is called in such a case.

Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 .../staging/intel_sst/intel_sst_drv_interface.c    |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/drivers/staging/intel_sst/intel_sst_drv_interface.c b/drivers/staging/intel_sst/intel_sst_drv_interface.c
index 1e8c056..bb64f2a 100644
--- a/drivers/staging/intel_sst/intel_sst_drv_interface.c
+++ b/drivers/staging/intel_sst/intel_sst_drv_interface.c
@@ -283,8 +283,8 @@ void sst_process_mad_ops(struct work_struct *work)
 		retval = sst_resume_stream(mad_ops->stream_id);
 		break;
 	case SST_SND_DROP:
-/*		retval = sst_drop_stream(mad_ops->stream_id);
-*/		break;
+		retval = sst_drop_stream(mad_ops->stream_id);
+		break;
 	case SST_SND_START:
 			pr_debug("SST Debug: start stream\n");
 		retval = sst_start_stream(mad_ops->stream_id);

