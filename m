Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758318Ab0GHBw4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 21:52:56 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:51264 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756667Ab0GHBwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 21:52:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=AsxQ2m71G/uW5whsXbyxUvMUCPJkQHmeULt4zroYHo/KzGIC2WZfDSA5m6tcq0QPFn
         h9AAGKPBj1z+AVarZ3ibIpv5vXbirVGQKb5cajZEmmvGLjHwnla97lvTQWMg81o0Ih32
         4Mz1TX2xgVuIIRtzfeqoXrDuIbXJtQEfgtQWc=
Subject: [PATCH] classmate-laptop: make needlessly global symbols static
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       Daniel Oliveira Nascimento <don@syst.com.br>,
       Matthew Garrett <mjg@redhat.com>,
       Richard Purdie <rpurdie@linux.intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       platform-driver-x86@vger.kernel.org
Content-Type: text/plain
Date: Thu, 08 Jul 2010 09:47:50 +0800
Message-Id: <1278553670.7162.4.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cmpc_accel_sensitivity_attr is needlessly defined global.
This patch makes the symbol static.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/platform/x86/classmate-laptop.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/classmate-laptop.c b/drivers/platform/x86/classmate-laptop.c
index 3bf399f..6c63303 100644
--- a/drivers/platform/x86/classmate-laptop.c
+++ b/drivers/platform/x86/classmate-laptop.c
@@ -208,7 +208,7 @@ static ssize_t cmpc_accel_sensitivity_store(struct device *dev,
 	return strnlen(buf, count);
 }
 
-struct device_attribute cmpc_accel_sensitivity_attr = {
+static struct device_attribute cmpc_accel_sensitivity_attr = {
 	.attr = { .name = "sensitivity", .mode = 0660 },
 	.show = cmpc_accel_sensitivity_show,
 	.store = cmpc_accel_sensitivity_store
-- 
1.5.4.3



