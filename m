Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932833Ab1IBAta (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 20:49:30 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:46575 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932747Ab1IBAt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 20:49:27 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Jiri Slaby <jirislaby@gmail.com>
Cc: tim.c.chen@linux.intel.com, "David S. Miller" <davem@davemloft.net>,
        ML netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [next] unix stream crashes
In-Reply-To: Your message of "Thu, 01 Sep 2011 22:46:32 +0200."
             <4E5FEF28.60406@gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <4E5FEF28.60406@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1314924559_3073P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 01 Sep 2011 20:49:19 -0400
Message-ID: <3179.1314924559@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A02020A.4E602813.0071,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1314924559_3073P
Content-Type: text/plain; charset=us-ascii

On Thu, 01 Sep 2011 22:46:32 +0200, Jiri Slaby said:
> Hi,
> 
> my box 100% crashes when booting. It's both in unix socket recv and send 
> paths. I've reverted 0856a30409 (Scm: Remove unnecessary pid & 
> credential references in Unix socket's send and receive path) and it 
> seems to help.
> 
> The oops:
> http://www.fi.muni.cz/~xslaby/sklad/panics/af_unix_crash.png

I was seeing a 100% repeatable crash with the X server starting as well, but
wasn't able to get a traceback because my X server was doing the modeset before
it crashed (so all I got was a black screen) and netconsole is busticated for
me.  I can confirm that reverting that one commit allows my box to boot and get
X up and running as well.


--==_Exmh_1314924559_3073P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOYCgPcC3lWbTT17ARAmDBAKDUhUb6Lcsk2lG9y3YzY+ElVp12bQCg4C/j
0U1hhZYPxQ4/8cRVZJGZgow=
=TRzo
-----END PGP SIGNATURE-----

--==_Exmh_1314924559_3073P--

