Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab2IQAum (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 20:50:42 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33397 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753060Ab2IQAtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:49:40 -0400
Message-Id: <20120917003639.371532939@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:38:00 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ian Abbott <abbotti@mev.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 095/135] staging: comedi: das08: Correct AI encoding for das08jr-16-ao
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

commit e6391a182865efc896cb2a8d79e07b7ac2f45b48 upstream.

The element of `das08_boards[]` for the 'das08jr-16-ao' board has the
`ai_encoding` member set to `das08_encode12`.  It should be set to
`das08_encode16` same as the 'das08jr/16' board.  After all, this board
has 16-bit AI resolution.

The description of the A/D LSB register at offset 0 seems incorrect in
the user manual "cio-das08jr-16-ao.pdf" as it implies that the AI
resolution is only 12 bits.  The diagrams of the A/D LSB and MSB
registers show 15 data bits and a sign bit, which matches what the
software expects for the `das08_encode16` AI encoding method.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.2: adjust indentation]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/comedi/drivers/das08.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/comedi/drivers/das08.c
+++ b/drivers/staging/comedi/drivers/das08.c
@@ -385,7 +385,7 @@ static const struct das08_board_struct d
 	 .ai = das08_ai_rinsn,
 	 .ai_nbits = 16,
 	 .ai_pg = das08_pg_none,
-	 .ai_encoding = das08_encode12,
+	 .ai_encoding = das08_encode16,
 	 .ao = das08jr_ao_winsn,
 	 .ao_nbits = 16,
 	 .di = das08jr_di_rbits,


