Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969Ab0JVXJJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 19:09:09 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:44185 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070Ab0JVXJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 19:09:08 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 23 Oct 2010 01:08:57 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH update] firewire: nosy: char device is not seekable
To: Arnd Bergmann <arnd@arndb.de>
cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <201010131554.43089.arnd@arndb.de>
Message-ID: <tkrat.f853df65a5128ca0@s5r6.in-berlin.de>
References: <tkrat.42de7ec9907e63aa@s5r6.in-berlin.de>
 <201010131554.43089.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnecessary .llseek handler that came in via an automated mass conversion.
.llseek = NULL means no_llseek since commit 776c163b1b93.

The only client that uses this interface is nosy-dump in linux/tools/firewire
and it knows not to seek in this char dev.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
I left out the addition of return nonseekable_open(...) in nosy_open in
this update.  This works for nosy, but is it also formally correct?

 drivers/firewire/nosy.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/firewire/nosy.c b/drivers/firewire/nosy.c
index bf184fb..8528b10 100644
--- a/drivers/firewire/nosy.c
+++ b/drivers/firewire/nosy.c
@@ -405,7 +405,6 @@ static const struct file_operations nosy_ops = {
 	.poll =			nosy_poll,
 	.open =			nosy_open,
 	.release =		nosy_release,
-	.llseek =		noop_llseek,
 };
 
 #define PHY_PACKET_SIZE 12 /* 1 payload, 1 inverse, 1 ack = 3 quadlets */
-- 
Stefan Richter
-=====-==-=- =-=- =-===
http://arcgraph.de/sr/

