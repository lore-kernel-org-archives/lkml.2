Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061Ab2ACWmG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:42:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40446 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756387Ab2ACWl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:41:58 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:33:26 2012
Message-Id: <20120103223326.442281968@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:33:37 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Micha Nelissen <micha@neli.hopto.org>,
        Holger Brunck <holger.brunck@keymile.com>,
        Gerlando Falauto <gerlando.falauto@keymile.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [64/75] net: have ipconfig not wait if no dev is available
In-Reply-To: <20120103223332.GA4112@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Gerlando Falauto <gerlando.falauto@keymile.com>

[ Upstream commit cd7816d14953c8af910af5bb92f488b0b277e29d ]

previous commit 3fb72f1e6e6165c5f495e8dc11c5bbd14c73385c
makes IP-Config wait for carrier on at least one network device.

Before waiting (predefined value 120s), check that at least one device
was successfully brought up. Otherwise (e.g. buggy bootloader
which does not set the MAC address) there is no point in waiting
for carrier.

Cc: Micha Nelissen <micha@neli.hopto.org>
Cc: Holger Brunck <holger.brunck@keymile.com>
Signed-off-by: Gerlando Falauto <gerlando.falauto@keymile.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv4/ipconfig.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/ipv4/ipconfig.c
+++ b/net/ipv4/ipconfig.c
@@ -252,6 +252,10 @@ static int __init ic_open_devs(void)
 		}
 	}
 
+	/* no point in waiting if we could not bring up at least one device */
+	if (!ic_first_dev)
+		goto have_carrier;
+
 	/* wait for a carrier on at least one device */
 	start = jiffies;
 	while (jiffies - start < msecs_to_jiffies(CONF_CARRIER_TIMEOUT)) {


