Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab0JOMnF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 08:43:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:38187 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754845Ab0JOMnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 08:43:03 -0400
Message-ID: <4CB84C4C.6040204@kernel.org>
Date: Fri, 15 Oct 2010 14:42:52 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Karsten Keil <isdn@linux-pingi.de>, Armin Schindler <mac@melware.de>,
        lkml <linux-kernel@vger.kernel.org>, Jan Kiszka <jan.kiszka@web.de>
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2.6.36-rc7 1/2] isdn/capi: unregister capictr notifier after
 init failure
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 15 Oct 2010 12:42:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

capidrv_init() could leave capictr notifier dangling after init
failure.  Fix it.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/isdn/capi/capidrv.c |    1 +
 1 file changed, 1 insertion(+)

Index: work/drivers/isdn/capi/capidrv.c
===================================================================
--- work.orig/drivers/isdn/capi/capidrv.c
+++ work/drivers/isdn/capi/capidrv.c
@@ -2288,6 +2288,7 @@ static int __init capidrv_init(void)

 	errcode = capi20_get_profile(0, &profile);
 	if (errcode != CAPI_NOERROR) {
+		unregister_capictr_notifier(&capictr_nb);
 		capi20_release(&global.ap);
 		return -EIO;
 	}
