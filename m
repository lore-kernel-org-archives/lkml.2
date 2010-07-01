Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758427Ab0GASdz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 14:33:55 -0400
Received: from kroah.org ([198.145.64.141]:40720 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758082Ab0GASYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 14:24:06 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:32:16 2010
Message-Id: <20100701173216.089063380@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:32:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ben Hutchings <ben@decadent.org.uk>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 110/149] Documentation/3c509: document ethtool support
In-Reply-To: <20100701175144.GA2116@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit aa4e2e171385bb77b4da8b760d26dea2aa291587 upstream.

3c509 was changed to support ethtool in 2002, making the 'xcvr' module
parameter obsolete in most cases.  More recently 3c509 was converted
to the modern driver model and this parameter was removed.  Fix the
documentation to refer to ethtool rather than the module parameter.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 Documentation/networking/3c509.txt |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/Documentation/networking/3c509.txt
+++ b/Documentation/networking/3c509.txt
@@ -48,11 +48,11 @@ for LILO parameters for doing this:
 This configures the first found 3c509 card for IRQ 10, base I/O 0x310, and
 transceiver type 3 (10base2). The flag "0x3c509" must be set to avoid conflicts
 with other card types when overriding the I/O address. When the driver is
-loaded as a module, only the IRQ and transceiver setting may be overridden.
-For example, setting two cards to 10base2/IRQ10 and AUI/IRQ11 is done by using
-the xcvr and irq module options:
+loaded as a module, only the IRQ may be overridden. For example,
+setting two cards to IRQ10 and IRQ11 is done by using the irq module
+option:
 
-   options 3c509 xcvr=3,1 irq=10,11
+   options 3c509 irq=10,11
 
 
 (2) Full-duplex mode
@@ -77,6 +77,8 @@ operation.
 itself full-duplex capable. This is almost certainly one of two things: a full-
 duplex-capable  Ethernet switch (*not* a hub), or a full-duplex-capable NIC on
 another system that's connected directly to the 3c509B via a crossover cable.
+
+Full-duplex mode can be enabled using 'ethtool'.
  
 /////Extremely important caution concerning full-duplex mode/////
 Understand that the 3c509B's hardware's full-duplex support is much more
@@ -113,6 +115,8 @@ This insured that merely upgrading the d
 never automatically enable full-duplex mode in an existing installation;
 it must always be explicitly enabled via one of these code in order to be
 activated.
+
+The transceiver type can be changed using 'ethtool'.
   
 
 (4a) Interpretation of error messages and common problems


