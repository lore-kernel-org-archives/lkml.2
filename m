Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934205Ab0EURCx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 13:02:53 -0400
Received: from kroah.org ([198.145.64.141]:50329 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934115Ab0EUQwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 12:52:10 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 16/25] tty: n_gsm: depends on NET
Date: Fri, 21 May 2010 09:51:45 -0700
Message-Id: <1274460714-11277-16-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <20100521165113.GB11216@kroah.com>
References: <20100521165113.GB11216@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

n_gsm uses skb functions, so it should depend on NET.

n_gsm.c:(.text+0x123d49): undefined reference to `skb_dequeue'
n_gsm.c:(.text+0x123d98): undefined reference to `kfree_skb'
n_gsm.c:(.text+0x123e1e): undefined reference to `skb_pull'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 51a5700..e21175b 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -284,6 +284,7 @@ config N_HDLC
 config N_GSM
 	tristate "GSM MUX line discipline support (EXPERIMENTAL)"
 	depends on EXPERIMENTAL
+	depends on NET
 	help
 	  This line discipline provides support for the GSM MUX protocol and
 	  presents the mux as a set of 61 individual tty devices.
-- 
1.7.0.3

