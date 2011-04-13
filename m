Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130Ab1DMNh1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 09:37:27 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:42998 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620Ab1DMNhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 09:37:23 -0400
From: Borislav Petkov <bp@amd64.org>
To: <linux-kernel@vger.kernel.org>
Cc: Borislav Petkov <borislav.petkov@amd.com>, Russ Anderson <rja@sgi.com>,
        Prarit Bhargava <prarit@redhat.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "mstowe@redhat.com" <mstowe@redhat.com>,
        "dnelson@redhat.com" <dnelson@redhat.com>,
        "rja@americas.sgi.com" <rja@americas.sgi.com>
Subject: [PATCH 3/3] EDAC, MCE, AMD: Register with MCE core
Date: Wed, 13 Apr 2011 15:36:50 +0200
Message-Id: <1302701810-2471-3-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <20110413132409.GB1900@gere.osrc.amd.com>
References: <20110413132409.GB1900@gere.osrc.amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Now that we don't have a default notifier, register with the MCE core to
state that MCE decoder functionality is present.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/mce_amd.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/edac/mce_amd.c b/drivers/edac/mce_amd.c
index 795cfbc..4448010 100644
--- a/drivers/edac/mce_amd.c
+++ b/drivers/edac/mce_amd.c
@@ -902,6 +902,8 @@ static int __init mce_amd_init(void)
 
 	atomic_notifier_chain_register(&x86_mce_decoder_chain, &amd_mce_dec_nb);
 
+	atomic_inc(&mce_decoders);
+
 	return 0;
 }
 early_initcall(mce_amd_init);
@@ -909,6 +911,7 @@ early_initcall(mce_amd_init);
 #ifdef MODULE
 static void __exit mce_amd_exit(void)
 {
+	atomic_dec(&mce_decoders);
 	atomic_notifier_chain_unregister(&x86_mce_decoder_chain, &amd_mce_dec_nb);
 	kfree(fam_ops);
 }
-- 
1.7.4.rc2

