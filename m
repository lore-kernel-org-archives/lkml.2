Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933318Ab2JWQ4W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 12:56:22 -0400
Received: from vsp-authed02.binero.net ([195.74.38.226]:48199 "HELO
	vsp-authed-03-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933230Ab2JWQ4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 12:56:19 -0400
From: Andreas Larsson <andreas@gaisler.com>
To: linux-i2c@vger.kernel.org, Peter Korsgaard <jacmet@sunsite.dk>
Cc: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, software@gaisler.com
Subject: [PATCH 0/2] i2c: i2c-ocores: Add support for sparc, custom set and get functions, and the GRLIB port of the controller
Date: Tue, 23 Oct 2012 17:03:55 +0200
Message-Id: <1351004637-11049-1-git-send-email-andreas@gaisler.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On sparc, irqs are not present as an IORESOURCE in the struct platform_device
representation. Therefore, for sparc the irq needs to be fetched in a different
manner.

The GRLIB port of the ocores i2c controller needs custom getreg and setreg
functions to allow for big endian register access and to deal with the fact that
the PRELOW and PREHIGH registers have been merged into one register.

Signed-off-by: Andreas Larsson <andreas@gaisler.com>

Andreas Larsson (2):
  i2c: i2c-ocores: Add irq support for sparc
  i2c: i2c-ocores: Add support for the GRLIB port of the controller and
    custom getreg and setreg functions

 drivers/i2c/busses/i2c-ocores.c |   70 +++++++++++++++++++++++++++++++++++---
 1 files changed, 64 insertions(+), 6 deletions(-)

