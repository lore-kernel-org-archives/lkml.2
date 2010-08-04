Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030Ab0HDQZK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 12:25:10 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:47434 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab0HDQZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 12:25:05 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: hch@infradead.org, jmorris@namei.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        viro@ftp.linux.org.uk, kees.cook@canonical.com
Subject: Re: Preview of changes to the Security susbystem for 2.6.36
In-Reply-To: Your message of "Wed, 04 Aug 2010 16:00:21 +0900."
             <201008040700.o7470LWi021902@www262.sakura.ne.jp>
From: Valdis.Kletnieks@vt.edu
References: <alpine.LRH.2.00.1007301852110.14431@tundra.namei.org> <alpine.LRH.2.00.1008021216520.31941@tundra.namei.org> <20100802122421.GA12130@infradead.org> <20100802165936.GV3948@outflux.net> <15424.1280775073@localhost> <20100803165010.GG3948@outflux.net> <78690.1280871500@localhost> <201008040354.o743sWTv078792@www262.sakura.ne.jp> <5029.1280902716@localhost>
            <201008040700.o7470LWi021902@www262.sakura.ne.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1280939027_3909P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 04 Aug 2010 12:23:47 -0400
Message-ID: <6936.1280939027@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020204.4C599414.00C3,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1280939027_3909P
Content-Type: text/plain; charset=us-ascii

On Wed, 04 Aug 2010 16:00:21 +0900, Tetsuo Handa said:
> Valdis.Kletnieks@vt.edu wrote:
> > Are you sure you weren't running in permissive mode when you tested this?
> I'm running CentOS5.5 and RHEL6beta in enforcing mode with default configuration
> (TARGETED policy).
> 
> > I am unable to replicate this behavior on my system with SELinux set to
> > enforcing mode.  However, it does happen (which is to be expected) when SELinux
> > is set to permissive mode.
> So, MLS policy can stop this case, can't it? That's fine.

Apparently so.

> But most people is using TARGETED policy, isn't it?
> How do you provide protection to those who don't use MLS policy?

I'll point out that the requirements to even *start* sshd in the MLS policy are
much more stringent - basically, running /usr/sbin/sshd on the command line
doesn't work because it can't transition from your context to the sshd context.
Only init context to sshd is allowed.

More crucially, your "breakage" is actually a non-issue, because under the
targeted policy, launching sshd with a parameter that results in /etc/shadow
being disclosed requires you to be root in pretty much any security context
including unconfined_t - at which point you can access /etc/shadow *anyhow*.
Who the hell actually *cares* that you can go through all the trouble of
restarting sshd and then ssh'ing in to get a copy of a file, when you could
just as easily 'cat /etc/shadow'?

So what you're saying is that SELinux sucks because it doesn't prevent people who
have a legitimate copy of the front door key from climbing in a third floor window.

Remember what I said about having a *model*?  For MLS, the model includes "/etc/
shadow is only accessible to specifically authorized processes".  So care is
taken to close down any and all side doors like asking sshd to do the dirty
work for you.  For the 'targeted' policy, the model is "Only a specified list
of network-facing daemons is confined", and no care is taken to prevent
authorized users from accessing files they already have legitimate access to.


--==_Exmh_1280939027_3909P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMWZQTcC3lWbTT17ARAor9AJoDFBflnLLK+jWmYuAsek1ZDtn35wCbByI2
IM2IxMmdhC7hkNVvyJLiHGw=
=wkah
-----END PGP SIGNATURE-----

--==_Exmh_1280939027_3909P--

