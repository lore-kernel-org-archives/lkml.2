Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570Ab0GFCaW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 22:30:22 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33843 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453Ab0GFCaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 22:30:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=EYi6m4Nqe2JKEkk/Fv/UTAgWkiOOBYtOCIlT3Yy29SR3Vg4b62BEF5Hi/pw33wUrCj
         qmqikvfg5isnRhtuMwWRQMFL7W/kY5TGTPsgJq+sYvc10xNQ6wNKzG9y5AeDFnRe99gY
         8cozZ909GHfSVVsoF4jL2rgUoh7SYPk9nMoo0=
Subject: [PATCH] hp-wmi: add return value checking for
	input_allocate_device()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Matthew Garrett <mjg@redhat.com>, Len Brown <len.brown@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, Anisse Astier <anisse@astier.eu>,
       platform-driver-x86@vger.kernel.org
Content-Type: text/plain
Date: Tue, 06 Jul 2010 10:30:26 +0800
Message-Id: <1278383426.12801.15.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add error checking and return -ENOMEM if input_allocate_device() fail.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/platform/x86/hp-wmi.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/hp-wmi.c b/drivers/platform/x86/hp-wmi.c
index 51c07a0..c508e20 100644
--- a/drivers/platform/x86/hp-wmi.c
+++ b/drivers/platform/x86/hp-wmi.c
@@ -402,6 +402,8 @@ static int __init hp_wmi_input_setup(void)
 	int err;
 
 	hp_wmi_input_dev = input_allocate_device();
+	if (!hp_wmi_input_dev)
+		return -ENOMEM;
 
 	hp_wmi_input_dev->name = "HP WMI hotkeys";
 	hp_wmi_input_dev->phys = "wmi/input0";
-- 
1.5.4.3



