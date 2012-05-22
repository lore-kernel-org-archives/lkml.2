Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758634Ab2EVOUS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 10:20:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60941 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757687Ab2EVOUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 10:20:13 -0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, John Stultz <john.stultz@linaro.org>,
        Shuah Khan <shuahkhan@gmail.com>, arve@android.com,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: [PATCH 05/16] pstore/ram: Should zap persistent zone on unlink
Date: Tue, 22 May 2012 07:17:48 -0700
Message-Id: <1337696279-8994-5-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <20120522141717.GA31574@lizard>
References: <20120522141717.GA31574@lizard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise, unlinked file will reappear on the next boot.

Reported-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 fs/pstore/ram.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index 16ff733..453030f 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -186,6 +186,7 @@ static int ramoops_pstore_erase(enum pstore_type_id type, u64 id,
 		return -EINVAL;
 
 	persistent_ram_free_old(cxt->przs[id]);
+	persistent_ram_zap(cxt->przs[id]);
 
 	return 0;
 }
-- 
1.7.9.2

