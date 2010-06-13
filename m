Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab0FMUpn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 16:45:43 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:35172 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430Ab0FMUpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 16:45:42 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] Really lazy fpu
In-Reply-To: Your message of "Sun, 13 Jun 2010 18:03:43 +0300."
             <1276441427-31514-1-git-send-email-avi@redhat.com>
From: Valdis.Kletnieks@vt.edu
References: <1276441427-31514-1-git-send-email-avi@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1276461922_18203P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 13 Jun 2010 16:45:22 -0400
Message-ID: <39727.1276461922@localhost>
X-Mirapoint-Received-SPF: 128.173.34.98 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020207.4C154364.0086,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1276461922_18203P
Content-Type: text/plain; charset=us-ascii

On Sun, 13 Jun 2010 18:03:43 +0300, Avi Kivity said:
> Currently fpu management is only lazy in one direction.  When we switch into
> a task, we may avoid loading the fpu state in the hope that the task will
> never use it.  If we guess right we save an fpu load/save cycle; if not,
> a Device not Available exception will remind us to load the fpu.
> 
> However, in the other direction, fpu management is eager.  When we switch out
> of an fpu-using task, we always save its fpu state.

Does anybody have numbers on how many clocks it takes a modern CPU design
to do a FPU state save or restore?  I know it must have been painful in the
days before cache memory, having to make added trips out to RAM for 128-bit
registers.  But what's the impact today? (Yes, I see there's the potential
for a painful IPI call - anything else?)

Do we have any numbers on how many saves/restores this will save us when
running the hypothetical "standard Gnome desktop" environment?  How common
is the "we went all the way around to the original single FPU-using task" case?

--==_Exmh_1276461922_18203P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMFUNicC3lWbTT17ARApeGAJ4jL3ssObs3FStfyIfhawfKSKy4igCdGgwS
QOPrCIyRHS7q5vKi8X0jzBA=
=Z1It
-----END PGP SIGNATURE-----

--==_Exmh_1276461922_18203P--

