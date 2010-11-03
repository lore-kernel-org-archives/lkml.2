Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211Ab0KCSOM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 14:14:12 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45384 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab0KCSOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 14:14:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Xj85VOBvX0WEL9oZDVUxveq08FBpdR/iED6u2BBsiCg/LC57OjPoLPq/eMxiUFezHn
         fwosr22jyKrLnw5m0gvX4BwthXtPvG9auSsRW2TqO0hkRVarvxv7u1CQJPFdD0JpKVg9
         kYeR9t/l+2AXqWnKZkwLuKedee9/uC9aF2QCE=
Date: Wed, 3 Nov 2010 11:14:01 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] eeepc-wmi: fix compiler warning
Message-ID: <20101103181400.GA12818@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the following:

  CC [M]  drivers/platform/x86/eeepc-wmi.o
drivers/platform/x86/eeepc-wmi.c:322: warning: initialization from incompatible pointer type

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/platform/x86/eeepc-wmi.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/drivers/platform/x86/eeepc-wmi.c b/drivers/platform/x86/eeepc-wmi.c
index 462ceab..0d50fbb 100644
--- a/drivers/platform/x86/eeepc-wmi.c
+++ b/drivers/platform/x86/eeepc-wmi.c
@@ -298,8 +298,8 @@ static void eeepc_wmi_notify(u32 value, void *context)
 	kfree(obj);
 }
 
-static int store_cpufv(struct device *dev, struct device_attribute *attr,
-		       const char *buf, size_t count)
+static ssize_t store_cpufv(struct device *dev, struct device_attribute *attr,
+			   const char *buf, size_t count)
 {
 	int value;
 	struct acpi_buffer input = { (acpi_size)sizeof(value), &value };
