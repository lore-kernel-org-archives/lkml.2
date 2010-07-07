Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757899Ab0GGVk6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 17:40:58 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61792 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757881Ab0GGVk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 17:40:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: John Kacur <jkacur@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>,
       Samuel Ortiz <samuel@sortiz.org>, netdev@vger.kernel.org
Subject: [PATCH 14/18] irda/irnet: use noop_llseek
Date: Wed,  7 Jul 2010 23:40:16 +0200
Message-Id: <1278538820-1392-15-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1278538820-1392-1-git-send-email-arnd@arndb.de>
References: <1278538820-1392-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:UOzYqHwIAwSfztRJ3tP4DecDE8k+1mKmil6LlWsWm+E
 S2TYCMDdeUST2uW4Tc5LUNah1yJyjwrnK1ZVkFVtgjwkw+nAB/
 97stJ5BFhM6UtdBG1F2RC8OFNpjGAahlHhbFncQB1D17740qiN
 JJgDo8pyKGQbBXftFlHH42oLrMTNVxGLP8SsxonoICpooELNWs
 P5+GaJivHvKVvjc5ag6dQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There may be applications trying to seek
on the irnet character device, so we should
use noop_llseek to avoid returning an error
when the default llseek changes to no_llseek.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Samuel Ortiz <samuel@sortiz.org>
Cc: netdev@vger.kernel.org
---
 net/irda/irnet/irnet_ppp.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/irda/irnet/irnet_ppp.h b/net/irda/irnet/irnet_ppp.h
index b5df241..7b9949e 100644
--- a/net/irda/irnet/irnet_ppp.h
+++ b/net/irda/irnet/irnet_ppp.h
@@ -104,6 +104,7 @@ static const struct file_operations irnet_device_fops =
 	.unlocked_ioctl	= dev_irnet_ioctl,
 	.open		= dev_irnet_open,
 	.release	= dev_irnet_close
+	.llseek		= noop_llseek,
   /* Also : llseek, readdir, mmap, flush, fsync, fasync, lock, readv, writev */
 };
 
-- 
1.7.1

