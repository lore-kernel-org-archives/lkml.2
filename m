Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab1CJX5k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 18:57:40 -0500
Received: from kroah.org ([198.145.64.141]:46944 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754733Ab1CJX5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 18:57:36 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Mar 10 15:55:38 2011
Message-Id: <20110310235538.827178742@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 10 Mar 2011 15:54:34 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sven Barth <pascaldragon@googlemail.com>,
        Andy Walls <awalls@md.metrocast.net>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [patch 28/29] [media] cx25840: fix probing of cx2583x chips
In-Reply-To: <20110310235548.GA10103@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sven Barth <pascaldragon@googlemail.com>

commit 1e6406b8f0dc1ae7d7c39c9e1ac6ca78e016ebfb upstream.

Fix the probing of cx2583x chips, because two controls were clustered
that are not created for these chips.

This regression was introduced in 2.6.36.

Signed-off-by: Sven Barth <pascaldragon@googlemail.com>
Signed-off-by: Andy Walls <awalls@md.metrocast.net>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/cx25840/cx25840-core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/media/video/cx25840/cx25840-core.c
+++ b/drivers/media/video/cx25840/cx25840-core.c
@@ -2031,7 +2031,8 @@ static int cx25840_probe(struct i2c_clie
 		kfree(state);
 		return err;
 	}
-	v4l2_ctrl_cluster(2, &state->volume);
+	if (!is_cx2583x(state))
+		v4l2_ctrl_cluster(2, &state->volume);
 	v4l2_ctrl_handler_setup(&state->hdl);
 
 	cx25840_ir_probe(sd);


