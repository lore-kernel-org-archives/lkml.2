Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933201Ab0HXXBi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:01:38 -0400
Received: from kroah.org ([198.145.64.141]:40864 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933297Ab0HXXB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 19:01:28 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:45:02 2010
Message-Id: <20100824224502.848300670@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:44:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Yuri Ershov <ext-yuri.ershov@nokia.com>,
        Yuri Kululin <ext-yuri.kululin@nokia.com>,
        Kalle Valo <kvalo@adurom.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [018/114] wl1251: fix trigger scan timeout usage
In-Reply-To: <20100824224610.GA5424@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Yuri Kululin <ext-yuri.kululin@nokia.com>

commit fe0dbcc9d2e941328b3269dab102b94ad697ade5 upstream.

Use appropriate command (CMD_TRIGGER_SCAN_TO) instead of scan command
(CMD_SCAN) to configure trigger scan timeout.

This was broken in commit 3a98c30f3e8bb1f32b5bcb74a39647b3670de275.

This fix address the bug reported here:

https://bugzilla.kernel.org/show_bug.cgi?id=16554

Signed-off-by: Yuri Ershov <ext-yuri.ershov@nokia.com>
Signed-off-by: Yuri Kululin <ext-yuri.kululin@nokia.com>
Acked-by: Kalle Valo <kvalo@adurom.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/wl12xx/wl1251_cmd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/wl12xx/wl1251_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1251_cmd.c
@@ -484,7 +484,7 @@ int wl1251_cmd_trigger_scan_to(struct wl
 
 	cmd->timeout = timeout;
 
-	ret = wl1251_cmd_send(wl, CMD_SCAN, cmd, sizeof(*cmd));
+	ret = wl1251_cmd_send(wl, CMD_TRIGGER_SCAN_TO, cmd, sizeof(*cmd));
 	if (ret < 0) {
 		wl1251_error("cmd trigger scan to failed: %d", ret);
 		goto out;


