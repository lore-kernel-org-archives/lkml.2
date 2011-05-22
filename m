Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351Ab1EVLYy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 07:24:54 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62436 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858Ab1EVLYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 07:24:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=ECN7swQkZfQsMs2qK4MrNUjIv8YQqBIJnbSAl3hBuxYrfrmrR+R+taDElUSNmtWyAN
         RH5eS51PuNGCshCiNxZC0Ci/j3+KmCFDP1CpX+14mCrvxSuKJbkRsSC0ejRj/BoldVzJ
         jo3XI/fx9iJT+c0KmmC+v3EK+rLLAkGJf94bQ=
MIME-Version: 1.0
Date: Sun, 22 May 2011 19:24:47 +0800
Message-ID: <BANLkTin4p+bjYPw9TYeqFpUXPDByZNd9GQ@mail.gmail.com>
Subject: [Patch] cris: fix a build error in kernel/fork.c
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: linux-cris-kernel@axis.com, LKML <linux-kernel@vger.kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Mikael Starvik <starvik@axis.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: multipart/mixed; boundary=20cf303b426d3fb18304a3db9af2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--20cf303b426d3fb18304a3db9af2
Content-Type: text/plain; charset=UTF-8

On cris we got a build error,

kernel/fork.c:267: error: implicit declaration of function
'alloc_thread_info_node'

this is due to that we renamed alloc_thread_info() to alloc_thread_info_node().

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>

---

--20cf303b426d3fb18304a3db9af2
Content-Type: text/x-patch; charset=US-ASCII; 
	name="cris-fix-alloc_thread_info_node-build-error.diff"
Content-Disposition: attachment; 
	filename="cris-fix-alloc_thread_info_node-build-error.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gnzwc1dh0

ZGlmZiAtLWdpdCBhL2FyY2gvY3Jpcy9pbmNsdWRlL2FzbS90aHJlYWRfaW5mby5oIGIvYXJjaC9j
cmlzL2luY2x1ZGUvYXNtL3RocmVhZF9pbmZvLmgKaW5kZXggMjliNzRhMS4uZDVhN2I0ZiAxMDA2
NDQKLS0tIGEvYXJjaC9jcmlzL2luY2x1ZGUvYXNtL3RocmVhZF9pbmZvLmgKKysrIGIvYXJjaC9j
cmlzL2luY2x1ZGUvYXNtL3RocmVhZF9pbmZvLmgKQEAgLTExLDggKzExLDYgQEAKIAogI2lmZGVm
IF9fS0VSTkVMX18KIAotI2RlZmluZSBfX0hBVkVfQVJDSF9USFJFQURfSU5GT19BTExPQ0FUT1IK
LQogI2lmbmRlZiBfX0FTU0VNQkxZX18KICNpbmNsdWRlIDxhc20vdHlwZXMuaD4KICNpbmNsdWRl
IDxhc20vcHJvY2Vzc29yLmg+CkBAIC02Nyw4ICs2NSw5IEBAIHN0cnVjdCB0aHJlYWRfaW5mbyB7
CiAKICNkZWZpbmUgaW5pdF90aHJlYWRfaW5mbwkoaW5pdF90aHJlYWRfdW5pb24udGhyZWFkX2lu
Zm8pCiAKKyNkZWZpbmUgX19IQVZFX0FSQ0hfVEhSRUFEX0lORk9fQUxMT0NBVE9SCiAvKiB0aHJl
YWQgaW5mb3JtYXRpb24gYWxsb2NhdGlvbiAqLwotI2RlZmluZSBhbGxvY190aHJlYWRfaW5mbyh0
c2ssIG5vZGUpICgoc3RydWN0IHRocmVhZF9pbmZvICopIF9fZ2V0X2ZyZWVfcGFnZXMoR0ZQX0tF
Uk5FTCwxKSkKKyNkZWZpbmUgYWxsb2NfdGhyZWFkX2luZm9fbm9kZSh0c2ssIG5vZGUpICgoc3Ry
dWN0IHRocmVhZF9pbmZvICopIF9fZ2V0X2ZyZWVfcGFnZXMoR0ZQX0tFUk5FTCwxKSkKICNkZWZp
bmUgZnJlZV90aHJlYWRfaW5mbyh0aSkgZnJlZV9wYWdlcygodW5zaWduZWQgbG9uZykgKHRpKSwg
MSkKIAogI2VuZGlmIC8qICFfX0FTU0VNQkxZX18gKi8K
--20cf303b426d3fb18304a3db9af2--
