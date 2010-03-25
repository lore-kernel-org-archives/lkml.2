Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793Ab0CYQqR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 12:46:17 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:54065 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967Ab0CYQqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 12:46:15 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: mmotm 2010-03-23 - IPv6 warnings...
In-Reply-To: Your message of "Wed, 24 Mar 2010 18:42:26 EDT."
             <20100324184226.3bf42d8f.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <201003232301.o2NN1bms031050@imap1.linux-foundation.org> <12096.1269481001@localhost>
            <20100324184226.3bf42d8f.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1269535530_3923P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 25 Mar 2010 12:45:30 -0400
Message-ID: <4788.1269535530@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail: UCE(50)
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=50/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=bulk(0),
	refid=str=0001.0A020202.4BAB9332.01C8,ss=3,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1269535530_3923P
Content-Type: text/plain; charset=us-ascii

On Wed, 24 Mar 2010 18:42:26 EDT, Andrew Morton said:
> On Wed, 24 Mar 2010 21:36:41 -0400 Valdis.Kletnieks@vt.edu wrote:
> 
> > On Tue, 23 Mar 2010 15:34:59 PDT, akpm@linux-foundation.org said:
> > > The mm-of-the-moment snapshot 2010-03-23-15-34 has been uploaded to
> > > 
> > >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > Seen in my dmesg.  It may be relevant that I'm at home, and my IPv6
> > prefix arrives via a PPP VPN connection. This happened about 20-25 seconds
> > after I launched pppd.
> 
> Yes, thanks, I get the same - it doesn't seem to break anything.  It
> also happens some time after boot has completed.

Just doing an 'ifup eth0' on a network with IPv6 on it is sufficient.

And it does break stuff:

% ifconfig eth0
eth0      Link encap:Ethernet  HWaddr 00:24:E8:C6:AD:17  
          inet addr:128.173.14.107  Bcast:128.173.15.255  Mask:255.255.252.0
          inet6 addr: fe80::224:e8ff:fec6:ad17/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1

With 2.6.34-rc1-mmotm0309, I see:

% ifconfig eth0
eth0      Link encap:Ethernet  HWaddr 00:24:E8:C6:AD:17  
          inet addr:128.173.14.107  Bcast:128.173.15.255  Mask:255.255.252.0
          inet6 addr: 2001:468:c80:2103:224:e8ff:fec6:ad17/64 Scope:Global
          inet6 addr: fe80::224:e8ff:fec6:ad17/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1

Something ate my IPv6 address.  We run a lot of IPv6 in production, so stuff
is acting wonky.



--==_Exmh_1269535530_3923P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLq5MqcC3lWbTT17ARAtBFAJ9A4+be940OdkBcHV2GMPkZcbvcsQCfVHkf
hRF8cPitJhxdSO45oNVnnnA=
=xB9H
-----END PGP SIGNATURE-----

--==_Exmh_1269535530_3923P--

