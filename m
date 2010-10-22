Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623Ab0JVSic (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:38:32 -0400
Received: from kroah.org ([198.145.64.141]:45669 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756381Ab0JVSi2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:38:28 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:35:58 2010
Message-Id: <20101022183558.127991243@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:34:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kenneth Waters <kwwaters@gmail.com>, Dmitry Torokhov <dtor@mail.ru>
Subject: [21/66] Input: joydev - fix JSIOCSAXMAP ioctl
In-Reply-To: <20101022183711.GA23214@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Kenneth Waters <kwwaters@gmail.com>

commit d2520a426dc3033c00077e923a553fc6c98c7564 upstream.

Fixed JSIOCSAXMAP ioctl to update absmap, the map from hardware axis to
event axis in addition to abspam.  This fixes a regression introduced
by 999b874f.

Signed-off-by: Kenneth Waters <kwwaters@gmail.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/input/joydev.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/input/joydev.c
+++ b/drivers/input/joydev.c
@@ -481,6 +481,9 @@ static int joydev_handle_JSIOCSAXMAP(str
 
 	memcpy(joydev->abspam, abspam, len);
 
+	for (i = 0; i < joydev->nabs; i++)
+		joydev->absmap[joydev->abspam[i]] = i;
+
  out:
 	kfree(abspam);
 	return retval;


