Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566Ab0FNRfM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 13:35:12 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:33968 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756544Ab0FNRfJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 13:35:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=ckD2VXr+BCsayB6td6T2Uh164R01v7Wb8ci0XVKIBpbRECggZs4IneB9bDavo6dQt9
         ymY3mGNQ86Yn4Q3lOk+QgKXNZ3Rb1FblB8foUx/ZpaWjKN9CbmZ8x/jTBtGERBFxDMc2
         j2pNj5Y/WlojbXDJezX3QBc9pzj/7Y5VTF3rQ=
MIME-Version: 1.0
Date: Tue, 15 Jun 2010 01:35:08 +0800
Message-ID: <AANLkTikEq4f068aZxqWkrTjh85r0j0EqDpFLc1oH8i7t@mail.gmail.com>
Subject: [PATCH] vfs: Use defined macro(like BITPS_PER_BYTE) in fs/file.c
From: Liu Aleaxander <aleaxander@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use defined macro(like BITPS_PER_BYTE) instead of some const number(like 8)
in fs/file.c. So, replace 8 with BITS_PER_BYTE, 8 * sizeof(long) with
BITS_PER_LONG in file fs/file.c. Since the two macro are defined, so use them.

Signed-off-by: Liu Aleaxander <Aleaxander@gmail.com>
---
 fs/file.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index 34bb7f7..f4d3d2c 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -278,11 +278,11 @@ static int count_open_files(struct fdtable *fdt)
        int i;

        /* Find the last open fd */
-       for (i = size/(8*sizeof(long)); i > 0; ) {
+       for (i = size/BITS_PER_LONG; i > 0; ) {
                if (fdt->open_fds->fds_bits[--i])
                        break;
        }
-       i = (i+1) * 8 * sizeof(long);
+       i = (i+1) * BITS_PER_LONG;
        return i;
 }

@@ -360,9 +360,9 @@ struct files_struct *dup_fd(struct files_struct
*oldf, int *errorp)
        new_fds = new_fdt->fd;

        memcpy(new_fdt->open_fds->fds_bits,
-               old_fdt->open_fds->fds_bits, open_files/8);
+               old_fdt->open_fds->fds_bits, open_files/BITS_PER_BYTE);
        memcpy(new_fdt->close_on_exec->fds_bits,
-               old_fdt->close_on_exec->fds_bits, open_files/8);
+               old_fdt->close_on_exec->fds_bits, open_files/BITS_PER_BYTE);

        for (i = open_files; i != 0; i--) {
                struct file *f = *old_fds++;
@@ -388,8 +388,8 @@ struct files_struct *dup_fd(struct files_struct
*oldf, int *errorp)
        memset(new_fds, 0, size);

        if (new_fdt->max_fds > open_files) {
-               int left = (new_fdt->max_fds-open_files)/8;
-               int start = open_files / (8 * sizeof(unsigned long));
+               int left = (new_fdt->max_fds-open_files)/BITS_PER_BYTE;
+               int start = open_files / BITS_PER_LONG;

                memset(&new_fdt->open_fds->fds_bits[start], 0, left);
                memset(&new_fdt->close_on_exec->fds_bits[start], 0, left);
--
1.7.0.1
        new_fds = new_fdt->fd;

        memcpy(new_fdt->open_fds->fds_bits,
-               old_fdt->open_fds->fds_bits, open_files/8);
+               old_fdt->open_fds->fds_bits, open_files/BITS_PER_BYTE);
        memcpy(new_fdt->close_on_exec->fds_bits,
-               old_fdt->close_on_exec->fds_bits, open_files/8);
+               old_fdt->close_on_exec->fds_bits, open_files/BITS_PER_BYTE);

        for (i = open_files; i != 0; i--) {
                struct file *f = *old_fds++;
@@ -388,8 +388,8 @@ struct files_struct *dup_fd(struct files_struct
*oldf, int *errorp)
        memset(new_fds, 0, size);

        if (new_fdt->max_fds > open_files) {
-               int left = (new_fdt->max_fds-open_files)/8;
-               int start = open_files / (8 * sizeof(unsigned long));
+               int left = (new_fdt->max_fds-open_files)/BITS_PER_BYTE;
+               int start = open_files / BITS_PER_LONG;

                memset(&new_fdt->open_fds->fds_bits[start], 0, left);
                memset(&new_fdt->close_on_exec->fds_bits[start], 0, left);
--
1.7.0.1


--
Thanks & regards
Liu Aleaxander
