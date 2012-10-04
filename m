Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720Ab2JDWCM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 18:02:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44933 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933695Ab2JDVVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:21:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Ian Abbott <abbotti@mev.co.uk>
Subject: [ 18/58] staging: comedi: dont dereference user memory for INSN_INTTRIG
Date: Thu,  4 Oct 2012 14:19:25 -0700
Message-Id: <20121004210637.735523742@linuxfoundation.org>
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

commit 5d06e3df280bd230e2eadc16372e62818c63e894 upstream.

`parse_insn()` is dereferencing the user-space pointer `insn->data`
directly when handling the `INSN_INTTRIG` comedi instruction.  It
shouldn't be using `insn->data` at all; it should be using the separate
`data` pointer passed to the function.  Fix it.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/comedi/comedi_fops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -1132,7 +1132,7 @@ static int parse_insn(struct comedi_devi
 				ret = -EAGAIN;
 				break;
 			}
-			ret = s->async->inttrig(dev, s, insn->data[0]);
+			ret = s->async->inttrig(dev, s, data[0]);
 			if (ret >= 0)
 				ret = 1;
 			break;


