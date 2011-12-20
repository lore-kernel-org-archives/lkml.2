Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682Ab1LTJLb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 04:11:31 -0500
Received: from mail.de.keymile.com ([195.8.104.1]:52336 "HELO
	mail.de.keymile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751510Ab1LTJL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 04:11:28 -0500
X-Greylist: delayed 667 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Dec 2011 04:11:27 EST
From: Gerlando Falauto <gerlando.falauto@keymile.com>
Cc: Gerlando Falauto <gerlando.falauto@keymile.com>,
        Micha Nelissen <micha@neli.hopto.org>,
        Holger Brunck <holger.brunck@keymile.com>,
        "David S. Miller" <davem@davemloft.net> (maintainer:NETWORKING
	[IPv4/...),
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru> (maintainer:NETWORKING
	[IPv4/...),
        "Pekka Savola (ipv6)" <pekkas@netcore.fi> (maintainer:NETWORKING
	[IPv4/...),
        James Morris <jmorris@namei.org> (maintainer:NETWORKING [IPv4/...),
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org> (maintainer:NETWORKING
	[IPv4/...),
        Patrick McHardy <kaber@trash.net> (maintainer:NETWORKING [IPv4/...),
        netdev@vger.kernel.org (open list:NETWORKING [IPv4/...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] net: have ipconfig not wait if no dev is available
Date: Tue, 20 Dec 2011 09:58:04 +0100
Message-Id: <1324371484-24082-1-git-send-email-gerlando.falauto@keymile.com>
X-Mailer: git-send-email 1.7.1
X-ESAFE-STATUS: [srvhellgate.de.keymile.net] Mail clean
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

previous commit 3fb72f1e6e6165c5f495e8dc11c5bbd14c73385c
makes IP-Config wait for carrier on at least one network device.

Before waiting (predefined value 120s), check that at least one device
was successfully brought up. Otherwise (e.g. buggy bootloader
which does not set the MAC address) there is no point in waiting
for carrier.

Cc: Micha Nelissen <micha@neli.hopto.org>
Cc: Holger Brunck <holger.brunck@keymile.com>
Signed-off-by: Gerlando Falauto <gerlando.falauto@keymile.com>
---
 net/ipv4/ipconfig.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/ipconfig.c b/net/ipv4/ipconfig.c
index ab7e554..7fbcaba 100644
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
-- 
1.7.1

