Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250Ab0LHAri (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:47:38 -0500
Received: from kroah.org ([198.145.64.141]:58445 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756207Ab0LHArf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:47:35 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:44:31 2010
Message-Id: <20101208004431.478151366@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:44:18 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Matthieu Castet <castet.matthieu@free.fr>,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        Damien Bergamini <damien.bergamini@free.fr>
Subject: [072/127] USB: atm: ueagle-atm: fix up some permissions on the sysfs files
In-Reply-To: <20101208004456.GA23578@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Greg Kroah-Hartman <gregkh@suse.de>

commit e502ac5e1eca99d7dc3f12b2a6780ccbca674858 upstream.

Some of the sysfs files had the incorrect permissions.  Some didn't make
sense at all (writable for a file that you could not write to?)

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthieu Castet <castet.matthieu@free.fr>
Cc: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: Damien Bergamini <damien.bergamini@free.fr>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/atm/ueagle-atm.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/usb/atm/ueagle-atm.c
+++ b/drivers/usb/atm/ueagle-atm.c
@@ -2259,7 +2259,7 @@ out:
 	return ret;
 }
 
-static DEVICE_ATTR(stat_status, S_IWUGO | S_IRUGO, read_status, reboot);
+static DEVICE_ATTR(stat_status, S_IWUSR | S_IRUGO, read_status, reboot);
 
 static ssize_t read_human_status(struct device *dev, struct device_attribute *attr,
 		char *buf)
@@ -2322,7 +2322,7 @@ out:
 	return ret;
 }
 
-static DEVICE_ATTR(stat_human_status, S_IWUGO | S_IRUGO, read_human_status, NULL);
+static DEVICE_ATTR(stat_human_status, S_IRUGO, read_human_status, NULL);
 
 static ssize_t read_delin(struct device *dev, struct device_attribute *attr,
 		char *buf)
@@ -2354,7 +2354,7 @@ out:
 	return ret;
 }
 
-static DEVICE_ATTR(stat_delin, S_IWUGO | S_IRUGO, read_delin, NULL);
+static DEVICE_ATTR(stat_delin, S_IRUGO, read_delin, NULL);
 
 #define UEA_ATTR(name, reset) 					\
 								\


