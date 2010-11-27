Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333Ab0K0TUK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 14:20:10 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:45945 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375Ab0K0TUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 14:20:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:content-type;
        b=e37LXLRMhax5IM684wtrtgDv4Y4dOaElMIFo5+v6sY7h2HadI2MNmMchZr1+zdS4GB
         YPTAuULu7ufu/8Ac/XWgybDUcFk+PAjFoTwSxwHjb+QNUjVOcyC0GFHcHdtq/J2E6x/w
         1vECWJHyj5y8XcmLFDaY+a0kuIwfxKSnE70Zc=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Sat, 27 Nov 2010 20:20:01 +0100
Message-ID: <AANLkTi=F_Zteh9Sbxiea=rDj7HGOxYkfu5=Aa71R+ufG@mail.gmail.com>
Subject: Re: [PATCH 00/46] rcu-walk and dcache scaling
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Nick Piggin <npiggin@kernel.dk>, LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=0016368322d4ba9d8b04960db962
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016368322d4ba9d8b04960db962
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

I wanted to give your patchset a try (on top of latest linux-next).

Unfortunately, the build breaks here:

/home/sd/src/linux-2.6/linux-2.6.37-rc3/debian/build/source_i386_none/fs/ci=
fs/inode.c:807:
error: =E2=80=98dcache_inode_lock=E2=80=99 undeclared (first use in this fu=
nction)
/home/sd/src/linux-2.6/linux-2.6.37-rc3/debian/build/source_i386_none/fs/ci=
fs/inode.c:807:
error: (Each undeclared identifier is reported only once
/home/sd/src/linux-2.6/linux-2.6.37-rc3/debian/build/source_i386_none/fs/ci=
fs/inode.c:807:
error: for each function it appears in.)

Attached patch "fs-cifs-inode.c-Fix-error-dcache_inode_lock-undeclared.patc=
h"
should fix it.

Kind Regards,
- Sedat -

Compile-tested-by: me

$ grep cifs build_linux-next_next20101126.dileks.4.log
  LD      fs/cifs/built-in.o
  CC [M]  fs/cifs/cifsfs.o
  CC [M]  fs/cifs/cifssmb.o
  CC [M]  fs/cifs/cifs_debug.o
  CC [M]  fs/cifs/connect.o
  CC [M]  fs/cifs/dir.o
  CC [M]  fs/cifs/file.o
  CC [M]  fs/cifs/inode.o
  CC [M]  fs/cifs/link.o
  CC [M]  fs/cifs/misc.o
  CC [M]  fs/cifs/netmisc.o
  CC [M]  fs/cifs/smbdes.o
  CC [M]  fs/cifs/smbencrypt.o
  CC [M]  fs/cifs/transport.o
  CC [M]  fs/cifs/asn1.o
  CC [M]  fs/cifs/md4.o
  CC [M]  fs/cifs/md5.o
  CC [M]  fs/cifs/cifs_unicode.o
  CC [M]  fs/cifs/nterr.o

--0016368322d4ba9d8b04960db962
Content-Type: plain/text; 
	name="fs-cifs-inode.c-Fix-error-dcache_inode_lock-undeclared.patch"
Content-Disposition: attachment; 
	filename="fs-cifs-inode.c-Fix-error-dcache_inode_lock-undeclared.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gh0voiul0

SW5kZXg6IGxpbnV4LTIuNi9mcy9jaWZzL2lub2RlLmMKPT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQotLS0gbGludXgtMi42
Lm9yaWcvZnMvY2lmcy9pbm9kZS5jCisrKyBsaW51eC0yLjYvZnMvY2lmcy9pbm9kZS5jCkBAIC04
MDQsMTQgKzgwNCwxNCBAQCBpbm9kZV9oYXNfaGFzaGVkX2RlbnRyaWVzKHN0cnVjdCBpbm9kZSAq
CiB7CiAJc3RydWN0IGRlbnRyeSAqZGVudHJ5OwogCi0Jc3Bpbl9sb2NrKCZkY2FjaGVfaW5vZGVf
bG9jayk7CisJc3Bpbl9sb2NrKCZpbm9kZS0+aV9sb2NrKTsKIAlsaXN0X2Zvcl9lYWNoX2VudHJ5
KGRlbnRyeSwgJmlub2RlLT5pX2RlbnRyeSwgZF9hbGlhcykgewogCQlpZiAoIWRfdW5oYXNoZWQo
ZGVudHJ5KSB8fCBJU19ST09UKGRlbnRyeSkpIHsKLQkJCXNwaW5fdW5sb2NrKCZkY2FjaGVfaW5v
ZGVfbG9jayk7CisJCQlzcGluX3VubG9jaygmaW5vZGUtPmlfbG9jayk7CiAJCQlyZXR1cm4gdHJ1
ZTsKIAkJfQogCX0KLQlzcGluX3VubG9jaygmZGNhY2hlX2lub2RlX2xvY2spOworCXNwaW5fdW5s
b2NrKCZpbm9kZS0+aV9sb2NrKTsKIAlyZXR1cm4gZmFsc2U7CiB9CiAK
--0016368322d4ba9d8b04960db962--
