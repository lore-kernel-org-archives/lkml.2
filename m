Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030564Ab2HGWi7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:38:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56801 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030535Ab2HGWiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:38:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Vinit Shenoy <vinit.shenoy@st.com>,
        Virupax Sadashivpetimath 
	<virupax.sadashivpetimath@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [ 052/109] spi/pl022: disable port when unused
Date: Tue,  7 Aug 2012 15:35:11 -0700
Message-Id: <20120807222047.648676630@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807222043.089735600@linuxfoundation.org>
References: <20120807222043.089735600@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Virupax Sadashivpetimath <virupax.sadashivpetimath@stericsson.com>

commit fd316941cfee1fbd12746afea83720fb7823888a upstream.

Commit ffbbdd21329f3e15eeca6df2d4bc11c04d9d91c0
"spi: create a message queueing infrastructure"
Accidentally deleted the logic to disable the port
when unused leading to higher power consumption.
Fix this up.

Cc: Vinit Shenoy <vinit.shenoy@st.com>
Signed-off-by: Virupax Sadashivpetimath <virupax.sadashivpetimath@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-pl022.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/spi/spi-pl022.c
+++ b/drivers/spi/spi-pl022.c
@@ -489,6 +489,11 @@ static void giveback(struct pl022 *pl022
 	pl022->cur_transfer = NULL;
 	pl022->cur_chip = NULL;
 	spi_finalize_current_message(pl022->master);
+
+	/* disable the SPI/SSP operation */
+	writew((readw(SSP_CR1(pl022->virtbase)) &
+		(~SSP_CR1_MASK_SSE)), SSP_CR1(pl022->virtbase));
+
 }
 
 /**


