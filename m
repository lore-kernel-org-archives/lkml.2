Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759601Ab1EBOhb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 10:37:31 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:56787 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756136Ab1EBOha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 10:37:30 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: mmotm 2011-04-29 - wonky VmRSS and VmHWM values after swapping
In-Reply-To: Your message of "Sun, 01 May 2011 20:26:54 EDT."
             <49683.1304296014@localhost>
From: Valdis.Kletnieks@vt.edu
References: <201104300002.p3U02Ma2026266@imap1.linux-foundation.org>
            <49683.1304296014@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1304347041_5428P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 02 May 2011 10:37:22 -0400
Message-ID: <8185.1304347042@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A02020A.4DBEC1A4.0002,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1304347041_5428P
Content-Type: text/plain; charset=us-ascii

On Sun, 01 May 2011 20:26:54 EDT, Valdis.Kletnieks@vt.edu said:
> On Fri, 29 Apr 2011 16:26:16 PDT, akpm@linux-foundation.org said:
> > The mm-of-the-moment snapshot 2011-04-29-16-25 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
>  
> Dell Latitude E6500 laptop, Core2 Due P8700, 4G RAM, 2G swap.Z86_64 kernel.
> 
> I was running a backup of the system to an external USB hard drive.

Is a red herring.  Am seeing it again, after only 20 minutes of uptime, and so
far I've only gotten 1.2G or so into the 4G ram (2.5G still free), and never
touched swap yet.

Aha! I have a reproducer (found while composing this note).  /bin/su will
reliably trigger it (4 tries out of 4, launching from a bash shell that itself
has sane VmRSS and VmHWM values).  So it's a specific code sequence doing it
(probably one syscall doing something quirky).

Now if I could figure out how to make strace look at the VmRSS after each
syscall, or get gdb to do similar.  Any suggestions?  Am open to perf/other
solutions as well, if anybody has one handy...


--==_Exmh_1304347041_5428P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNvsGhcC3lWbTT17ARAtCbAKCWm//9w+BymVQxhZnY9g2ApPDh9QCeMGDq
trcg1I8d5c4Kt6lWqewriEE=
=gk5i
-----END PGP SIGNATURE-----

--==_Exmh_1304347041_5428P--

