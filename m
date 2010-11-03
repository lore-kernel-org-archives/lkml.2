Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699Ab0KCWL3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 18:11:29 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65154 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323Ab0KCWL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 18:11:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=V0EEFQVwFP39U4Lq0c6kTfgpM6Y6qKLzIIl9wPEqw9CbeuTqjM2XgRKVGNHhaD6nck
         OAWF9GTgKigwN1NGIPnP2bQGZpQUQob5Zv7PndaJdhKrSit/QdVyA/k1yMfTr/QtpqVl
         wNElnEp/KUWKXcWZ3HhqtuK//30CnUo9dEWQk=
Subject: Re: panic with 2.6.37-rc1
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Tom Gundersen <teg@jklm.no>
Cc: LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTi=mEzCMCC+K6oLOjW9xfws_+_hHq8DS3hpPB1zY@mail.gmail.com>
References: <AANLkTi=mEzCMCC+K6oLOjW9xfws_+_hHq8DS3hpPB1zY@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Nov 2010 23:11:21 +0100
Message-ID: <1288822281.2718.30.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 03 novembre 2010 à 23:02 +0100, Tom Gundersen a écrit :
> I get panic during boot both with 2.6.37-rc1 and with current head.
> 
> Here is the error message:
> <http://www.lix.polytechnique.fr/~tom/2.6.37-rc1-panic.jpg>. My
> .config is below.
> 
> Let me know if you want more info. If you want I can test patches or
> bisect (if no one has any better suggestions).
> 

Please test following patch, thanks

[PATCH] atl1 : fix panic on load

Its now illegal to call netif_stop_queue() before register_netdev()

Reported-by: Tom Gundersen <teg@jklm.no>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 drivers/net/atlx/atl1.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/atlx/atl1.c b/drivers/net/atlx/atl1.c
index 43579b3..5336310 100644
--- a/drivers/net/atlx/atl1.c
+++ b/drivers/net/atlx/atl1.c
@@ -3043,7 +3043,6 @@ static int __devinit atl1_probe(struct pci_dev *pdev,
 	atl1_pcie_patch(adapter);
 	/* assume we have no link for now */
 	netif_carrier_off(netdev);
-	netif_stop_queue(netdev);
 
 	setup_timer(&adapter->phy_config_timer, atl1_phy_config,
 		    (unsigned long)adapter);


