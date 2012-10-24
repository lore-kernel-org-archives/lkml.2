Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758191Ab2JXKoV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 06:44:21 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:41932 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756338Ab2JXKoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 06:44:20 -0400
From: Sergei Trofimovich <slyich@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Sergei Trofimovich <slyfox@gentoo.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>,
        devel@driverdev.osuosl.org
Subject: =?UTF-8?q?=5BPATCH=5D=20staging=3A=20ipack=3A=20add=20missing=20include=20=28implicit=20declaration=20of=20function=20=27kfree=27=29?=
Date: Wed, 24 Oct 2012 13:43:47 +0300
Message-Id: <1351075427-13556-1-git-send-email-slyich@gmail.com>
X-Mailer: git-send-email 1.7.12.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sergei Trofimovich <slyfox@gentoo.org>

On ARCH=alpha make allmodconfig:

linux-2.6/drivers/staging/ipack/bridges/tpci200.c: In function 'tpci200_free_irq':
linux-2.6/drivers/staging/ipack/bridges/tpci200.c:188:2: error: implicit declaration of function 'kfree' [-Werror=implicit-function-declaration]
linux-2.6/drivers/staging/ipack/bridges/tpci200.c: In function 'tpci200_request_irq':
linux-2.6/drivers/staging/ipack/bridges/tpci200.c:215:2: error: implicit declaration of function 'kzalloc' [-Werror=implicit-function-declaration]

Fixed by adding <linux/slab.h> header

CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
CC: Jens Taprogge <jens.taprogge@taprogge.org>
CC: "Miguel Gómez" <magomez@igalia.com>
CC: devel@driverdev.osuosl.org
Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
---
 drivers/staging/ipack/bridges/tpci200.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
index bb8aa70..46d6657 100644
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -12,6 +12,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/slab.h>
 #include "tpci200.h"
 
 static u16 tpci200_status_timeout[] = {
-- 
1.7.12.4

