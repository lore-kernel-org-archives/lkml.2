Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575Ab0HJG0J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 02:26:09 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57612 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab0HJG0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 02:26:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=tKYfhT0NQGY8NmdV+xj3dxwsOUobnpDM/zbnsY9s3b6QzpcfeSF+vuFDcEA3kDYK44
         JdVjaMoPLP2pJjEMBTEVW+AqMfhkv5UUEohqrgbsakZI/7PxqJDHGIUyhNz4s4mAChjv
         E5glb1LxCM8uoSMM5HC7wkLUlBpqm/OcGgIqM=
MIME-Version: 1.0
Date: Tue, 10 Aug 2010 14:26:01 +0800
Message-ID: <AANLkTinU1jzHEwgQScFxt=a0MBSUsMXuYJwkwKocJP6D@mail.gmail.com>
Subject: Compilation errors on latest git tree
From: Peter Teoh <htmldeveloper@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=0016e6d99b5f01cc3e048d7235ac
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e6d99b5f01cc3e048d7235ac
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Got the following compilation errors on the latest linus git tree
(v.2.6.35-6113-gf6cec0a).

  CHK     include/linux/version.h
  CHK     include/generated/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CHK     include/generated/compile.h
  VDSOSYM arch/x86/vdso/vdso32-int80-syms.lds
  VDSOSYM arch/x86/vdso/vdso32-sysenter-syms.lds
  VDSOSYM arch/x86/vdso/vdso32-syms.lds
  LD      arch/x86/vdso/built-in.o
  LD      arch/x86/built-in.o
  CC [M]  drivers/net/wireless/libertas/cfg.o
drivers/net/wireless/libertas/cfg.c: In function =91lbs_scan_worker=92:
drivers/net/wireless/libertas/cfg.c:722: error: =91TASK_NORMAL=92
undeclared (first use in this function)
drivers/net/wireless/libertas/cfg.c:722: error: (Each undeclared
identifier is reported only once
drivers/net/wireless/libertas/cfg.c:722: error: for each function it
appears in.)
drivers/net/wireless/libertas/cfg.c: In function =91lbs_cfg_connect=92:
drivers/net/wireless/libertas/cfg.c:1267: error: =91TASK_INTERRUPTIBLE=92
undeclared (first use in this function)
drivers/net/wireless/libertas/cfg.c:1267: error: implicit declaration
of function =91signal_pending=92
drivers/net/wireless/libertas/cfg.c:1267: error: implicit declaration
of function =91schedule_timeout=92
make[4]: *** [drivers/net/wireless/libertas/cfg.o] Error 1
make[3]: *** [drivers/net/wireless/libertas] Error 2
make[2]: *** [drivers/net/wireless] Error 2
make[1]: *** [drivers/net] Error 2
make: *** [drivers] Error 2

It as resolved via the attached patch.   You may want to change the
way I patch it.   Thanks.



--=20
Regards,
Peter Teoh

--0016e6d99b5f01cc3e048d7235ac
Content-Type: text/x-patch; charset=US-ASCII; name="libertas.patch"
Content-Disposition: attachment; filename="libertas.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gcod8wug0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2xpYmVydGFzL2NmZy5jIGIvZHJpdmVy
cy9uZXQvd2lyZWxlc3MvbGliZXJ0YXMvY2ZnLmMKaW5kZXggOGU5ZmJmZC4uNTFhOTZmNSAxMDA2
NDQKLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvbGliZXJ0YXMvY2ZnLmMKKysrIGIvZHJpdmVy
cy9uZXQvd2lyZWxlc3MvbGliZXJ0YXMvY2ZnLmMKQEAgLTcsNiArNyw3IEBACiAgKi8KIAogI2lu
Y2x1ZGUgPGxpbnV4L3NsYWIuaD4KKyNpbmNsdWRlIDxsaW51eC9zY2hlZC5oPgogI2luY2x1ZGUg
PGxpbnV4L2llZWU4MDIxMS5oPgogI2luY2x1ZGUgPG5ldC9jZmc4MDIxMS5oPgogI2luY2x1ZGUg
PGFzbS91bmFsaWduZWQuaD4K
--0016e6d99b5f01cc3e048d7235ac--
