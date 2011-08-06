Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932374Ab1HFAUM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 20:20:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39473 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932207Ab1HFAK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 20:10:56 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug  5 17:04:13 2011
Message-Id: <20110806000413.472096768@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 05 Aug 2011 17:03:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Anand Gadiyar <gadiyar@ti.com>, Ajay Kumar Gupta <ajay.gupta@ti.com>,
        Felipe Balbi <balbi@ti.com>
Subject: [19/50] usb: musb: restore INDEX register in resume path
In-Reply-To: <20110806000419.GA28392@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Ajay Kumar Gupta <ajay.gupta@ti.com>

commit 3c5fec75e121b21a2eb35e5a6b44291509abba6f upstream.

Restoring the missing INDEX register value in musb_restore_context().
Without this suspend resume functionality is broken with offmode
enabled.

Acked-by: Anand Gadiyar <gadiyar@ti.com>
Signed-off-by: Ajay Kumar Gupta <ajay.gupta@ti.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/musb/musb_core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -1640,6 +1640,7 @@ void musb_dma_completion(struct musb *mu
 			}
 		}
 	}
+	musb_writeb(musb_base, MUSB_INDEX, musb->context.index);
 }
 
 #else


