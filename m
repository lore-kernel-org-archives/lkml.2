Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085Ab1CUXix (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:38:53 -0400
Received: from kroah.org ([198.145.64.141]:49587 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755445Ab1CUXQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:16:07 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:07:16 2011
Message-Id: <20110321230716.018957964@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:07:05 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Przemyslaw Bruski <pbruskispam@op.pl>, Takashi Iwai <tiwai@suse.de>
Subject: [66/87] ALSA: ctxfi - Clear input settings before initialization
In-Reply-To: <20110321230732.GA26510@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Przemyslaw Bruski <pbruskispam@op.pl>

commit efed5f26664f93991c929d5bb343e65f900d72bc upstream.

Clear input settings before initialization.

Signed-off-by: Przemyslaw Bruski <pbruskispam@op.pl>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/ctxfi/ctdaio.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/ctxfi/ctdaio.c
+++ b/sound/pci/ctxfi/ctdaio.c
@@ -176,6 +176,7 @@ static int dao_set_left_input(struct dao
 	if (!entry)
 		return -ENOMEM;
 
+	dao->ops->clear_left_input(dao);
 	/* Program master and conjugate resources */
 	input->ops->master(input);
 	daio->rscl.ops->master(&daio->rscl);
@@ -204,6 +205,7 @@ static int dao_set_right_input(struct da
 	if (!entry)
 		return -ENOMEM;
 
+	dao->ops->clear_right_input(dao);
 	/* Program master and conjugate resources */
 	input->ops->master(input);
 	daio->rscr.ops->master(&daio->rscr);


