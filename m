Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932259Ab1BPAYF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:24:05 -0500
Received: from kroah.org ([198.145.64.141]:49568 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932224Ab1BPAX7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:23:59 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:46 2011
Message-Id: <20110216001445.951235660@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:14:25 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Michael Buesch <mb@bu3sch.de>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [208/272] ssb-pcmcia: Fix parsing of invariants tuples
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: =?UTF-8?q?Michael=20B=C3=BCsch?= <mb@bu3sch.de>

commit dd3cb633078fb12e06ce6cebbdfbf55a7562e929 upstream.

This fixes parsing of the device invariants (MAC address)
for PCMCIA SSB devices.

ssb_pcmcia_do_get_invariants expects an iv pointer as data
argument.

Tested-by: dylan cristiani <d.cristiani@idem-tech.it>
Signed-off-by: Michael Buesch <mb@bu3sch.de>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ssb/pcmcia.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/ssb/pcmcia.c
+++ b/drivers/ssb/pcmcia.c
@@ -733,7 +733,7 @@ int ssb_pcmcia_get_invariants(struct ssb
 
 	/* Fetch the vendor specific tuples. */
 	res = pcmcia_loop_tuple(bus->host_pcmcia, SSB_PCMCIA_CIS,
-				ssb_pcmcia_do_get_invariants, sprom);
+				ssb_pcmcia_do_get_invariants, iv);
 	if ((res == 0) || (res == -ENOSPC))
 		return 0;
 


