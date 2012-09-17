Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab2IQAul (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 20:50:41 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33398 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753068Ab2IQAtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:49:40 -0400
Message-Id: <20120917003639.511155092@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:38:01 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ian Abbott <abbotti@mev.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 096/135] staging: comedi: das08: Correct AO output for das08jr-16-ao
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

commit 61ed59ed09e6ad2b8395178ea5ad5f653bba08e3 upstream.

Don't zero out bits 15..12 of the data value in `das08jr_ao_winsn()` as
that knobbles the upper three-quarters of the output range for the
'das08jr-16-ao' board.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/comedi/drivers/das08.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/das08.c b/drivers/staging/comedi/drivers/das08.c
index e5eb3b9..67a914a 100644
--- a/drivers/staging/comedi/drivers/das08.c
+++ b/drivers/staging/comedi/drivers/das08.c
@@ -378,7 +378,7 @@ das08jr_ao_winsn(struct comedi_device *dev, struct comedi_subdevice *s,
 	int chan;
 
 	lsb = data[0] & 0xff;
-	msb = (data[0] >> 8) & 0xf;
+	msb = (data[0] >> 8) & 0xff;
 
 	chan = CR_CHAN(insn->chanspec);
 


