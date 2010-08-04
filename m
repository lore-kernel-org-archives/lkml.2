Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758310Ab0HDGTx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 02:19:53 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:40837 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758256Ab0HDGTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 02:19:51 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: hch@infradead.org, jmorris@namei.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        viro@ftp.linux.org.uk, kees.cook@canonical.com
Subject: Re: Preview of changes to the Security susbystem for 2.6.36
In-Reply-To: Your message of "Wed, 04 Aug 2010 12:54:32 +0900."
             <201008040354.o743sWTv078792@www262.sakura.ne.jp>
From: Valdis.Kletnieks@vt.edu
References: <alpine.LRH.2.00.1007301852110.14431@tundra.namei.org> <alpine.LRH.2.00.1008021216520.31941@tundra.namei.org> <20100802122421.GA12130@infradead.org> <20100802165936.GV3948@outflux.net> <15424.1280775073@localhost> <20100803165010.GG3948@outflux.net> <78690.1280871500@localhost>
            <201008040354.o743sWTv078792@www262.sakura.ne.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1280902716_3897P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 04 Aug 2010 02:18:36 -0400
Message-ID: <5029.1280902716@localhost>
X-Mirapoint-Received-SPF: 128.173.34.103 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020209.4C59063D.00FE,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1280902716_3897P
Content-Type: text/plain; charset=us-ascii

On Wed, 04 Aug 2010 12:54:32 +0900, Tetsuo Handa said:

> # killall -KILL sshd
> # /usr/sbin/sshd -o 'Banner /etc/shadow'
> # ssh localhost

I am unable to replicate this behavior on my system with SELinux set to
enforcing mode.  However, it does happen (which is to be expected) when SELinux
is set to permissive mode.

% rpm -q openssh selinux-policy-mls
openssh-5.5p1-18.fc14.x86_64
selinux-policy-mls-3.8.8-8.fc14.noarch

Tested by by trying both /etc/issue and /etc/shadow as banner files - in permissive
mode, both files would be displayed. In enforcing mode, /etc/issue would show
up and /etc/shadow would not.  In addition, checking of the actual policy
source for ssh shows no entry for auth_read_shadow() for sshd_t, although it is
present for many other systemd daemons that have a need to read it. So in
enforcing mode, there's no rule allowing sshd to open /etc/shadow, so it won't
open.

Are you sure you weren't running in permissive mode when you tested this?


--==_Exmh_1280902716_3897P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMWQY8cC3lWbTT17ARAunVAKCEMULOlkb3JNCmJzR1r7u1/6xlzwCg28Za
tfqpTgfl2E9Ym3SiDBWfb+w=
=1hVx
-----END PGP SIGNATURE-----

--==_Exmh_1280902716_3897P--

