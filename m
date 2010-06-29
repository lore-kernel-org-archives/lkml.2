Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244Ab0F2KPr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 06:15:47 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:3013 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755197Ab0F2KPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 06:15:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=TYuCbD03+GDl1eQz72koXIY1rROaQOlmDd+8KlXGCmd32geVZfadIz+wFjTSAaVWGJ
         Sbx9DD3Y7Zvj8ThyETEu7m6UeZDgWYPR80Gv1t7aMiyTPFGmfDmM8IbBOc+kIVFPc2Q5
         OzEbswR2FZaR6T/COBVQteyiUCEt5508JuJdM=
From: Kulikov Vasiliy <segooon@gmail.com>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Alexander Kurz <linux@kbdbabel.org>, Jiri Kosina <jkosina@suse.cz>,
       Javier Martinez Canillas <martinez.javier@gmail.com>,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 12/25] quatech_daqp_cs: remove casts from void*
Date: Tue, 29 Jun 2010 14:15:39 +0400
Message-Id: <1277806541-31112-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnesessary casts from void*.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/staging/comedi/drivers/quatech_daqp_cs.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/comedi/drivers/quatech_daqp_cs.c b/drivers/staging/comedi/drivers/quatech_daqp_cs.c
index a91db6c..b38b107 100644
--- a/drivers/staging/comedi/drivers/quatech_daqp_cs.c
+++ b/drivers/staging/comedi/drivers/quatech_daqp_cs.c
@@ -221,7 +221,7 @@ static void hex_dump(char *str, void *ptr, int len)
 
 static int daqp_ai_cancel(struct comedi_device *dev, struct comedi_subdevice *s)
 {
-	struct local_info_t *local = (struct local_info_t *)s->private;
+	struct local_info_t *local = s->private;
 
 	if (local->stop) {
 		return -EIO;
@@ -279,7 +279,7 @@ static enum irqreturn daqp_interrupt(int irq, void *dev_id)
 		return IRQ_NONE;
 	}
 
-	if ((struct local_info_t *)s->private != local) {
+	if (s->private != local) {
 		printk(KERN_WARNING
 		       "daqp_interrupt(): invalid comedi_subdevice.\n");
 		return IRQ_NONE;
@@ -350,7 +350,7 @@ static int daqp_ai_insn_read(struct comedi_device *dev,
 			     struct comedi_subdevice *s,
 			     struct comedi_insn *insn, unsigned int *data)
 {
-	struct local_info_t *local = (struct local_info_t *)s->private;
+	struct local_info_t *local = s->private;
 	int i;
 	int v;
 	int counter = 10000;
@@ -579,7 +579,7 @@ static int daqp_ai_cmdtest(struct comedi_device *dev,
 
 static int daqp_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 {
-	struct local_info_t *local = (struct local_info_t *)s->private;
+	struct local_info_t *local = s->private;
 	struct comedi_cmd *cmd = &s->async->cmd;
 	int counter;
 	int scanlist_start_on_every_entry;
@@ -781,7 +781,7 @@ static int daqp_ao_insn_write(struct comedi_device *dev,
 			      struct comedi_subdevice *s,
 			      struct comedi_insn *insn, unsigned int *data)
 {
-	struct local_info_t *local = (struct local_info_t *)s->private;
+	struct local_info_t *local = s->private;
 	int d;
 	unsigned int chan;
 
@@ -809,7 +809,7 @@ static int daqp_di_insn_read(struct comedi_device *dev,
 			     struct comedi_subdevice *s,
 			     struct comedi_insn *insn, unsigned int *data)
 {
-	struct local_info_t *local = (struct local_info_t *)s->private;
+	struct local_info_t *local = s->private;
 
 	if (local->stop) {
 		return -EIO;
@@ -826,7 +826,7 @@ static int daqp_do_insn_write(struct comedi_device *dev,
 			      struct comedi_subdevice *s,
 			      struct comedi_insn *insn, unsigned int *data)
 {
-	struct local_info_t *local = (struct local_info_t *)s->private;
+	struct local_info_t *local = s->private;
 
 	if (local->stop) {
 		return -EIO;
-- 
1.7.0.4

