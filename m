Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760615Ab0KRV0M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 16:26:12 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:36257 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760606Ab0KRV0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 16:26:10 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org
Subject: Re: mmotm 2010-11-17-17-03 uploaded
In-Reply-To: Your message of "Wed, 17 Nov 2010 17:03:30 PST."
             <201011180135.oAI1Znl3017273@imap1.linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <201011180135.oAI1Znl3017273@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1290115539_6548P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 18 Nov 2010 16:25:39 -0500
Message-ID: <73121.1290115539@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020206.4CE599D4.0011,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1290115539_6548P
Content-Type: text/plain; charset=us-ascii

On Wed, 17 Nov 2010 17:03:30 PST, akpm@linux-foundation.org said:
> The mm-of-the-moment snapshot 2010-11-17-17-03 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/

Using my current .config and a 'make oldconfig' dies a horrid quick death:

  CHK     include/linux/version.h
  CHK     include/generated/utsrelease.h
  CC      arch/x86/kernel/asm-offsets.s
In file included from /usr/src/linux-2.6.37-rc2-mmotm1117/arch/x86/include/asm/suspend_64.h:10:0,
                 from /usr/src/linux-2.6.37-rc2-mmotm1117/arch/x86/include/asm/suspend.h:4,
                 from arch/x86/kernel/asm-offsets_64.c:20,
                 from arch/x86/kernel/asm-offsets.c:4:
/usr/src/linux-2.6.37-rc2-mmotm1117/arch/x86/include/asm/i387.h: In function 'irq_ts_save':
/usr/src/linux-2.6.37-rc2-mmotm1117/arch/x86/include/asm/i387.h:348:2: error: implicit declaration of function 'kernel_locked'
make[1]: *** [arch/x86/kernel/asm-offsets.s] Error 1
make: *** [prepare0] Error 2

static inline int irq_ts_save(void)
{
        /*
         * If in process context and not atomic, we can take a spurious DNA fault.
         * Otherwise, doing clts() in process context requires disabling preemption
         * or some heavy lifting like kernel_fpu_begin()
         */
        if (!in_atomic())
                return 0;

in_atomic() did me in.  CONFIG_LOCK_KERNEL and CONFIG_BKL are both =y in this build.

Not sure if asm-offsets_64.c needs a #include <smp-locks.h> or if it's something else...

--==_Exmh_1290115539_6548P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFM5ZnTcC3lWbTT17ARAvq7AKCFoCLyyWvV2BM88YGEy9FdvOJtIgCdF42M
XLxCHOOmsLLo9GihX+E0RII=
=+i0B
-----END PGP SIGNATURE-----

--==_Exmh_1290115539_6548P--

