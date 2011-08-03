Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051Ab1HCX0X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 19:26:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33405 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756028Ab1HCX0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 19:26:10 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Aug  3 15:12:44 2011
Message-Id: <20110803221244.890492482@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 03 Aug 2011 15:00:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: [008/102] staging: comedi: fix infoleak to userspace
In-Reply-To: <20110803221345.GA10346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Vasiliy Kulikov <segoon@openwall.com>

commit 819cbb120eaec7e014e5abd029260db1ca8c5735 upstream.

driver_name and board_name are pointers to strings, not buffers of size
COMEDI_NAMELEN.  Copying COMEDI_NAMELEN bytes of a string containing
less than COMEDI_NAMELEN-1 bytes would leak some unrelated bytes.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/comedi/comedi_fops.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -383,8 +383,8 @@ static int do_devinfo_ioctl(struct comed
 	/* fill devinfo structure */
 	devinfo.version_code = COMEDI_VERSION_CODE;
 	devinfo.n_subdevs = dev->n_subdevices;
-	memcpy(devinfo.driver_name, dev->driver->driver_name, COMEDI_NAMELEN);
-	memcpy(devinfo.board_name, dev->board_name, COMEDI_NAMELEN);
+	strlcpy(devinfo.driver_name, dev->driver->driver_name, COMEDI_NAMELEN);
+	strlcpy(devinfo.board_name, dev->board_name, COMEDI_NAMELEN);
 
 	if (read_subdev)
 		devinfo.read_subdevice = read_subdev - dev->subdevices;


