Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758027Ab2HHOcy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 10:32:54 -0400
Received: from 209.248.170.90.nw.nuvox.net ([209.248.170.90]:39210 "EHLO
	GVL-MAIL.koe-americas.local" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756548Ab2HHOcx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 10:32:53 -0400
From: David Cullen <David.Cullen@koe-americas.com>
To: "mmarek@suse.cz" <mmarek@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH] ARM Fix /usr/bin/xargs: etags: Argument list too long
Thread-Topic: [RFC PATCH] ARM Fix /usr/bin/xargs: etags: Argument list too
 long
Thread-Index: AQHNdXKwUdMPlyBDmEORxEZhcXYKAw==
Date: Wed, 8 Aug 2012 14:32:51 +0000
Message-ID: <50227893.7070600@koe-americas.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713
 Thunderbird/14.0
x-originating-ip: [10.1.5.28]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <9AA143D3EF33FC4581C5AF9B74FF58F6@koe-americas.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch applies to

    commit 42a579a0f960081cd16fc945036e4780c3ad3202

When running "make ARCH=arm TAGS" in a chroot using qemu-arm-static,
the following message is emitted:

    [user@host:/home/work/linux]: make ARCH=arm TAGS
      GEN     TAGS
    /usr/bin/xargs: etags: Argument list too long

This can be fixed by by passing "-L 1024" to xargs in scripts/tags.sh.

The "1024" was a guess. A value of "3862" changes the message to

    /usr/bin/xargs: argument list too long

Using "2048" also fixes the problem. However, I don't know how much
headroom that leaves

Does anyone know why the argument lists must be shorter for ARM? All
of the documentation I have available says that 4096 should be the
limit.

Signed-off-by: David Cullen <david.cullen@koe-americas.com>
---
 scripts/tags.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/tags.sh b/scripts/tags.sh
index cff8faa..7f4ebb3 100755
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -121,7 +121,7 @@ dogtags()

 exuberant()
 {
-       all_sources | xargs $1 -a                               \
+       all_sources | xargs -L 1024 $1 -a                       \
        -I __initdata,__exitdata,__acquires,__releases          \
        -I __read_mostly,____cacheline_aligned                  \
        -I ____cacheline_aligned_in_smp                         \
--
1.7.9.5