Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932947Ab2BAVjk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:39:40 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:44998 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757224Ab2BAVJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:09:42 -0500
X-Sasl-enc: v7XEgRHluU38lLA3TuLRNwKJCszeO5y/2LFa6juA2xHC 1328130580
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 13:00:45 2012
Message-Id: <20120201210045.833017573@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 12:59:46 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Stefan Berger <stefanb@linux.vnet.ibm.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Subject: [22/89] tpm_tis: add delay after aborting command
In-Reply-To: <20120201210505.GA26028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Berger <stefanb@linux.vnet.ibm.com>

commit a927b8131794ee449b7f6666e7ab61301949b20f upstream.

This patch adds a delay after aborting a command. Some TPMs need
this and will not process the subsequent command correctly otherwise.

It's worth noting that a TPM randomly failing to process a command,
maps to randomly failing suspend/resume operations.

Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>
Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/tpm/tpm_tis.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -432,6 +432,9 @@ static int probe_itpm(struct tpm_chip *c
 out:
 	itpm = rem_itpm;
 	tpm_tis_ready(chip);
+	/* some TPMs need a break here otherwise they will not work
+	 * correctly on the immediately subsequent command */
+	msleep(chip->vendor.timeout_b);
 	release_locality(chip, chip->vendor.locality, 0);
 
 	return rc;


