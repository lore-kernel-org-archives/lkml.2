Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933809Ab2JKBh6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 21:37:58 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:59804 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933646Ab2JKBSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 21:18:12 -0400
X-Sasl-enc: RxNn1r60NmyUGphqEJZzov8Hh6ahU+b+qDiCLayTDUP4 1349918291
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Feng Hong <hongfeng@marvell.com>, Raul Xiong <xjian@marvell.com>,
        Neil Zhang <zhangwm@marvell.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [ 018/120] PM / Sleep: use resume event when call dpm_resume_early
Date: Thu, 11 Oct 2012 09:59:30 +0900
Message-Id: <20121011005828.675686995@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121011005825.364610894@linuxfoundation.org>
References: <20121011005825.364610894@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Feng Hong <hongfeng@marvell.com>

commit 997a031107ec962967ce36db9bc500f1fad491c1 upstream.

When dpm_suspend_noirq fail, state is PMSG_SUSPEND,
should change to PMSG_RESUME when dpm_resume_early is called

Signed-off-by: Feng Hong <hongfeng@marvell.com>
Signed-off-by: Raul Xiong <xjian@marvell.com>
Signed-off-by: Neil Zhang <zhangwm@marvell.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/power/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -984,7 +984,7 @@ int dpm_suspend_end(pm_message_t state)
 
 	error = dpm_suspend_noirq(state);
 	if (error) {
-		dpm_resume_early(state);
+		dpm_resume_early(resume_event(state));
 		return error;
 	}
 


