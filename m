Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757120Ab1ANIJx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 03:09:53 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43082 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab1ANIJq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 03:09:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Hl2hP6V43R2i0f4na33MIserfx05IaADT5JK6NCq74oD7d/vlD+BFqAvjVLPTnIiea
         AbFAZ41ILHrpRczYyulbRp286LPw9KCbGDqOE/6aWwn8pK+jem7RSZObRDH/asAY31TQ
         J8U4iPUHjOWSw8bQ8hV+oMILXG24YqXjYYKsQ=
MIME-Version: 1.0
Date: Fri, 14 Jan 2011 10:09:43 +0200
Message-ID: <AANLkTin61iqrD0Jbax+cvQ1wxD8b=c4KJv7pBSvU7kbv@mail.gmail.com>
Subject: Kernel 2.6.37-git10 build failure: cassini.c
From: Anca Emanuel <anca.emanuel@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: netdev@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, Joe Perches <joe@perches.com>,
        Christoph Egger <siccegge@cs.fau.de>, Jiri Pirko <jpirko@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/net/cassini.c: In function ‘cas_get_vpd_info’:
drivers/net/cassini.c:3358: error: implicit declaration of function
‘of_get_property’
drivers/net/cassini.c:3358: warning: assignment makes pointer from
integer without a cast
drivers/net/cassini.c: In function ‘cas_init_one’:
drivers/net/cassini.c:5035: error: implicit declaration of function
‘pci_device_to_OF_node’
drivers/net/cassini.c:5035: warning: assignment makes pointer from
integer without a cast
make[3]: *** [drivers/net/cassini.o] Error 1
make[2]: *** [drivers/net] Error 2


The first part can be solved with:

diff --git a/drivers/net/cassini.c b/drivers/net/cassini.c
index 7206ab2..fe3795e 100644
--- a/drivers/net/cassini.c
+++ b/drivers/net/cassini.c
@@ -94,6 +94,7 @@
 #include <linux/tcp.h>
 #include <linux/mutex.h>
 #include <linux/firmware.h>
+#include <linux/of.h>

 #include <net/checksum.h>
