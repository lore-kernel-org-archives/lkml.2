Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932316Ab2JJWxg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 18:53:36 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:59543 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932204Ab2JJWxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 18:53:31 -0400
X-Sasl-enc: zgQxZC5wMe6SpCJUwvD1hgE7VMf+wPZjYInZf2brdQSW 1349909609
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Shawn Guo <shawn.guo@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 015/133] kernel/sys.c: call disable_nonboot_cpus() in kernel_restart()
Date: Thu, 11 Oct 2012 07:50:41 +0900
Message-Id: <20121010224857.206919840@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010224854.313159132@linuxfoundation.org>
References: <20121010224854.313159132@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shawn Guo <shawn.guo@linaro.org>

commit f96972f2dc6365421cf2366ebd61ee4cf060c8d5 upstream.

As kernel_power_off() calls disable_nonboot_cpus(), we may also want to
have kernel_restart() call disable_nonboot_cpus().  Doing so can help
machines that require boot cpu be the last alive cpu during reboot to
survive with kernel restart.

This fixes one reboot issue seen on imx6q (Cortex-A9 Quad).  The machine
requires that the restart routine be run on the primary cpu rather than
secondary ones.  Otherwise, the secondary core running the restart
routine will fail to come to online after reboot.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/sys.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -368,6 +368,7 @@ EXPORT_SYMBOL(unregister_reboot_notifier
 void kernel_restart(char *cmd)
 {
 	kernel_restart_prepare(cmd);
+	disable_nonboot_cpus();
 	if (!cmd)
 		printk(KERN_EMERG "Restarting system.\n");
 	else


