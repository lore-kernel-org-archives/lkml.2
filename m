Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723Ab0LaO5u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 09:57:50 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:37189 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528Ab0LaO5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 09:57:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=atw8Muq91MFcG/tyv/1d/L48TytwHnDv2b5+707U90CntGa/d7dJ1USEylDfX67Ku8
         HPBnVa3GUeFnT/r0TfccLoh1ivtH8pkVx3no6Xl3AGC+GkuB7CHsSVjNI8rUcPOTvPU5
         KbWsiV8QH3T886hmKoQB0HjNoNSASxJ5FlGo8=
Message-ID: <4D1DEF6A.5090502@gmail.com>
Date: Fri, 31 Dec 2010 15:57:46 +0100
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] macintosh: wrong test in fan_{read,write}_reg()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix error test in fan_{read,write}_reg()

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/macintosh/therm_pm72.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

ENODEV and EIO are positive (22 and 8), so the tests did not work.

diff --git a/drivers/macintosh/therm_pm72.c b/drivers/macintosh/therm_pm72.c
index 4454927..6256a08 100644
--- a/drivers/macintosh/therm_pm72.c
+++ b/drivers/macintosh/therm_pm72.c
@@ -443,7 +443,7 @@ static int fan_read_reg(int reg, unsigned char *buf, int nb)
 	tries = 0;
 	for (;;) {
 		nr = i2c_master_recv(fcu, buf, nb);
-		if (nr > 0 || (nr < 0 && nr != ENODEV) || tries >= 100)
+		if (nr > 0 || (nr < 0 && nr != -ENODEV) || tries >= 100)
 			break;
 		msleep(10);
 		++tries;
@@ -464,7 +464,7 @@ static int fan_write_reg(int reg, const unsigned char *ptr, int nb)
 	tries = 0;
 	for (;;) {
 		nw = i2c_master_send(fcu, buf, nb);
-		if (nw > 0 || (nw < 0 && nw != EIO) || tries >= 100)
+		if (nw > 0 || (nw < 0 && nw != -EIO) || tries >= 100)
 			break;
 		msleep(10);
 		++tries;
