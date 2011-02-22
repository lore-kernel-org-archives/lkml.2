Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137Ab1BVWWf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 17:22:35 -0500
Received: from kroah.org ([198.145.64.141]:32990 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755102Ab1BVWWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 17:22:31 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 22 14:18:43 2011
Message-Id: <20110222221843.020842762@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 22 Feb 2011 14:17:39 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dominik Brodowski <linux@dominikbrodowski.net>
Subject: [60/70] pcmcia: re-enable Zoomed Video support
In-Reply-To: <20110222222003.GA15831@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dominik Brodowski <linux@dominikbrodowski.net>

commit 33619f0d3ff715a2a5499520967d526ad931d70d upstream.

Allow drivers to enable Zoomed Video support. Currently, this is only
used by out-of-tree drivers (L64020 DVB driver in particular).

Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pcmcia/pcmcia_resource.c |    2 ++
 include/pcmcia/ds.h              |    1 +
 2 files changed, 3 insertions(+)

--- a/drivers/pcmcia/pcmcia_resource.c
+++ b/drivers/pcmcia/pcmcia_resource.c
@@ -518,6 +518,8 @@ int pcmcia_enable_device(struct pcmcia_d
 		flags |= CONF_ENABLE_IOCARD;
 	if (flags & CONF_ENABLE_IOCARD)
 		s->socket.flags |= SS_IOCARD;
+	if (flags & CONF_ENABLE_ZVCARD)
+		s->socket.flags |= SS_ZVCARD | SS_IOCARD;
 	if (flags & CONF_ENABLE_SPKR) {
 		s->socket.flags |= SS_SPKR_ENA;
 		status = CCSR_AUDIO_ENA;
--- a/include/pcmcia/ds.h
+++ b/include/pcmcia/ds.h
@@ -261,6 +261,7 @@ void pcmcia_disable_device(struct pcmcia
 #define CONF_ENABLE_ESR         0x0008
 #define CONF_ENABLE_IOCARD	0x0010 /* auto-enabled if IO resources or IRQ
 					* (CONF_ENABLE_IRQ) in use */
+#define CONF_ENABLE_ZVCARD	0x0020
 
 /* flags used by pcmcia_loop_config() autoconfiguration */
 #define CONF_AUTO_CHECK_VCC	0x0100 /* check for matching Vcc? */


