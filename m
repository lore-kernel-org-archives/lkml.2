Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758038Ab0GHQJ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 12:09:27 -0400
Received: from kroah.org ([198.145.64.141]:41682 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754362Ab0GHQJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 12:09:26 -0400
Subject: patch "dmi-id: fix a memory leak in dmi_id_init error path" added to gregkh-2.6 tree
To: axel.lin@gmail.com, dbrownell@users.sourceforge.net, gregkh@suse.de,
       linux-kernel@vger.kernel.org, tj@kernel.org
From: <gregkh@suse.de>
Date: Thu, 08 Jul 2010 09:09:19 -0700
In-Reply-To: <1277951707.30073.5.camel@mola>
Message-ID: <1278605359932@site>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    dmi-id: fix a memory leak in dmi_id_init error path

to my gregkh-2.6 tree which can be found in directory form at:
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/
 and in git form at:
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/patches.git

The filename of this patch is:
    dmi-id-fix-a-memory-leak-in-dmi_id_init-error-path.patch

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

If this patch meets the merge guidelines for a bugfix, it should be
merged into Linus's tree before the next major kernel release.
If not, it will be merged into Linus's tree during the next merge window.

Either way, you will probably be copied on the patch when it gets sent
to Linus for merging so that others can see what is happening in kernel
development.

If you have any questions about this process, please let me know.


>From axel.lin@gmail.com  Thu Jul  8 08:56:03 2010
From: Axel Lin <axel.lin@gmail.com>
Date: Thu, 01 Jul 2010 10:35:07 +0800
Subject: dmi-id: fix a memory leak in dmi_id_init error path
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Tejun Heo <tj@kernel.org>, David Brownell <dbrownell@users.sourceforge.net>, Greg Kroah-Hartman <gregkh@suse.de>
Message-ID: <1277951707.30073.5.camel@mola>


This patch adds a missing kfree(dmi_dev) in dmi_id_init error path.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/firmware/dmi-id.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/firmware/dmi-id.c
+++ b/drivers/firmware/dmi-id.c
@@ -229,10 +229,12 @@ static int __init dmi_id_init(void)
 
 	ret = device_register(dmi_dev);
 	if (ret)
-		goto fail_class_unregister;
+		goto fail_free_dmi_dev;
 
 	return 0;
 
+fail_free_dmi_dev:
+	kfree(dmi_dev);
 fail_class_unregister:
 
 	class_unregister(&dmi_class);

