Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156Ab1APPIi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 10:08:38 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40977 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641Ab1APPIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 10:08:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type;
        b=KHpo1rW6oVy7svswIMLZO3iZxo9ZxnBUp95+kWQ4A3GCytrn6xn3PhRVZVSndcw3hQ
         99ZLYdELXOWwdYIuIgOYwDnLVJkBKiBFb8k4sfUgAEds/YjiisTTu6ubVE2IxzWJZWHL
         0vl/0aIez0pbHyeNJtuNF97M/JBTe3gqk9YNI=
MIME-Version: 1.0
From: Hui Zhu <teawater@gmail.com>
Date: Sun, 16 Jan 2011 23:00:55 +0800
Message-ID: <AANLkTin_az45dt=BA38=6N52Qz8X+TyntjWzDo1_73q6@mail.gmail.com>
Subject: [PATCH] Fix smbfs/dir.o build error
To: Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@kernel.dk>,
        Jeff Layton <jlayton@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  CC [M]  drivers/staging/smbfs/dir.o
/home/teawater/kernel/linux-2.6/drivers/staging/smbfs/dir.c:286:
error: static declaration of 'smbfs_dentry_operations' follows
non-static declaration
/home/teawater/kernel/linux-2.6/drivers/staging/smbfs/proto.h:42:
note: previous declaration of 'smbfs_dentry_operations' was here
/home/teawater/kernel/linux-2.6/drivers/staging/smbfs/dir.c:294:
error: static declaration of 'smbfs_dentry_operations_case' follows
non-static declaration
/home/teawater/kernel/linux-2.6/drivers/staging/smbfs/proto.h:41:
note: previous declaration of 'smbfs_dentry_operations_case' was here
make[5]: *** [drivers/staging/smbfs/dir.o] Error 1
make[4]: *** [drivers/staging/smbfs] Error 2
make[3]: *** [drivers/staging] Error 2
make[2]: *** [drivers] Error 2
make[1]: *** [sub-make] Error 2
make: *** [all] Error 2

Not sure it is fixed or not.

Thanks,
Hui

Signed-off-by: Hui Zhu <teawater@gmail.com>
---
 drivers/staging/smbfs/dir.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/staging/smbfs/dir.c
+++ b/drivers/staging/smbfs/dir.c
@@ -283,7 +283,7 @@ static int smb_compare_dentry(const stru
 		unsigned int, const char *, const struct qstr *);
 static int smb_delete_dentry(const struct dentry *);

-static const struct dentry_operations smbfs_dentry_operations =
+const struct dentry_operations smbfs_dentry_operations =
 {
 	.d_revalidate	= smb_lookup_validate,
 	.d_hash		= smb_hash_dentry,
@@ -291,7 +291,7 @@ static const struct dentry_operations sm
 	.d_delete	= smb_delete_dentry,
 };

-static const struct dentry_operations smbfs_dentry_operations_case =
+const struct dentry_operations smbfs_dentry_operations_case =
 {
 	.d_revalidate	= smb_lookup_validate,
 	.d_delete	= smb_delete_dentry,
