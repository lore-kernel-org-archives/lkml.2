Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758787Ab1FWDaH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 23:30:07 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60023 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757061Ab1FWDaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 23:30:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=HgQuvyNNE5FB8ZpFz63/R24F2jyHIX6nBjdqzidT3Wp7V7D1q4IT7u9j1CJz+MHme5
         yYz954ouVow7IBvi8wutH0rkWiofztikXdUjKU4oCA0dq0PBjxLnzroijWRdjUk6efBD
         An0ggos1o28D/ZnGXmQCrVQ8lCxKz7O/skI44=
Message-ID: <4E02B33A.3060805@gmail.com>
Date: Wed, 22 Jun 2011 20:30:02 -0700
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc13 Thunderbird/3.1.10
MIME-Version: 1.0
To: Feng Tang <feng.tang@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>
Subject: Re: [PATCH 09/11] spi-dw: Fix condition in spi_dw_{writer/reader}
References: <1308794413-11069-1-git-send-email-dirk.brandewie@gmail.com>	<1308794413-11069-10-git-send-email-dirk.brandewie@gmail.com>	<20110623104506.3cfd55ce@feng-i7>	<4E02AE6E.5010307@gmail.com> <20110623112552.6f22c3de@feng-i7>
In-Reply-To: <20110623112552.6f22c3de@feng-i7>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch should have been:

spi-dw: Fix condition in spi_dw_{writer/reader}

From: Dirk Brandewie <dirk.brandewie@gmail.com>

Fix the condition based on whether the current transfer has a tx/rx
buffer.

Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
---
  drivers/spi/spi-dw.c |   10 +++++-----
  1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/spi/spi-dw.c b/drivers/spi/spi-dw.c
index 96ae4a7..0a848bc 100644
--- a/drivers/spi/spi-dw.c
+++ b/drivers/spi/spi-dw.c
@@ -193,15 +193,15 @@ static void spi_dw_writer(struct spi_dw *dws)
         u16 txw = 0;

         while (max--) {
-               /* Set the tx word if the transfer's original "tx" is not null */
-               if (dws->tx_end - dws->len) {
+               /* Set the tx word if the transfer's "tx" is not null */
+               if (dws->tx) {
                         if (dws->n_bytes == 1)
                                 txw = *(u8 *)(dws->tx);
                         else
                                 txw = *(u16 *)(dws->tx);
+                       dws->tx += dws->n_bytes;
                 }
                 dw_writew(dws, dr, txw);
-               dws->tx += dws->n_bytes;
         }
  }

@@ -213,13 +213,13 @@ static void spi_dw_reader(struct spi_dw *dws)
         while (max--) {
                 rxw = dw_readw(dws, dr);
                 /* Care rx only if the transfer's original "rx" is not null */
-               if (dws->rx_end - dws->len) {
+               if (dws->rx) {
                         if (dws->n_bytes == 1)
                                 *(u8 *)(dws->rx) = rxw;
                         else
                                 *(u16 *)(dws->rx) = rxw;
+                       dws->rx += dws->n_bytes;
                 }
-               dws->rx += dws->n_bytes;
         }
  }

