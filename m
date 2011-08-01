Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab1HAXZ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 19:25:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38261 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753747Ab1HAXZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 19:25:11 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Aug  1 16:20:53 2011
Message-Id: <20110801232053.087764516@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 01 Aug 2011 16:18:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [25/70] [media] tuner-core: fix tuner_resume: use t->mode instead of t->type
In-Reply-To: <20110801232124.GA15313@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Hans Verkuil <hans.verkuil@cisco.com>

commit 9bf0ef060ebae452c07cf5b0616247780740bb50 upstream.

set_mode is called with t->type, which is the tuner type. Instead, use
t->mode which is the actual tuner mode (i.e. radio vs tv).

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/tuner-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/video/tuner-core.c
+++ b/drivers/media/video/tuner-core.c
@@ -1223,7 +1223,7 @@ static int tuner_resume(struct i2c_clien
 	tuner_dbg("resume\n");
 
 	if (!t->standby)
-		if (set_mode(t, t->type) == 0)
+		if (set_mode(t, t->mode) == 0)
 			set_freq(t, 0);
 
 	return 0;


