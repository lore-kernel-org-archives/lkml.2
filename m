Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131Ab1GTSsF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 14:48:05 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:42375 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab1GTSsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 14:48:02 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Wed, 20 Jul 2011 20:48:00 +0200
Message-ID: <CA+icZUVbeLU+zCAC+8wduizn6h5FUE2qzNr0bg9t3yWNbv_6Ng@mail.gmail.com>
Subject: Re: linux-next: Tree for July 20 (overlayfs)
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Randy Dunlap <randy.dunlap@oracle.com>
Content-Type: multipart/mixed; boundary=20cf300fb1bff5d84f04a884ab01
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--20cf300fb1bff5d84f04a884ab01
Content-Type: text/plain; charset=UTF-8

Hi,

I have here a problem with linux-next (next-20110720) and
overlayfs-v10 (not the latest from GIT).

### OVERLAYFS
# Patches from mszeredi/vfs.git#overlayfs.v10 (up to commit
00b27467b181a27c808cef0d66860eba5f450b24)
# "overlay: overlay filesystem documentation"
# See also <http://lkml.org/lkml/2011/6/1/456>
# "[PATCH 0/7] overlay filesystem: request for inclusion"
+ overlayfs-v10/overlayfs-v10.patch

Documentation/filesystems/porting says:

[mandatory]
        ->permission(), generic_permission() and ->check_acl() have lost flags
argument; instead of passing IPERM_FLAG_RCU we add MAY_NOT_BLOCK into mask.
        generic_permission() has also lost the check_acl argument; if you want
non-NULL to be used for that inode, put it into ->i_op->check_acl.

I checked with other files below fs/ and changed accordingly.
So, I hope the attached patch is OK (untested, uncompiled)?

What's the status of OverlayFS anyway, will it be merged into v3.1?

Regards,
- Sedat -

--20cf300fb1bff5d84f04a884ab01
Content-Type: plain/text; name="fs-overlayfs-inode.c.diff"
Content-Disposition: attachment; filename="fs-overlayfs-inode.c.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gqcn8amf0

LS0tIGxpbnV4LW5leHQtMjAxMTA3MjAub3JpZy9mcy9vdmVybGF5ZnMvaW5vZGUuYworKysgbGlu
dXgtbmV4dC0yMDExMDcyMC9mcy9vdmVybGF5ZnMvaW5vZGUuYwpAQCAtNTYsNyArNTYsNyBAQCBp
bnQgb3ZsX3Blcm1pc3Npb24oc3RydWN0IGlub2RlICppbm9kZSwKIAogCWlmIChTX0lTRElSKGlu
b2RlLT5pX21vZGUpKSB7CiAJCW9lID0gaW5vZGUtPmlfcHJpdmF0ZTsKLQl9IGVsc2UgaWYgKGZs
YWdzICYgSVBFUk1fRkxBR19SQ1UpIHsKKwl9IGVsc2UgaWYgKG1hc2sgJiBNQVlfTk9UX0JMT0NL
KSB7CiAJCXJldHVybiAtRUNISUxEOwogCX0gZWxzZSB7CiAJCS8qCkBAIC03OSw3ICs3OSw3IEBA
IGludCBvdmxfcGVybWlzc2lvbihzdHJ1Y3QgaW5vZGUgKmlub2RlLAogCS8qIENhcmVmdWwgaW4g
UkNVIHdhbGsgbW9kZSAqLwogCXJlYWxpbm9kZSA9IEFDQ0VTU19PTkNFKHJlYWxkZW50cnktPmRf
aW5vZGUpOwogCWlmICghcmVhbGlub2RlKSB7Ci0JCVdBUk5fT04oIShmbGFncyAmIElQRVJNX0ZM
QUdfUkNVKSk7CisJCVdBUk5fT04oIShtYXNrICYgTUFZX05PVF9CTE9DSykpOwogCQllcnIgPSAt
RU5PRU5UOwogCQlnb3RvIG91dF9kcHV0OwogCX0K
--20cf300fb1bff5d84f04a884ab01--
