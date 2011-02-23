Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728Ab1BWBeA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 20:34:00 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38770 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754894Ab1BWBd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 20:33:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=TnHu119n7nb9D4GbBWs0gp+CA7fLYkBM9ejid1qIrTPzozlz9OOtv9GWoFAz0vzS6+
         0vOGcwiEQod4tYZMJyqDiFbFCScndOsxE9pZA7GBIQBFXbSZFnckC93NgsNPykAWxINY
         C9U5Rh5XEz8+UEdq/G78zjHeFvYuil+siGqMk=
MIME-Version: 1.0
In-Reply-To: <AANLkTimp0bywKCoqdc8=dZdGmRoOQZoySvjFRLsrk0np@mail.gmail.com>
References: <AANLkTimp0bywKCoqdc8=dZdGmRoOQZoySvjFRLsrk0np@mail.gmail.com>
Date: Wed, 23 Feb 2011 09:33:59 +0800
Message-ID: <AANLkTimxxTMU3=4ry-_zbY6v1xiDi+hW9y1RegTr8vLK@mail.gmail.com>
Subject: [2.6.38-rc6] build:mkpiggy fixlet...
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure build doesn't silently continue despite read failure,
addressing a warning due to the unchecked call.

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>

diff --git a/arch/x86/boot/compressed/mkpiggy.c
b/arch/x86/boot/compressed/mkpiggy.c
index 646aa78..845a1f8 100644
--- a/arch/x86/boot/compressed/mkpiggy.c
+++ b/arch/x86/boot/compressed/mkpiggy.c
@@ -62,7 +62,12 @@ int main(int argc, char *argv[])
 	if (fseek(f, -4L, SEEK_END)) {
 		perror(argv[1]);
 	}
-	fread(&olen, sizeof olen, 1, f);
+
+	if (fread(&olen, sizeof(olen), 1, f) != 1) {
+		perror(argv[1]);
+		return 1;
+	}
+		
 	ilen = ftell(f);
 	olen = getle32(&olen);
 	fclose(f);
-- 
Daniel J Blueman
