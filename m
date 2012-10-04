Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822Ab2JDWCP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 18:02:15 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:57562 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933735Ab2JDVU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:20:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
Subject: [ 16/58] staging: comedi: s626: dont dereference insn->data
Date: Thu,  4 Oct 2012 14:19:23 -0700
Message-Id: <20121004210637.496539693@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121004210635.449598766@linuxfoundation.org>
References: <20121004210635.449598766@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

commit b655c2c4782ed3e2e71d2608154e295a3e860311 upstream.

`s626_enc_insn_config()` is incorrectly dereferencing `insn->data` which
is a pointer to user memory.  It should be dereferencing the separate
`data` parameter that points to a copy of the data in kernel memory.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/comedi/drivers/s626.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/comedi/drivers/s626.c
+++ b/drivers/staging/comedi/drivers/s626.c
@@ -2311,7 +2311,7 @@ static int s626_enc_insn_config(struct c
 	/*   (data==NULL) ? (Preloadvalue=0) : (Preloadvalue=data[0]); */
 
 	k->SetMode(dev, k, Setup, TRUE);
-	Preload(dev, k, *(insn->data));
+	Preload(dev, k, data[0]);
 	k->PulseIndex(dev, k);
 	SetLatchSource(dev, k, valueSrclatch);
 	k->SetEnable(dev, k, (uint16_t) (enab != 0));


