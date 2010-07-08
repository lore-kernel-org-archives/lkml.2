Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244Ab0GHSqX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 14:46:23 -0400
Received: from kroah.org ([198.145.64.141]:33649 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753944Ab0GHSqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 14:46:22 -0400
Subject: patch "USB: serial: io_ti: Don't return 0 if writing the download record failed" added to gregkh-2.6 tree
To: roel.kluin@gmail.com, akpm@linux-foundation.org, gregkh@suse.de,
       linux-kernel@vger.kernel.org
From: <gregkh@suse.de>
Date: Thu, 08 Jul 2010 11:44:45 -0700
In-Reply-To: <4C2D187B.4020109@gmail.com>
Message-ID: <12786146852391@site>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: serial: io_ti: Don't return 0 if writing the download record failed

to my gregkh-2.6 tree which can be found in directory form at:
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/
 and in git form at:
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/patches.git

The filename of this patch is:
    usb-serial-io_ti-don-t-return-0-if-writing-the-download-record-failed.patch

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

If this patch meets the merge guidelines for a bugfix, it should be
merged into Linus's tree before the next major kernel release.
If not, it will be merged into Linus's tree during the next merge window.

Either way, you will probably be copied on the patch when it gets sent
to Linus for merging so that others can see what is happening in kernel
development.

If you have any questions about this process, please let me know.


>From roel.kluin@gmail.com  Thu Jul  8 11:35:42 2010
From: Roel Kluin <roel.kluin@gmail.com>
Date: Fri, 02 Jul 2010 00:36:43 +0200
Subject: USB: serial: io_ti: Don't return 0 if writing the download record failed
To: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>
Message-ID: <4C2D187B.4020109@gmail.com>


If the write download record failed we shouldn't return 0.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/io_ti.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/serial/io_ti.c
+++ b/drivers/usb/serial/io_ti.c
@@ -1321,7 +1321,7 @@ static int download_fw(struct edgeport_s
 				kfree(header);
 				kfree(rom_desc);
 				kfree(ti_manuf_desc);
-				return status;
+				return -EINVAL;
 			}
 
 			kfree(vheader);

