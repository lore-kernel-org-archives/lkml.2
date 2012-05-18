Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030676Ab2ERW1o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 18:27:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59222 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759740Ab2ERW1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 18:27:37 -0400
Date: Fri, 18 May 2012 15:26:07 -0700
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
Subject: [PATCH 11/14] pstore/ram: Add some more documentation and examples
Message-ID: <20120518222606.GK23089@lizard>
References: <20120518222314.GA9425@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120518222314.GA9425@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suggested-by: Shuah Khan <shuahkhan@gmail.com>
Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
Acked-by: Kees Cook <keescook@chromium.org>
Acked-by: Colin Cross <ccross@android.com>
---
 Documentation/ramoops.txt |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/Documentation/ramoops.txt b/Documentation/ramoops.txt
index 4ba7db2..59a74a8 100644
--- a/Documentation/ramoops.txt
+++ b/Documentation/ramoops.txt
@@ -40,6 +40,12 @@ corrupt, but usually it is restorable.
 Setting the ramoops parameters can be done in 2 different manners:
  1. Use the module parameters (which have the names of the variables described
  as before).
+ For quick debugging, you can also reserve parts of memory during boot
+ and then use the reserved memory for ramoops. For example, assuming a machine
+ with > 128 MB of memory, the following kernel command line will tell the
+ kernel to use only the first 128 MB of memory, and place ECC-protected ramoops
+ region at 128 MB boundary:
+ "mem=128M ramoops.mem_address=0x8000000 ramoops.ecc=1"
  2. Use a platform device and set the platform data. The parameters can then
  be set through that platform data. An example of doing that is:
 
@@ -70,6 +76,14 @@ if (ret) {
 	return ret;
 }
 
+You can specify either RAM memory or peripheral devices' memory. However, when
+specifying RAM, be sure to reserve the memory by issuing memblock_reserve()
+very early in the architecture code, e.g.:
+
+#include <linux/memblock.h>
+
+memblock_reserve(ramoops_data.mem_address, ramoops_data.mem_size);
+
 3. Dump format
 
 The data dump begins with a header, currently defined as "====" followed by a
-- 
1.7.9.2

