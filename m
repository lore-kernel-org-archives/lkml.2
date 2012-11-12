Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892Ab2KLRA3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 12:00:29 -0500
Received: from vsp-authed02.binero.net ([195.74.38.226]:22904 "HELO
	vsp-authed-01-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753867Ab2KLRA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 12:00:26 -0500
From: Andreas Larsson <andreas@gaisler.com>
To: Wolfram Sang <w.sang@pengutronix.de>, Ben Dooks <ben-linux@fluff.org>,
        Peter Korsgaard <jacmet@sunsite.dk>
Cc: linux-i2c@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        software@gaisler.com
Subject: [PATCH v2 0/2] i2c: i2c-ocores: Add support for sparc, custom set and get functions, and the GRLIB port of the controller
Date: Mon, 12 Nov 2012 17:59:49 +0100
Message-Id: <1352739591-1317-1-git-send-email-andreas@gaisler.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On sparc, irqs are not present as an IORESOURCE in the struct platform_device
representation. By using platform_get_irq instead of platform_get_resource the
driver works for sparc.

The GRLIB port of the ocores i2c controller needs custom getreg and setreg
functions to allow for big endian register access and to deal with the fact that
the PRELOW and PREHIGH registers have been merged into one register.

Signed-off-by: Andreas Larsson <andreas@gaisler.com>

Changes since v1:
 - platform_get_irq now works for sparc, so that is used for all platforms
 - Acks by Peter Korsgaard <jacmet@sunsite.dk>

Andreas Larsson (2):
  i2c: i2c-ocores: Add irq support for sparc
  i2c: i2c-ocores: Add support for the GRLIB port of the controller and
    custom getreg and setreg functions

 drivers/i2c/busses/i2c-ocores.c |   66 +++++++++++++++++++++++++++++++++++---
 1 files changed, 60 insertions(+), 6 deletions(-)

