Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965118Ab2I1VtQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:49:16 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52836 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032185Ab2I1UYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:24:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Ian Abbott <abbotti@mev.co.uk>
Subject: [ 055/218] staging: comedi: das08: Correct AO output for das08jr-16-ao
Date: Fri, 28 Sep 2012 13:14:32 -0700
Message-Id: <20120928201507.845853452@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

commit 61ed59ed09e6ad2b8395178ea5ad5f653bba08e3 upstream.

Don't zero out bits 15..12 of the data value in `das08jr_ao_winsn()` as
that knobbles the upper three-quarters of the output range for the
'das08jr-16-ao' board.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/comedi/drivers/das08.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/comedi/drivers/das08.c
+++ b/drivers/staging/comedi/drivers/das08.c
@@ -653,7 +653,7 @@ static int das08jr_ao_winsn(struct comed
 	int chan;
 
 	lsb = data[0] & 0xff;
-	msb = (data[0] >> 8) & 0xf;
+	msb = (data[0] >> 8) & 0xff;
 
 	chan = CR_CHAN(insn->chanspec);
 


