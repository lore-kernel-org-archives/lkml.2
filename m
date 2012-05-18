Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030276Ab2ERW0B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 18:26:01 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60603 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030310Ab2ERWZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 18:25:57 -0400
Date: Fri, 18 May 2012 15:24:27 -0700
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
Subject: [PATCH 03/14] pstore/ram_core: Do not reset restored zone's position
 and size
Message-ID: <20120518222426.GC23089@lizard>
References: <20120518222314.GA9425@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120518222314.GA9425@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise, the files will survive just one reboot, and on a subsequent
boot they will disappear.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 fs/pstore/ram_core.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/pstore/ram_core.c b/fs/pstore/ram_core.c
index 849a542..dff5127 100644
--- a/fs/pstore/ram_core.c
+++ b/fs/pstore/ram_core.c
@@ -422,6 +422,7 @@ static int __init persistent_ram_post_init(struct persistent_ram_zone *prz, bool
 				" size %zu, start %zu\n",
 			       buffer_size(prz), buffer_start(prz));
 			persistent_ram_save_old(prz);
+			return 0;
 		}
 	} else {
 		pr_info("persistent_ram: no valid data in buffer"
-- 
1.7.9.2

