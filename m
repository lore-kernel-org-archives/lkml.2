Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449Ab1BOJw5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 04:52:57 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63958 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419Ab1BOJwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 04:52:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qomvo7x5M2vWkKSNCYpILSZrWDNuTa7z/PSudo+KKtsfZPAXVNT8TPO/f2EJ7W3nBM
         UvvGHOVDME6ri1EwfrhtPftumuQ1HBMMi44YgMJDUBol64UkmennBqVI+eRZ2Gx4BLFJ
         tIlqaK6gxVPRhVcwY3QXydrQZMj17WyUu64Sk=
Date: Tue, 15 Feb 2011 11:52:45 +0200
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Corey Minyard <minyard@acm.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>,
        Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] char/ipmi: fix cleanup_one_si section mismatch
Message-ID: <20110215095245.GB4350@swordfish.minsk.epam.com>
References: <20110214150310.GA4350@swordfish.minsk.epam.com>
 <4D59BAED.9060501@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D59BAED.9060501@acm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


commit d2478521afc20227658a10a8c5c2bf1a2aa615b3
Author: Corey Minyard<minyard@acm.org>
Date:   Thu Feb 10 16:08:38 2011 -0600

     char/ipmi: fix OOPS caused by pnp_unregister_driver on unregistered driver


Introduced section mismatch by calling __exit cleanup_ipmi_si from __devinit 
init_ipmi_si. Remove __exit annotation from cleanup_ipmi_si.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Corey Minyard <cminyard@mvista.com>

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
 
