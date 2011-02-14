Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645Ab1BNPDb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 10:03:31 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45157 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755629Ab1BNPDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 10:03:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=xUYqryOVVhja11ClrWiesmZ9OIjmVNIdXIicm09ePowtiSKJ01qJDxXUDI4pn9um42
         22x3e5je+YZk3Gs4ZnrB6N/5X0x/4aGq5NxIMDUGQ5CAL5cJirM9AU5KmuNoE6m0xC27
         r/Hje/dJerf8HMKsfIFADdeoBIryDNRpAmgQg=
Date: Mon, 14 Feb 2011 17:03:10 +0200
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Corey Minyard <minyard@acm.org>, openipmi-developer@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>,
        Randy Dunlap <randy.dunlap@oracle.com>
Subject: char/ipmi: cleanup_one_si section mismatch
Message-ID: <20110214150310.GA4350@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

commit d2478521afc20227658a10a8c5c2bf1a2aa615b3
Author: Corey Minyard <minyard@acm.org>
Date:   Thu Feb 10 16:08:38 2011 -0600

    char/ipmi: fix OOPS caused by pnp_unregister_driver on unregistered driver


Introduced section mismatch by calling __exit cleanup_ipmi_si 
from __devinit init_ipmi_si. Should we remove __exit annotation then?


---

 drivers/char/ipmi/ipmi_si_intf.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 7855f9f..94cd2ce 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -3532,7 +3532,7 @@ static void cleanup_one_si(struct smi_info *to_clean)
 	kfree(to_clean);
 }
 
-static void __exit cleanup_ipmi_si(void)
+static void cleanup_ipmi_si(void)
 {
 	struct smi_info *e, *tmp_e;
 

