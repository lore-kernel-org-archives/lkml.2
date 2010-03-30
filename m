Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757685Ab0CaA1i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:27:38 -0400
Received: from kroah.org ([198.145.64.141]:48929 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756450Ab0C3XMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:12:24 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:58:31 2010
Message-Id: <20100330225830.572370316@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:57:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       James Bottomley <James.Bottomley@suse.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [36/89] SCSI: enclosure: fix oops while iterating enclosure_status array
In-Reply-To: <20100330230520.GA28779@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: James Bottomley <James.Bottomley@suse.de>

commit cc9b2e9f6603190c009e5d2629ce8e3f99571346 upstream.

Based on patch originally by Jeff Mahoney <jeffm@suse.com>

 enclosure_status is expected to be a NULL terminated array of strings
 but isn't actually NULL terminated. When writing an invalid value to
 /sys/class/enclosure/.../.../status, it goes off the end of the array
 and Oopses.


Fix by making the assumption true and adding NULL at the end.

Reported-by: Artur Wojcik <artur.wojcik@intel.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/misc/enclosure.c  |    1 +
 include/linux/enclosure.h |    2 ++
 2 files changed, 3 insertions(+)

--- a/drivers/misc/enclosure.c
+++ b/drivers/misc/enclosure.c
@@ -362,6 +362,7 @@ static const char *const enclosure_statu
 	[ENCLOSURE_STATUS_NOT_INSTALLED] = "not installed",
 	[ENCLOSURE_STATUS_UNKNOWN] = "unknown",
 	[ENCLOSURE_STATUS_UNAVAILABLE] = "unavailable",
+	[ENCLOSURE_STATUS_MAX] = NULL,
 };
 
 static const char *const enclosure_type [] = {
--- a/include/linux/enclosure.h
+++ b/include/linux/enclosure.h
@@ -42,6 +42,8 @@ enum enclosure_status {
 	ENCLOSURE_STATUS_NOT_INSTALLED,
 	ENCLOSURE_STATUS_UNKNOWN,
 	ENCLOSURE_STATUS_UNAVAILABLE,
+	/* last element for counting purposes */
+	ENCLOSURE_STATUS_MAX
 };
 
 /* SFF-8485 activity light settings */


