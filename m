Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030594Ab2ERW1b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 18:27:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60603 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759724Ab2ERW1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 18:27:24 -0400
Date: Fri, 18 May 2012 15:25:55 -0700
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
Subject: [PATCH 10/14] pstore/ram_core: Silence some printks
Message-ID: <20120518222554.GJ23089@lizard>
References: <20120518222314.GA9425@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120518222314.GA9425@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
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
index 28b6d7f..44fc724 100644
--- a/fs/pstore/ram_core.c
+++ b/fs/pstore/ram_core.c
@@ -424,14 +424,14 @@ static int __init persistent_ram_post_init(struct persistent_ram_zone *prz, bool
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

