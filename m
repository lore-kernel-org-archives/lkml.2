Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933879Ab1KJF1h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 00:27:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41696 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933853Ab1KJDVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:21:16 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:01 2011
Message-Id: <20111109212701.309251991@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:25:32 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Mike Sterling <mike.sterling@microsoft.com>,
        "K.Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [010/262] Staging: hv: Add support for >2 TB LUN in storage driver.
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Sterling <mike.sterling@microsoft.com>

commit cf55f4a8b6243b42fb91c56d1421db0d36d60f96 upstream.

If a LUN larger than 2 TB is attached to a Linux VM on Hyper-V, we currently
report a maximum size of 2 TB. This patch resolves the issue in hv_storvsc.
Thanks to Robert Scheck <robert.scheck@etes.de> for reporting the issue.

Reported-by: Robert Scheck <robert.scheck@etes.de>
Signed-off-by: Mike Sterling <mike.sterling@microsoft.com>
Signed-off-by: K.Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/hv/hyperv_storage.h |    1 +
 drivers/staging/hv/storvsc_drv.c    |    2 ++
 2 files changed, 3 insertions(+)

--- a/drivers/staging/hv/hyperv_storage.h
+++ b/drivers/staging/hv/hyperv_storage.h
@@ -218,6 +218,7 @@ struct vstor_packet {
 #define STORVSC_MAX_LUNS_PER_TARGET			64
 #define STORVSC_MAX_TARGETS				1
 #define STORVSC_MAX_CHANNELS				1
+#define STORVSC_MAX_CMD_LEN				16
 
 struct hv_storvsc_request;
 
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -729,6 +729,8 @@ static int storvsc_probe(struct hv_devic
 	host->max_id = STORVSC_MAX_TARGETS;
 	/* max # of channels */
 	host->max_channel = STORVSC_MAX_CHANNELS - 1;
+	/* max cmd length */
+	host->max_cmd_len = STORVSC_MAX_CMD_LEN;
 
 	/* Register the HBA and start the scsi bus scan */
 	ret = scsi_add_host(host, &device->device);


