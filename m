Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768133Ab2KOPvL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 10:51:11 -0500
Received: from vsp-authed02.binero.net ([195.74.38.226]:22816 "HELO
	vsp-authed-02-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933286Ab2KOPvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 10:51:08 -0500
From: Andreas Larsson <andreas@gaisler.com>
To: Wolfram Sang <w.sang@pengutronix.de>, Ben Dooks <ben-linux@fluff.org>,
        Peter Korsgaard <jacmet@sunsite.dk>
Cc: linux-i2c@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        software@gaisler.com
Subject: [PATCH v6 0/2]  i2c: i2c-ocores: Add support for sparc, custom set and get functions, and the GRLIB port of the controller
Date: Thu, 15 Nov 2012 16:50:57 +0100
Message-Id: <1352994659-22392-1-git-send-email-andreas@gaisler.com>
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

Changes since v5:
- Function pointers for different widths are set together
- oc_setreg and oc_getreg are kept as wrappers

Andreas Larsson (2):
  i2c: i2c-ocores: Add irq support for sparc
  i2c: i2c-ocores: Add support for the GRLIB port of the controller and
    use function pointers for getreg and setreg functions

 .../devicetree/bindings/i2c/i2c-ocores.txt         |    2 +-
 drivers/i2c/busses/i2c-ocores.c                    |  149 +++++++++++++++++---
 2 files changed, 127 insertions(+), 24 deletions(-)

