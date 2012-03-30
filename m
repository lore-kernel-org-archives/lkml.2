Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761602Ab2C3XJn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 19:09:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54199 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933677Ab2C3VEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:04:07 -0400
Message-Id: <20120330195725.132679628@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:57:43 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ben Hutchings <ben@decadent.org.uk>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Oliver Neukum <oliver@neukum.org>
Subject: [ 021/108] cdc-wdm: Dont clear WDM_READ unless entire read buffer is emptied
In-Reply-To: <20120330195812.GA31833@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit b7a205545345578712611106b371538992e142ff upstream.

The WDM_READ flag is cleared later iff desc->length is reduced to 0.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Tested-by: Bjørn Mork <bjorn@mork.no>
Cc: Oliver Neukum <oliver@neukum.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/class/cdc-wdm.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -457,7 +457,6 @@ retry:
 			spin_unlock_irq(&desc->iuspin);
 			goto retry;
 		}
-		clear_bit(WDM_READ, &desc->flags);
 		cntr = desc->length;
 		spin_unlock_irq(&desc->iuspin);
 	}


