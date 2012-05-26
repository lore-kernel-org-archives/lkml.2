Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab2EZNWh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 09:22:37 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58205 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630Ab2EZNWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 09:22:33 -0400
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
Subject: [PATCH 06/11] pstore/ram_core: Silence some printks
Date: Sat, 26 May 2012 06:20:24 -0700
Message-Id: <1338038429-21945-6-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <20120526131747.GA15054@lizard>
References: <20120526131747.GA15054@lizard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we use multiple regions, the messages are somewhat annoying.
We do print total mapped memory already, so no need to print the
information for each region in the library routines.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
Acked-by: Kees Cook <keescook@chromium.org>
Acked-by: Colin Cross <ccross@android.com>
---
 fs/pstore/ram_core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/pstore/ram_core.c b/fs/pstore/ram_core.c
index c5fbdbb..78f6d4b 100644
--- a/fs/pstore/ram_core.c
+++ b/fs/pstore/ram_core.c
@@ -409,14 +409,14 @@ static int __init persistent_ram_post_init(struct persistent_ram_zone *prz, bool
 				" size %zu, start %zu\n",
 			       buffer_size(prz), buffer_start(prz));
 		else {
-			pr_info("persistent_ram: found existing buffer,"
+			pr_debug("persistent_ram: found existing buffer,"
 				" size %zu, start %zu\n",
 			       buffer_size(prz), buffer_start(prz));
 			persistent_ram_save_old(prz);
 			return 0;
 		}
 	} else {
-		pr_info("persistent_ram: no valid data in buffer"
+		pr_debug("persistent_ram: no valid data in buffer"
 			" (sig = 0x%08x)\n", prz->buffer->sig);
 	}
 
-- 
1.7.9.2

