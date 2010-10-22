Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759810Ab0JVTRh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:17:37 -0400
Received: from kroah.org ([198.145.64.141]:34081 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759314Ab0JVS4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:56:19 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:30 2010
Message-Id: <20101022185230.670100677@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:51:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kenneth Waters <kwwaters@gmail.com>, Dmitry Torokhov <dtor@mail.ru>
Subject: [037/103] Input: joydev - fix JSIOCSAXMAP ioctl
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

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
@@ -483,6 +483,9 @@ static int joydev_handle_JSIOCSAXMAP(str
 
 	memcpy(joydev->abspam, abspam, len);
 
+	for (i = 0; i < joydev->nabs; i++)
+		joydev->absmap[joydev->abspam[i]] = i;
+
  out:
 	kfree(abspam);
 	return retval;


