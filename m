Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759197Ab1FARiG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 13:38:06 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:55849 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758341Ab1FARiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 13:38:04 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Andy Lutomirski <luto@MIT.EDU>
Cc: Ingo Molnar <mingo@elte.hu>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>, Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v3 10/10] x86-64: Add CONFIG_UNSAFE_VSYSCALLS to feature-removal-schedule
In-Reply-To: Your message of "Tue, 31 May 2011 09:16:04 EDT."
             <7e604b2dd699a30204fda3d1011f3af5a2c56572.1306847455.git.luto@mit.edu>
From: Valdis.Kletnieks@vt.edu
References: <cover.1306847455.git.luto@mit.edu> <cover.1306847455.git.luto@mit.edu>
            <7e604b2dd699a30204fda3d1011f3af5a2c56572.1306847455.git.luto@mit.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1306949732_2661P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 01 Jun 2011 13:35:32 -0400
Message-ID: <10442.1306949732@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020206.4DE67868.0105,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1306949732_2661P
Content-Type: text/plain; charset="us-ascii"
Content-Id: <10436.1306949731.1@turing-police.cc.vt.edu>

On Tue, 31 May 2011 09:16:04 EDT, Andy Lutomirski said:

> +What:	CONFIG_UNSAFE_VSYSCALLS (x86_64)

Wow. I went nuts trying to find where this was because I couldn't find it in
Linus's tree I pulled a little while ago, before I realized you added it in patch 8
and deprecated it in patch 10.

Speaking of which:

+	  On a system with recent enough glibc (probably 2.14 or
+	  newer) and no static binaries, you can say N without a
+	  performance penalty to improve security

So I checked my laptop (Fedora 16 Rawhide), and found a bunch of static binaries. The ones
that look like people may care:

# file /sbin/* | grep statically
/sbin/grub:                ELF 32-bit LSB executable, Intel 80386, version 1 (GNU/Linux), statically linked, for GNU/Linux 2.6.18, stripped
/sbin/insmod.static:       ELF 64-bit LSB executable, x86-64, version 1 (GNU/Linux), statically linked, for GNU/Linux 2.6.32, stripped
/sbin/ldconfig:            ELF 64-bit LSB executable, x86-64, version 1 (GNU/Linux), statically linked, for GNU/Linux 2.6.32, stripped
/sbin/sln:                 ELF 64-bit LSB executable, x86-64, version 1 (GNU/Linux), statically linked, for GNU/Linux 2.6.32, stripped

Might be a challenge to get rid of them though.  Unless we don't care anymore
about "use a statically linked ldconfig to fix a corrupted ls.so.cache" and
"reboot from a rescue disk" the only choice.  I think the insmod.static ends up
getting used in initrds to get the root filesystem mounted, we may care about
that as well.. ;)


--==_Exmh_1306949732_2661P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFN5nhkcC3lWbTT17ARApHhAJ42w0UdlIQYP46KGBo65LDZywpjGQCgpjyM
7lx0TyFZtsTCRZZTdpJyEI4=
=AS+k
-----END PGP SIGNATURE-----

--==_Exmh_1306949732_2661P--

