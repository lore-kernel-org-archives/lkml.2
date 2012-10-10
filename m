Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564Ab2JJWxv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 18:53:51 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:47075 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757548Ab2JJWxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 18:53:47 -0400
X-Sasl-enc: d0wfV7w66KE6edXPtOaUZ4X6HWLbZS0phlsj9WqOs7Jn 1349909626
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Feng Hong <hongfeng@marvell.com>, Raul Xiong <xjian@marvell.com>,
        Neil Zhang <zhangwm@marvell.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [ 021/133] PM / Sleep: use resume event when call dpm_resume_early
Date: Thu, 11 Oct 2012 07:50:47 +0900
Message-Id: <20121010224858.269630214@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010224854.313159132@linuxfoundation.org>
References: <20121010224854.313159132@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5-stable review patch.  If anyone has any objections, please let me know.

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
@@ -994,7 +994,7 @@ int dpm_suspend_end(pm_message_t state)
 
 	error = dpm_suspend_noirq(state);
 	if (error) {
-		dpm_resume_early(state);
+		dpm_resume_early(resume_event(state));
 		return error;
 	}
 


