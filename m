Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932341Ab2KZRO7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:14:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48187 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933958Ab2KZROx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:14:53 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: <support@connecttech.com>, Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 240/270] USB: whiteheat: fix memory leak in error path
Date: Mon, 26 Nov 2012 14:58:50 -0200
Message-Id: <1353949160-26803-241-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit c129197c99550d356cf5f69b046994dd53cd1b9d upstream.

Make sure command buffer is deallocated in case of errors during attach.

Cc: <support@connecttech.com>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/serial/whiteheat.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/serial/whiteheat.c b/drivers/usb/serial/whiteheat.c
index 473635e..b65ac03 100644
--- a/drivers/usb/serial/whiteheat.c
+++ b/drivers/usb/serial/whiteheat.c
@@ -405,6 +405,7 @@ no_firmware:
 		"%s: please contact support@connecttech.com\n",
 		serial->type->description);
 	kfree(result);
+	kfree(command);
 	return -ENODEV;
 
 no_command_private:
-- 
1.7.9.5

