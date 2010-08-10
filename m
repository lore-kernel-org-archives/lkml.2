Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112Ab0HJMwN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 08:52:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45981 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932070Ab0HJMwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 08:52:09 -0400
Date: Tue, 10 Aug 2010 14:52:06 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Peter Teoh <htmldeveloper@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org,
        linville@tuxdriver.com
Subject: Re: Compilation errors on latest git tree
In-Reply-To: <AANLkTinU1jzHEwgQScFxt=a0MBSUsMXuYJwkwKocJP6D@mail.gmail.com>
Message-ID: <alpine.LRH.2.00.1008101450540.2372@twin.jikos.cz>
References: <AANLkTinU1jzHEwgQScFxt=a0MBSUsMXuYJwkwKocJP6D@mail.gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1747641777-669367335-1281444727=:2372"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1747641777-669367335-1281444727=:2372
Content-Type: TEXT/PLAIN; charset=windows-1252
Content-Transfer-Encoding: 8BIT

On Tue, 10 Aug 2010, Peter Teoh wrote:

> Got the following compilation errors on the latest linus git tree
> (v.2.6.35-6113-gf6cec0a).
> 
>   CHK     include/linux/version.h
>   CHK     include/generated/utsrelease.h
>   CALL    scripts/checksyscalls.sh
>   CHK     include/generated/compile.h
>   VDSOSYM arch/x86/vdso/vdso32-int80-syms.lds
>   VDSOSYM arch/x86/vdso/vdso32-sysenter-syms.lds
>   VDSOSYM arch/x86/vdso/vdso32-syms.lds
>   LD      arch/x86/vdso/built-in.o
>   LD      arch/x86/built-in.o
>   CC [M]  drivers/net/wireless/libertas/cfg.o
> drivers/net/wireless/libertas/cfg.c: In function ‘lbs_scan_worker’:
> drivers/net/wireless/libertas/cfg.c:722: error: ‘TASK_NORMAL’
> undeclared (first use in this function)
> drivers/net/wireless/libertas/cfg.c:722: error: (Each undeclared
> identifier is reported only once
> drivers/net/wireless/libertas/cfg.c:722: error: for each function it
> appears in.)
> drivers/net/wireless/libertas/cfg.c: In function ‘lbs_cfg_connect’:
> drivers/net/wireless/libertas/cfg.c:1267: error: ‘TASK_INTERRUPTIBLE’
> undeclared (first use in this function)
> drivers/net/wireless/libertas/cfg.c:1267: error: implicit declaration
> of function ‘signal_pending’
> drivers/net/wireless/libertas/cfg.c:1267: error: implicit declaration
> of function ‘schedule_timeout’
> make[4]: *** [drivers/net/wireless/libertas/cfg.o] Error 1
> make[3]: *** [drivers/net/wireless/libertas] Error 2
> make[2]: *** [drivers/net/wireless] Error 2
> make[1]: *** [drivers/net] Error 2
> make: *** [drivers] Error 2
> 
> It as resolved via the attached patch.   You may want to change the
> way I patch it.   Thanks.

Adding some appropriate CCs.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

---1747641777-669367335-1281444727=:2372
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=libertas.patch
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.LRH.2.00.1008101452060.2372@twin.jikos.cz>
Content-Description: 
Content-Disposition: attachment; filename=libertas.patch

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2xpYmVydGFzL2Nm
Zy5jIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvbGliZXJ0YXMvY2ZnLmMNCmlu
ZGV4IDhlOWZiZmQuLjUxYTk2ZjUgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25l
dC93aXJlbGVzcy9saWJlcnRhcy9jZmcuYw0KKysrIGIvZHJpdmVycy9uZXQv
d2lyZWxlc3MvbGliZXJ0YXMvY2ZnLmMNCkBAIC03LDYgKzcsNyBAQA0KICAq
Lw0KIA0KICNpbmNsdWRlIDxsaW51eC9zbGFiLmg+DQorI2luY2x1ZGUgPGxp
bnV4L3NjaGVkLmg+DQogI2luY2x1ZGUgPGxpbnV4L2llZWU4MDIxMS5oPg0K
ICNpbmNsdWRlIDxuZXQvY2ZnODAyMTEuaD4NCiAjaW5jbHVkZSA8YXNtL3Vu
YWxpZ25lZC5oPg0K

---1747641777-669367335-1281444727=:2372--
