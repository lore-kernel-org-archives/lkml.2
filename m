Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868Ab0KRF1g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 00:27:36 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:41052 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138Ab0KRF1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 00:27:35 -0500
Date: Wed, 17 Nov 2010 21:25:17 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: akpm@linux-foundation.org, Mika Laitio <lamikr@pilppa.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH -mmotm] w1: fix ds2423 build, needs to select CRC16
Message-Id: <20101117212517.48069281.randy.dunlap@oracle.com>
In-Reply-To: <201011180135.oAI1Znl3017273@imap1.linux-foundation.org>
References: <201011180135.oAI1Znl3017273@imap1.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix w1_ds2423 build:  needs to select CRC16.

w1_ds2423.c:(.text+0x9971d): undefined reference to `crc16'
w1_ds2423.c:(.text+0x9973a): undefined reference to `crc16'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Mika Laitio <lamikr@pilppa.org>
---
 drivers/w1/slaves/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- mmotm-2010-1117-1703.orig/drivers/w1/slaves/Kconfig
+++ mmotm-2010-1117-1703/drivers/w1/slaves/Kconfig
@@ -18,6 +18,7 @@ config W1_SLAVE_SMEM
 
 config W1_SLAVE_DS2423
 	tristate "Counter 1-wire device (DS2423)"
+	select CRC16
 	help
 	  If you enable this you can read the counter values available
 	  in the DS2423 chipset from the w1_slave file under the
