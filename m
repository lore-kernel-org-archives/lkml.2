Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768660Ab2KOSLL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 13:11:11 -0500
Received: from www.linutronix.de ([62.245.132.108]:36620 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768597Ab2KOSLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 13:11:09 -0500
Date: Thu, 15 Nov 2012 19:11:07 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.6.6-rt17
In-Reply-To: <50A3F75D.8090105@localhost>
Message-ID: <alpine.LFD.2.02.1211151901300.2701@ionos>
References: <alpine.LFD.2.02.1211122223300.10000@ionos> <50A3F75D.8090105@localhost>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2012, Fernando Lopez-Lezcano wrote:

> On 11/12/2012 01:28 PM, Thomas Gleixner wrote:
> > Dear RT Folks,
> > 
> > I'm pleased to announce the 3.6.6-rt17 release. 3.6.6-rt16 is just a
> > not announced update release to 3.6.6.
> 
> Got this:
> 
> ----
> net/nfc/llcp/llcp.c: In function 'nfc_llcp_register_device':
> net/nfc/llcp/llcp.c:1185:24: error: expected expression before '{' token
> net/nfc/llcp/llcp.c:1186:35: error: expected expression before '{' token
> ----
> 
> when building with CONFIG_NFC / CONFIG_NFS_LLCP (builds fine when those are
> not set)

Grrr. Damned ignorants.

Does that fix it for you ?

Thanks,

	tglx

------------>

Subject: nfc: Use proper lock init functions
From: Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 15 Nov 2012 19:03:20 +0100

Grmbl. Why insist people on using static initializers if there are
proper init functions? Just because they can?

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 net/nfc/llcp/llcp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-stable/net/nfc/llcp/llcp.c
===================================================================
--- linux-stable.orig/net/nfc/llcp/llcp.c
+++ linux-stable/net/nfc/llcp/llcp.c
@@ -1182,8 +1182,8 @@ int nfc_llcp_register_device(struct nfc_
 		goto err_rx_wq;
 	}
 
-	local->sockets.lock = __RW_LOCK_UNLOCKED(local->sockets.lock);
-	local->connecting_sockets.lock = __RW_LOCK_UNLOCKED(local->connecting_sockets.lock);
+	rwlock_init(&local->sockets.lock);
+	rwlock_init(&local->connecting_sockets.lock);
 
 	nfc_llcp_build_gb(local);
 
