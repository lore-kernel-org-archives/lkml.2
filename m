Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759402Ab1KWAlp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 19:41:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42966 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759388Ab1KWAlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:41:42 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Nov 22 16:24:05 2011
Message-Id: <20111123002405.357918914@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Tue, 22 Nov 2011 16:23:15 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jesper Juhl <jj@chaosbits.net>,
        Dan Williams <dcbw@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [08/53] Net, libertas: Resolve memory leak in if_spi_host_to_card()
In-Reply-To: <20111123002419.GA8531@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesper Juhl <jj@chaosbits.net>

commit fe09b32a4361bea44169b2063e8c867cabb6a8ba upstream.

If we hit the default case in the switch in if_spi_host_to_card() we'll leak
the memory we allocated for 'packet'. This patch resolves the leak by freeing
the allocated memory in that case.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Acked-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/libertas/if_spi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/libertas/if_spi.c
+++ b/drivers/net/wireless/libertas/if_spi.c
@@ -997,6 +997,7 @@ static int if_spi_host_to_card(struct lb
 		spin_unlock_irqrestore(&card->buffer_lock, flags);
 		break;
 	default:
+		kfree(packet);
 		netdev_err(priv->dev, "can't transfer buffer of type %d\n",
 			   type);
 		err = -EINVAL;


