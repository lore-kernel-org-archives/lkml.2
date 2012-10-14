Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773Ab2JNOtF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:49:05 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46745 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932257Ab2JNOoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:44:15 -0400
Message-Id: <20121014143538.561856584@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:36:08 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ian Abbott <abbotti@mev.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 035/147] staging: comedi: dont dereference user memory for INSN_INTTRIG
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

commit 5d06e3df280bd230e2eadc16372e62818c63e894 upstream.

`parse_insn()` is dereferencing the user-space pointer `insn->data`
directly when handling the `INSN_INTTRIG` comedi instruction.  It
shouldn't be using `insn->data` at all; it should be using the separate
`data` pointer passed to the function.  Fix it.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/comedi/comedi_fops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index 9b9d4e8..f496f4d 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -950,7 +950,7 @@ static int parse_insn(struct comedi_device *dev, struct comedi_insn *insn,
 				ret = -EAGAIN;
 				break;
 			}
-			ret = s->async->inttrig(dev, s, insn->data[0]);
+			ret = s->async->inttrig(dev, s, data[0]);
 			if (ret >= 0)
 				ret = 1;
 			break;


