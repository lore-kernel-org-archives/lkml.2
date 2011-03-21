Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097Ab1CUXOC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:14:02 -0400
Received: from kroah.org ([198.145.64.141]:49071 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755070Ab1CUXN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:13:58 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:10:53 2011
Message-Id: <20110321231053.472328967@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:10:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Przemyslaw Bruski <pbruskispam@op.pl>, Takashi Iwai <tiwai@suse.de>
Subject: [27/44] ALSA: ctxfi - Clear input settings before initialization
In-Reply-To: <20110321231105.GA1744@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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


