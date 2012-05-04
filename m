Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932385Ab2EDUp4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 16:45:56 -0400
Received: from mail-pz0-f45.google.com ([209.85.210.45]:45099 "EHLO
	mail-pz0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932296Ab2EDUpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:45:49 -0400
Message-Id: <20120504204227.554125750@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 04 May 2012 13:43:01 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dmitry Torokhov <dtor@mail.ru>
Subject: [ 37/75] Input: synaptics - fix regression with "image sensor" trackpads
In-Reply-To: <20120504204258.GA12552@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

commit 899c612d74d4a242158a4db20367388d6299c028 upstream.

commit 7968a5dd492ccc38345013e534ad4c8d6eb60ed1
Input: synaptics - add support for Relative mode

Accidentally broke support for advanced gestures (multitouch)
on some trackpads such as the one in my ThinkPad X220 by
incorretly changing the condition for enabling them. This
restores it.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/mouse/synaptics.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -274,7 +274,8 @@ static int synaptics_set_advanced_gestur
 	static unsigned char param = 0xc8;
 	struct synaptics_data *priv = psmouse->private;
 
-	if (!SYN_CAP_ADV_GESTURE(priv->ext_cap_0c))
+	if (!(SYN_CAP_ADV_GESTURE(priv->ext_cap_0c) ||
+	      SYN_CAP_IMAGE_SENSOR(priv->ext_cap_0c)))
 		return 0;
 
 	if (psmouse_sliced_command(psmouse, SYN_QUE_MODEL))


