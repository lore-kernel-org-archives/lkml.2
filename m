Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284Ab0DUI7m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 04:59:42 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:64685 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643Ab0DUI7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 04:59:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=HB0dNEBubhox+ZbL+5NENwKfYUKGl6Ja51QQ7cV6RGX9EDu7ntasZgZ4SIN1h7V+Yg
         /XmNaNxdKrMOpebmjFt0M0kNmMZnpysE2XU1kyD2yprpDwjCrFEHDQemVrfnKkPcwR1U
         Y+XqkbUVWGcAGBhXmKpMhbxucGuHP94lKpRRs=
MIME-Version: 1.0
Date: Wed, 21 Apr 2010 16:59:40 +0800
Message-ID: <x2uccf7f6161004210159qe7337037td6054d3e33ce350c@mail.gmail.com>
Subject: [PATCH 2.6.34-rc1] fs: fix bad string output
From: GuanJun He <heguanbo@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix bad string output,[Bug #15589] 2.6.34-rc1: Badness at fs/proc/generic.c:316

Signed-off-by: Guanjun He <heguanbo@gmail.com>

---
diff -Nupr linux-2.6.34-rc1-orig/fs/proc/generic.c
linux-2.6.34-rc1/fs/proc/generic.c
--- linux-2.6.34-rc1-orig/fs/proc/generic.c     2010-04-21
13:47:18.000000000 +0800
+++ linux-2.6.34-rc1/fs/proc/generic.c  2010-04-21 16:42:11.000000000 +0800
@@ -313,7 +313,14 @@ static int __xlate_proc_name(const char
                                break;
                }
                if (!de) {
-                       WARN(1, "name '%s'\n", name);
+                       cp = kstrdup(name);
+                       if (cp) {
+                               next = cp;
+                               while(*next) {
+                                       if (*next == '/')  *next++ = '_';
+                               }
+                               WARN(1, "name '%s'\n", cp);
+                       }
                        return -ENOENT;
                }
                cp += len + 1;
