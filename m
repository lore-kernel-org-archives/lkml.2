Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471Ab0JaLsj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 07:48:39 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56986 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755028Ab0JaLsi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 07:48:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=jizrRiaFaaEOojWJ5tL9DUy6digsB4cfzGy0VMjhlpNAqjNoUn2sJpIsfq0/wc2m1R
         GY037mWzTP8d8Ne668aqRSamxoXmi0Y38GxxsuMPjQ6L2/JaVju6KcJCy8ZZCNVh25zU
         GA8rsl7tK7Bkj97IcXUF6D7JpEDcMRqleTw48=
MIME-Version: 1.0
Date: Sun, 31 Oct 2010 17:48:36 +0600
Message-ID: <AANLkTikDXtLrfjYkQrkGi44qi0cpp-C+Lxr5j1UkFd2G@mail.gmail.com>
Subject: [PATCH] fs, sysfs: Change sysfs_pathname function prototype.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sysfs_pathname inline, we we're hit by the following warning:


fs/sysfs/dir.c:410: warning: ‘sysfs_pathname’ defined but not used


Signed-off-by: Rakib Mullick <rakib.mullick@gmail>
---

--- linus-36/fs/sysfs/dir.c	2010-10-21 02:30:22.000000000 +0600
+++ rakib-36/fs/sysfs/dir.c	2010-10-31 17:34:46.000000000 +0600
@@ -407,7 +407,7 @@ int __sysfs_add_one(struct sysfs_addrm_c
  *
  *	XXX: does no error checking on @path size
  */
-static char *sysfs_pathname(struct sysfs_dirent *sd, char *path)
+static inline char *sysfs_pathname(struct sysfs_dirent *sd, char *path)
 {
 	if (sd->s_parent) {
 		sysfs_pathname(sd->s_parent, path);
