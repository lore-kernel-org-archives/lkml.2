Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826Ab1AWX4k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 18:56:40 -0500
Received: from 59-72-223.ftth.xms.internl.net ([85.223.72.59]:39456 "EHLO
	salamandra.streefland.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748Ab1AWX4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 18:56:38 -0500
X-Greylist: delayed 699 seconds by postgrey-1.27 at vger.kernel.org; Sun, 23 Jan 2011 18:56:38 EST
Date: Mon, 24 Jan 2011 00:44:57 +0100
From: Dick Streefland <dick@streefland.net>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Arkadiusz Miskiewicz <arekm@maven.pl>
Subject: [PATCH] scripts/extract-ikconfig: add xz compression support
Message-ID: <20110123234457.GB2321@streefland.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for kernels compressed with xz to the extract-ikconfig script.

Signed-off-by: Dick Streefland <dick@streefland.net>
---
 scripts/extract-ikconfig |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/scripts/extract-ikconfig b/scripts/extract-ikconfig
index 1512c0a..e186242 100755
--- a/scripts/extract-ikconfig
+++ b/scripts/extract-ikconfig
@@ -56,10 +56,11 @@ trap "rm -f $tmp1 $tmp2" 0
 dump_config "$img"
 
 # That didn't work, so retry after decompression.
-try_decompress '\037\213\010' xy  gunzip
-try_decompress 'BZh'          xy  bunzip2
-try_decompress '\135\0\0\0'   xxx unlzma
-try_decompress '\211\114\132' xy  'lzop -d'
+try_decompress '\037\213\010' xy    gunzip
+try_decompress '\3757zXZ\000' abcde unxz
+try_decompress 'BZh'          xy    bunzip2
+try_decompress '\135\0\0\0'   xxx   unlzma
+try_decompress '\211\114\132' xy    'lzop -d'
 
 # Bail out:
 echo "$me: Cannot find kernel config." >&2
