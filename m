Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904Ab0CXFk3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 01:40:29 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:2951 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059Ab0CXFk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 01:40:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:from:date:message-id:subject:to:cc
         :content-type;
        b=UkqMxuECaLzTDeRp6Vn3tA9zDqSeG/b+SJf4ZvegPOi5nb2fM8Na3UDgGNJf1hXvUw
         yB3trcZJ0r7vnL6gUOfjTciNWL7CWHituc+JKRjH6x0OGzsqJHmEyt9OuGUbqsaqDzrQ
         mjA8/ZN7hzgLVdSy1WdwTceRUTsCKkJxQk010=
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
From: Axel Lin <axel.lin@gmail.com>
Date: Wed, 24 Mar 2010 13:40:07 +0800
Message-ID: <427d64721003232240g34f5a1abi7f6174480599134c@mail.gmail.com>
Subject: [PATCH] asus-laptop: Return -ENOMEM in case of failed rfkill_alloc()
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Corentin Chary <corentin.chary@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return -ENOMEM instead of -EINVAL in case of failed rfkill_alloc()

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/platform/x86/asus-laptop.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/asus-laptop.c
b/drivers/platform/x86/asus-laptop.c
index db5f7db..21dbe38 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -1094,7 +1094,7 @@ static int asus_rfkill_init(struct asus_laptop *asus)
                                        RFKILL_TYPE_GPS,
                                        &asus_gps_rfkill_ops, NULL);
        if (!asus->gps_rfkill)
-               return -EINVAL;
+               return -ENOMEM;

        result = rfkill_register(asus->gps_rfkill);
        if (result) {
-- 
1.5.4.3
