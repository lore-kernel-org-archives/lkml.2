Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643Ab1CQWcc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 18:32:32 -0400
Received: from mx1.vsecurity.com ([209.67.252.12]:52289 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754834Ab1CQWca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 18:32:30 -0400
Subject: [PATCH] sound/pci/asihpi: check adapter index in hpi_ioctl
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: security@kernel.org, stable@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Mar 2011 18:32:24 -0400
Message-ID: <1300401144.1796.4.camel@dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The user-supplied index into the adapters array needs to be checked, or
an out-of-bounds kernel pointer could be accessed and used, leading to
potentially exploitable memory corruption.

Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
---
 sound/pci/asihpi/hpioctl.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/sound/pci/asihpi/hpioctl.c b/sound/pci/asihpi/hpioctl.c
index 22dbd91..448dd01 100644
--- a/sound/pci/asihpi/hpioctl.c
+++ b/sound/pci/asihpi/hpioctl.c
@@ -155,6 +155,11 @@ long asihpi_hpi_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		goto out;
 	}
 
+	if (hm->h.adapter_index >= HPI_MAX_ADAPTERS) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	pa = &adapters[hm->h.adapter_index];
 	hr->h.size = 0;
 	if (hm->h.object == HPI_OBJ_SUBSYSTEM) {


