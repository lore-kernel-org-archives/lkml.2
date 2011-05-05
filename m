Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346Ab1EEXw6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 19:52:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:41793 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754264Ab1EEXw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 19:52:57 -0400
X-Authority-Analysis: v=1.1 cv=aqMe+0lCtaYvy4h0jyaoPGyq+DPF+P6rPG2xbekoY9Q= c=1 sm=0 a=3rvgeqzMqd0A:10 a=MvGstEdyO5kA:10 a=Zx2FLkwYMp0A:10 a=kj9zAlcOel0A:10 a=mpMdnlmFKti1S5SNY1DT+A==:17 a=yQdBAQUQAAAA:8 a=Tly-RBvnqlyTgAoUWCkA:9 a=CjuIK1q_8ugA:10 a=IcxpeKGZWnEA:10 a=mpMdnlmFKti1S5SNY1DT+A==:117
X-Cloudmark-Score: 0
X-Originating-IP: 65.28.92.85
Date: Thu, 05 May 2011 18:52:56 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] staging: vt6655: Fix warnings if CONFIG_PM is not defined
Message-ID: <4dc33858.EtMzWfSQT1slcY9R%Larry.Finger@lwfinger.net>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If staging:vt6655 is built without CONFIG_DM being defined, there are large
numbers of warnings of the following form due to use of #if instead of #ifdef:

In file included from drivers/staging/vt6655/upc.h:32,
                 from drivers/staging/vt6655/mac.h:39,
                 from drivers/staging/vt6655/wroute.c:34:
drivers/staging/vt6655/device.h:399:5: warning: "CONFIG_PM" is not defined

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---


Index: wireless-testing/drivers/staging/vt6655/device.h
===================================================================
--- wireless-testing.orig/drivers/staging/vt6655/device.h
+++ wireless-testing/drivers/staging/vt6655/device.h
@@ -396,7 +396,7 @@ typedef struct __device_info {
 
     struct pci_dev*             pcid;
 
-#if CONFIG_PM
+#ifdef CONFIG_PM
     u32                         pci_state[16];
 #endif
 
