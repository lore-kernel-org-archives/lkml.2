Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653Ab2JZBDM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 21:03:12 -0400
Received: from mailserver6.natinst.com ([130.164.80.6]:41598 "EHLO
	spamkiller06.natinst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772Ab2JZBDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 21:03:11 -0400
Date: Thu, 25 Oct 2012 20:03:03 -0500
From: Josh Cartwright <josh.cartwright@ni.com>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: arm@kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        John Linn <john.linn@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>
Subject: Re: [PATCH v4 5/5] zynq: move static peripheral mappings
Message-ID: <20121026010303.GA13669@beefymiracle.amer.corp.natinst.com>
References: <20121024200222.GA6713@beefymiracle.amer.corp.natinst.com>
 <20121024200451.GF6713@beefymiracle.amer.corp.natinst.com>
 <20121025201701.GA18217@elliptictech.com>
 <20121025212902.GX20593@beefymiracle.amer.corp.natinst.com>
 <20121025224108.GA30705@elliptictech.com>
MIME-Version: 1.0
In-Reply-To: <20121025224108.GA30705@elliptictech.com>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-MIMETrack: Itemize by SMTP Server on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 10/25/2012 08:02:55 PM,
	Serialize by Router on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 10/25/2012 08:02:55 PM,
	Serialize complete at 10/25/2012 08:02:55 PM
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.431,0.0.0000
 definitions=2012-10-25_06:2012-10-25,2012-10-25,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 25, 2012 at 06:41:08PM -0400, Nick Bowler wrote:
> On 2012-10-25 16:29 -0500, Josh Cartwright wrote:
> > On Thu, Oct 25, 2012 at 04:17:01PM -0400, Nick Bowler wrote:
> > > Did you test this on any real hardware?  I can't get the ZC702 to work
> > > with the UART mapped at this address (this ends up being mapped at
> > > 0xFEFFF000), although I can't for the life of me figure out why the
> > > virtual address even matters.  Note that for the ZC702, the physical
> > > address of the "main" UART is 0xE0001000.

Good news is you're not crazy; I was able to duplicate the problem here.

> If I were to guess, I would guess that, except for when it "Works",
> the really really early printk stuff isn't actually hitting the uart
> at all.  The "Fails" case would then be due to the stray writes
> crashing the board, and the "Truncated" case due to the stray writes
> being (ostensibly) benign.

If I'm not mistaken, this hypothesis is predicated on the early bootup
code establishing a (linear?) mapping for addresses > VMALLOC_START;
before the mdesc->map_io() is even handled.  That seems odd to me.

> But I really have no way right now to test this hypothesis, since I
> can't print anything in the failing case.

Not sure if I'll be able to get anything meaningful out of it yet (I've
not historically had good luck with Xilinx's debugging tools), but I did
finally get a JTAG debugger hooked up to the zc702.  I'll see if I can
get any useful information tomorrow.

Thanks,

  Josh

--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQieFHAAoJEEef0niEbw+lvuQQAIEDtdWvZwZyR7RQjnN58mXE
lzS74jhYbSNx4phcTOdoYz7uTNqSXP11/MBlnRHVJRS01FOG+zMhL54sUH2qyrSl
dgC1EC2sWzbwJ5pDSSKSHpLxX5VBjKXzXNhYLO8fv6wrk+sx6SVCTQb/Hb/k1sij
OGKCywjIHk8j+FxDf36uIdPpgqtJWYyxXgDEFqy+XJnYcVwl2wP6SFBV24MDFNqg
M2vrUh2/Xgb2WYSm9PNmEUpD1fXMgNTOj/u1id/sgnxtU4IgvmXtq/d5GpmiPpn1
XeVMfh90O3foUcdowfNbh8441zwJ97bPaXBGHBVrnqLgt0TSL1G+YsaCL/L3iaJV
0dN+U7l7vYPWLxSCqJRg1wT7YMuAvjTp+yYzWxHGVGg9QrhI5pQrivRtWR1f/r3a
IGw/28oS49Hv2r4rPG/6Hl3qEmSHSHu6iFWzHXHDMnWPbfWaA08GuGLHapzziNZ0
2PKpFTHAf3yr8GasART11p5DcKnD/oFWVlsH6FgXZwlbpURnLyqfFqezW9DpwsAa
8DjjzyMqMI8+hEiyT/wpH09NH0gg1gaMb5ZVGRkZS8K3m9kTEQMJelE9ymKuTtTg
YpWI+Qf6OngzI7sYXnrvb91WgI7lyf+xUFqob+ySFyxvemyeDv3fZySWatT/M71L
mQhLan9xJ0vXg8Bdah/R
=M1HW
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--
