Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758912Ab0KPANi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 19:13:38 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:47592 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906Ab0KPANh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 19:13:37 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Jesper Juhl <jj@chaosbits.net>
Cc: David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ying Han <yinghan@google.com>,
        Bodo Eggert <7eggert@web.de>, Mandeep Singh Baines <msb@google.com>,
        "Figo.zhang" <figo1802@gmail.com>
Subject: Re: [PATCH] Revert oom rewrite series
In-Reply-To: Your message of "Tue, 16 Nov 2010 00:31:00 +0100."
             <alpine.LNX.2.00.1011160027180.22346@swampdragon.chaosbits.net>
From: Valdis.Kletnieks@vt.edu
References: <20101115093410.BEFD.A69D9226@jp.fujitsu.com> <20101114181905.bc5b44f9.akpm@linux-foundation.org> <20101115113238.BF06.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1011150215460.2986@chino.kir.corp.google.com>
            <alpine.LNX.2.00.1011160027180.22346@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1289866395_8661P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 15 Nov 2010 19:13:15 -0500
Message-ID: <34565.1289866395@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020203.4CE1CC9C.003B,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1289866395_8661P
Content-Type: text/plain; charset=us-ascii

On Tue, 16 Nov 2010 00:31:00 +0100, Jesper Juhl said:

> I'm not going into the debate about whether or not deprecating one tunable 
> for two years is sufficient or not. I'm simply going to mention one app 
> that I know of that needs to be converted to use "oom_score_adj" on my 
> box :
> 
> [jj@dragon ~]$ uname -a
> Linux dragon 2.6.37-rc1-ARCH-00542-g0143832-dirty #1 SMP PREEMPT Mon Nov 15 2
2:01:52 CET 2010 x86_64 Intel(R) Core(TM)2 Duo CPU T7250 @ 2.00GHz GenuineIntel
 GNU/Linux
> [jj@dragon ~]$ dmesg | grep oom_adj
> start_kdeinit (1502): /proc/1502/oom_adj is deprecated, please use /proc/1502/oom_score_adj instead.

Make that 2 common apps:

% uname -a
Linux turing-police.cc.vt.edu 2.6.37-rc1-mmotm1109 #1 SMP PREEMPT Wed Nov 10 12:30:17 EST 2010 x86_64 x86_64 x86_64 GNU/Linux
% dmesg | grep oom
[   89.981594] sshd (4168): /proc/4168/oom_adj is deprecated, please use /proc/4168/oom_score_adj instead.
% rpm -q openssh
openssh-5.6p1-16.fc15.x86_64

5.6p1 is the latest-n-greatest released version on www.openssh.org, so somebody
probably needs to rattle their chain...


--==_Exmh_1289866395_8661P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFM4cybcC3lWbTT17ARAgvpAKDA4qNHzd+rW+lL0QnyNttHjrPSwACbBn4A
ThbMiToqcKK/E/jKjMwAWa8=
=3BoW
-----END PGP SIGNATURE-----

--==_Exmh_1289866395_8661P--

