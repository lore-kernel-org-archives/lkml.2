Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab0LKEyO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 23:54:14 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44732 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738Ab0LKEyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 23:54:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=jMeTOoNu95H//DZY/2t4Z1YkF9as16jTcVzaxXwB9fMO2Ymksr+BED0sH+D5YuOl+4
         vNaiRuil3d+k+C6fKwHHTWro5NC3VdO8gJbOZqNHObpuPlgc1x731Xh4qO0Jg+/+flO+
         spmRu+/gr8kFmyMuMuC11oXjKJw6I7HKIaASA=
MIME-Version: 1.0
Date: Sat, 11 Dec 2010 12:54:11 +0800
Message-ID: <AANLkTiksuf0ZDWyjH6ec9rSRoG+5ZdakA-Tha9MXLvy+@mail.gmail.com>
Subject: [PATCH] fix bug in Ethernet Channel Bonding Driver
From: Hillf Danton <dhillf@gmail.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The returned slave is incorrect, if the net device under check is not
charged yet by the master.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/drivers/net/bonding/bonding.h	2010-11-01 19:54:12.000000000 +0800
+++ b/drivers/net/bonding/bonding.h	2010-12-11 12:48:00.000000000 +0800
@@ -273,11 +273,11 @@ static inline struct slave *bond_get_sla

 	bond_for_each_slave(bond, slave, i) {
 		if (slave->dev == slave_dev) {
-			break;
+			return slave;
 		}
 	}

-	return slave;
+	return 0;
 }

 static inline struct bonding *bond_get_bond_by_slave(struct slave *slave)
