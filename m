Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932849Ab1EFA4F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:56:05 -0400
Received: from kroah.org ([198.145.64.141]:36771 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755860Ab1EFAYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:24:49 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:10 2011
Message-Id: <20110506002210.131359642@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:20:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dmitry Torokhov <dtor@mail.ru>
Subject: [050/143] Input: elantech - do not advertise relative events
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit c7a1f3ccfc2f99427f2e1545b3171e98539c3c95 upstream.

Elantech touchpads work in absolute mode and do not generate relative
events so they should not be advertising them.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/input/mouse/elantech.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/mouse/elantech.c
+++ b/drivers/input/mouse/elantech.c
@@ -420,6 +420,7 @@ static void elantech_set_input_params(st
 
 	__set_bit(EV_KEY, dev->evbit);
 	__set_bit(EV_ABS, dev->evbit);
+	__clear_bit(EV_REL, dev->evbit);
 
 	__set_bit(BTN_LEFT, dev->keybit);
 	__set_bit(BTN_RIGHT, dev->keybit);


