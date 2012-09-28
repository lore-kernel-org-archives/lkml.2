Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964893Ab2I1S5C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 14:57:02 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45270 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964878Ab2I1S45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:56:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Ian Abbott <abbotti@mev.co.uk>
Subject: [ 065/262] staging: comedi: das08: Correct AI encoding for das08jr-16-ao
Date: Fri, 28 Sep 2012 11:49:54 -0700
Message-Id: <20120928183005.712034795@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/staging/comedi/drivers/das08.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/comedi/drivers/das08.c
+++ b/drivers/staging/comedi/drivers/das08.c
@@ -403,7 +403,7 @@ static const struct das08_board_struct d
 	 .ai = das08_ai_rinsn,
 	 .ai_nbits = 16,
 	 .ai_pg = das08_pg_none,
-	 .ai_encoding = das08_encode12,
+	 .ai_encoding = das08_encode16,
 	 .ao = das08jr_ao_winsn,
 	 .ao_nbits = 16,
 	 .di = das08jr_di_rbits,


