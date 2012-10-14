Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab2JNOzl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:55:41 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46576 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754693Ab2JNOnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:43:33 -0400
Message-Id: <20121014143542.508980657@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:36:37 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 064/147] staging: comedi: s626: dont dereference insn->data
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

commit b655c2c4782ed3e2e71d2608154e295a3e860311 upstream.

`s626_enc_insn_config()` is incorrectly dereferencing `insn->data` which
is a pointer to user memory.  It should be dereferencing the separate
`data` parameter that points to a copy of the data in kernel memory.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/comedi/drivers/s626.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index e1d10f3..430e26b 100644
--- a/drivers/staging/comedi/drivers/s626.c
+++ b/drivers/staging/comedi/drivers/s626.c
@@ -1825,7 +1825,7 @@ static int s626_enc_insn_config(struct comedi_device *dev,
 	/*   (data==NULL) ? (Preloadvalue=0) : (Preloadvalue=data[0]); */
 
 	k->SetMode(dev, k, Setup, TRUE);
-	Preload(dev, k, *(insn->data));
+	Preload(dev, k, data[0]);
 	k->PulseIndex(dev, k);
 	SetLatchSource(dev, k, valueSrclatch);
 	k->SetEnable(dev, k, (uint16_t) (enab != 0));


