Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab1HPSCh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 14:02:37 -0400
Received: from smtp-out.google.com ([216.239.44.51]:13349 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765Ab1HPSCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 14:02:35 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:user-agent:
	mime-version:content-type:content-transfer-encoding;
	b=gOG9BLFBtS61HsG0yVjCFpAi8xHsbHr1mgzHBfDay7nHG5X9yrwuHpx0sD7yuavXi
	LYUub5Ax74AuKn7zVrIGA==
Subject: [PATCH] serial: 8250_pnp: add Intermec CV60 touchscreen device
To: Greg Kroah-Hartman <gregkh@suse.de>
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jeff Chua <jeff.chua.linux@gmail.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Alan Cox <alan@linux.intel.com>
Date: Tue, 16 Aug 2011 12:02:28 -0600
Message-ID: <20110816180228.13152.61387.stgit@bhelgaas.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It would have been nice if Intermec had supplied a PNP0501 _CID for the
COM3 device, but they didn't, so we have to recognize it explicitly.

Reference: https://bugzilla.kernel.org/show_bug.cgi?id=40612
CC: Jeff Chua <jeff.chua.linux@gmail.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/tty/serial/8250_pnp.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/serial/8250_pnp.c b/drivers/tty/serial/8250_pnp.c
index fc301f6..a2f2365 100644
--- a/drivers/tty/serial/8250_pnp.c
+++ b/drivers/tty/serial/8250_pnp.c
@@ -109,6 +109,9 @@ static const struct pnp_device_id pnp_dev_table[] = {
 	/* IBM */
 	/* IBM Thinkpad 701 Internal Modem Voice */
 	{	"IBM0033",		0	},
+	/* Intermec */
+	/* Intermec CV60 touchscreen port */
+	{	"PNP4972",		0	},
 	/* Intertex */
 	/* Intertex 28k8 33k6 Voice EXT PnP */
 	{	"IXDC801",		0	},

