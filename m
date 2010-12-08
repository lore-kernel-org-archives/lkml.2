Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932652Ab0LHBDN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:03:13 -0500
Received: from kroah.org ([198.145.64.141]:33612 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932618Ab0LHBDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:03:07 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:42 2010
Message-Id: <20101208005742.665856881@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:59:49 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [212/289] USB: misc: usbled: fix up some sysfs attribute permissions
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Greg Kroah-Hartman <gregkh@suse.de>

commit 48f115470e68d443436b76b22dad63ffbffd6b97 upstream.

They should not be writable by any user.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/misc/usbled.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/misc/usbled.c
+++ b/drivers/usb/misc/usbled.c
@@ -94,7 +94,7 @@ static ssize_t set_##value(struct device
 	change_color(led);						\
 	return count;							\
 }									\
-static DEVICE_ATTR(value, S_IWUGO | S_IRUGO, show_##value, set_##value);
+static DEVICE_ATTR(value, S_IRUGO | S_IWUSR, show_##value, set_##value);
 show_set(blue);
 show_set(red);
 show_set(green);


