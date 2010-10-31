Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389Ab0JaIPa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 04:15:30 -0400
Received: from mail-iw0-f194.google.com ([209.85.214.194]:43513 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252Ab0JaIP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 04:15:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=VukUAjJ9NbfJxJ8yU6WasJTNdTA0cPCx45iSV66r+fQQMOwHsqCGekc9J97sQWdqFK
         CeO/2EeJPizfNuB2g6SZN7I/71+XqR/ANeZNE09+dz62uzrPUUHpqWwjFJyxy9iPMXdX
         hrI4MrATZN2FJq8u3lUHkcvvPUYp2yaaGwtZU=
MIME-Version: 1.0
Date: Sun, 31 Oct 2010 16:15:26 +0800
Message-ID: <AANLkTikbEgfVZmnVfbgGxbybbghXCuUgvEm03HH=i4HD@mail.gmail.com>
Subject: PATCH : linux-2.6.35.4 drivers pcmcia cs.c
From: guillermo arias <papaguillee18@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

summary:enable cardbus cards in IBM ThinkPad 770Z

Signed-off-by:G. Arias R.<papaguillee18@gmail.com>
Date:Sun Oct 31 03:31:28 GMT-8 2010
---------------------------------------------------
--- /src/linux-2.6.35.4/drivers/pcmcia/cs.c.orig        2010-10-29
09:51:04.000000000 +0800
+++ /src/linux-2.6.35.4/drivers/pcmcia/cs.c     2010-10-01
20:54:04.000000000 +0800
@@ -396,7 +396,7 @@ static int socket_setup(struct pcmcia_so
        }

        if (status & SS_CARDBUS) {
-               if (!(skt->features & SS_CAP_CARDBUS)) {
+               if (!(skt->features || SS_CAP_CARDBUS)) {
                        dev_printk(KERN_ERR, &skt->dev,
                                "cardbus cards are not supported.\n");
                        return -EINVAL;
