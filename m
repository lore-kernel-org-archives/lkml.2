Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934198Ab0HEUYM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 16:24:12 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:57858 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934200Ab0HEUX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 16:23:57 -0400
Date: Thu, 5 Aug 2010 22:23:54 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Dan Williams <dcbw@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 23/42] drivers/net/wireless/libertas: Adjust confusing if
 indentation
Message-ID: <Pine.LNX.4.64.1008052223340.31692@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

At the point of the patched code, err has already been tested, so it is
only worthwhile to test it again in the if branches where it is changed.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r disable braces4@
position p1,p2;
statement S1,S2;
@@

(
if (...) { ... }
|
if (...) S1@p1 S2@p2
)

@script:python@
p1 << r.p1;
p2 << r.p2;
@@

if (p1[0].column == p2[0].column):
  cocci.print_main("branch",p1)
  cocci.print_secs("after",p2)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/net/wireless/libertas/if_spi.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_spi.c b/drivers/net/wireless/libertas/if_spi.c
index fe3f080..3965c6c 100644
--- a/drivers/net/wireless/libertas/if_spi.c
+++ b/drivers/net/wireless/libertas/if_spi.c
@@ -800,14 +800,16 @@ static int lbs_spi_thread(void *data)
 			goto err;
 		}
 
-		if (hiStatus & IF_SPI_HIST_CMD_UPLOAD_RDY)
+		if (hiStatus & IF_SPI_HIST_CMD_UPLOAD_RDY) {
 			err = if_spi_c2h_cmd(card);
 			if (err)
 				goto err;
-		if (hiStatus & IF_SPI_HIST_RX_UPLOAD_RDY)
+		}
+		if (hiStatus & IF_SPI_HIST_RX_UPLOAD_RDY) {
 			err = if_spi_c2h_data(card);
 			if (err)
 				goto err;
+		}
 
 		/* workaround: in PS mode, the card does not set the Command
 		 * Download Ready bit, but it sets TX Download Ready. */
