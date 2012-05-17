Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759455Ab2EQImn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 04:42:43 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:65088 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759130Ab2EQImg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 04:42:36 -0400
Date: Thu, 17 May 2012 01:41:07 -0700
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
Subject: [PATCH 4/6] pstore/ram: Add some more documentation and examples
Message-ID: <20120517084107.GD31753@lizard>
References: <20120517083740.GA25627@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120517083740.GA25627@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suggested-by: Shuah Khan <shuahkhan@gmail.com>
Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
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

