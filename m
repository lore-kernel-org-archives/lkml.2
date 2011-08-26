Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093Ab1H0O7E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 10:59:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47013 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754679Ab1H0O7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 10:59:00 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 26 14:50:53 2011
Message-Id: <20110826215053.302590478@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 26 Aug 2011 14:49:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mathias Krause <minipli@googlemail.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        PaX Team <pageexec@freemail.hu>
Subject: [04/35] i7core_edac: fixed typo in error count calculation
In-Reply-To: <20110826215139.GA11498@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mathias Krause <minipli@googlemail.com>

commit 8cf2d2399ab60842f55598bc1b00fd15503b9950 upstream.

Based on a patch from the PaX Team, found during a clang analysis pass.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: PaX Team <pageexec@freemail.hu>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/edac/i7core_edac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -1670,7 +1670,7 @@ static void i7core_mce_output_error(stru
 	char *type, *optype, *err, *msg;
 	unsigned long error = m->status & 0x1ff0000l;
 	u32 optypenum = (m->status >> 4) & 0x07;
-	u32 core_err_cnt = (m->status >> 38) && 0x7fff;
+	u32 core_err_cnt = (m->status >> 38) & 0x7fff;
 	u32 dimm = (m->misc >> 16) & 0x3;
 	u32 channel = (m->misc >> 18) & 0x3;
 	u32 syndrome = m->misc >> 32;


