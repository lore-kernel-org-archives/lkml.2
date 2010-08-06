Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965727Ab0HFTtp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 15:49:45 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:54235 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965695Ab0HFTtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 15:49:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=bH0W3G/0yjVXKgCJ8VrSiqOHHAwYQ6cwatbihTnBCps+Dio1ZsgRcQe34JghjBbgHw
         0HsHzV7K4QNtoVSzKXrKZur4Yri38OF403kJDIoK9WRCCQ7JjYqPvKIV9u3KFUbLH8BF
         aXaMzxvxZyLEQ9xtRiyhrCHS0hE1KEMEubyBk=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 04/18] char: sx: call disable_pci_device() if pci_probe() failed
Date: Fri,  6 Aug 2010 23:49:29 +0400
Message-Id: <1281124171-12751-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver should call disable_pci_device() if it returns from pci_probe()
with error. Also it must not be called if pci_request_region() fails as
it means that somebody uses device resources and rules the device.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/char/sx.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/char/sx.c b/drivers/char/sx.c
index 5b24db4..5140b0d 100644
--- a/drivers/char/sx.c
+++ b/drivers/char/sx.c
@@ -2711,6 +2711,7 @@ err_unmap:
 	iounmap(board->base2);
 err_reg:
 	pci_release_region(pdev, reg);
+	pci_disable_device(pdev);
 err_flag:
 	board->flags &= ~SX_BOARD_PRESENT;
 err:
-- 
1.7.0.4

