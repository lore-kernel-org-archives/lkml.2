Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757811Ab1BPBio (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:38:44 -0500
Received: from kroah.org ([198.145.64.141]:39063 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757098Ab1BPAUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:20:18 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:33 2011
Message-Id: <20110216001433.613208850@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:12:22 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Malcolm Priestley <tvboxspy@gmail.com>,
        Matthias Schwarzott <zzam@gentoo.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [085/272] [media] IX2505V: i2c transfer error code ignored
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Matthias Schwarzott <zzam@gentoo.org>

commit 13d28e4917fb6cf6898e8998f01ab83b3f468aeb upstream.

It seems that ix2505v driver ignores a i2c error in ix2505v_read_status_reg.
This looks like a typing error using (ret = 1) instead of correct (ret == 1).

Acked-by: Malcolm Priestley <tvboxspy@gmail.com>
Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/dvb/frontends/ix2505v.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/dvb/frontends/ix2505v.c
+++ b/drivers/media/dvb/frontends/ix2505v.c
@@ -72,7 +72,7 @@ static int ix2505v_read_status_reg(struc
 	ret = i2c_transfer(state->i2c, msg, 1);
 	deb_i2c("Read %s ", __func__);
 
-	return (ret = 1) ? (int) b2[0] : -1;
+	return (ret == 1) ? (int) b2[0] : -1;
 }
 
 static int ix2505v_write(struct ix2505v_state *state, u8 buf[], u8 count)


