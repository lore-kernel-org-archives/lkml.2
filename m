Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751341Ab1JMAV0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 20:21:26 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:49877 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab1JMAVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 20:21:25 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: "Udo A. Steinberg" <udo@hypervisor.org>, Dave Airlie <airlied@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        iommu@lists.linux-foundation.org,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: Kernel panic with intel_iommu=on
In-Reply-To: Your message of "Wed, 12 Oct 2011 10:19:55 PDT."
             <1318439995.4465.8.camel@nimitz>
From: Valdis.Kletnieks@vt.edu
References: <20110812145818.00cde392@laptop.anywhere.org> <CAPM=9tzwYHgbmKUuPsrW_4nrKOQ5m+7N0JV-kMpOv43yVh-49A@mail.gmail.com> <20110812160846.29fd9149@laptop.anywhere.org>
            <1318439995.4465.8.camel@nimitz>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1318465118_2509P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 12 Oct 2011 20:18:38 -0400
Message-ID: <11892.1318465118@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020206.4E962E61.00B5,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1318465118_2509P
Content-Type: text/plain; charset=us-ascii

On Wed, 12 Oct 2011 10:19:55 PDT, Dave Hansen said:
> I'm seeing this all of a sudden on 3.1 kernels.  It might be because of
> the firefox upgrade to 5.0 that others were talking about.  But, it's
> quite easy to trigger.  Seems to happen in the first 10 minutes of using
> the system.  I was only able to capture this with netconsole.

I was seeing DMAR issues as well, but I figured it was self-inflicted because
it was due to the NVidia binary driver. Rebooted with 'intel_iommu=off' and it
behaved itself.  Basically, I got a flood of messages like these:

Oct 12 17:20:09 turing-police kernel: [  301.401157] DRHD: handling fault status reg 2
Oct 12 17:20:09 turing-police kernel: [  301.401164] DMAR:[DMA Read] Request device [01:00.0] fault addr d5b76000
Oct 12 17:20:09 turing-police kernel: [  301.401166] DMAR:[fault reason 01] Present bit in root entry is clear

Oct 12 17:20:13 turing-police kernel: [  305.615039] DRHD: handling fault status reg 2
Oct 12 17:20:13 turing-police kernel: [  305.615047] DMAR:[DMA Read] Request device [01:00.0] fault addr 110de9000
Oct 12 17:20:13 turing-police kernel: [  305.615048] DMAR:[fault reason 01] Present bit in root entry is clear

Oct 12 17:20:14 turing-police kernel: [  306.056109] DRHD: handling fault status reg 2
Oct 12 17:20:14 turing-police kernel: [  306.056116] DMAR:[DMA Read] Request device [01:00.0] fault addr ca861000
Oct 12 17:20:14 turing-police kernel: [  306.056117] DMAR:[fault reason 01] Present bit in root entry is clear

Oct 12 17:20:14 turing-police kernel: [  306.059950] DRHD: handling fault status reg 2
Oct 12 17:20:14 turing-police kernel: [  306.059959] DMAR:[DMA Read] Request device [01:00.0] fault addr ca861000
Oct 12 17:20:14 turing-police kernel: [  306.059960] DMAR:[fault reason 01] Present bit in root entry is clear

Oct 12 17:20:14 turing-police kernel: [  306.064171] DRHD: handling fault status reg 2
Oct 12 17:20:14 turing-police kernel: [  306.064179] DMAR:[DMA Read] Request device [01:00.0] fault addr ca861000
Oct 12 17:20:14 turing-police kernel: [  306.064180] DMAR:[fault reason 01] Present bit in root entry is clear

If that tells the iommu people something, fine.  If it doesn't, that's OK too, I'll
take it up with NVidia.


--==_Exmh_1318465118_2509P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOli5ecC3lWbTT17ARAq1OAJ0Z2HPcmIo1aDIK9hHxwoB2ajKJ/QCgxCw4
nMZvox7EPVznJ15o/TK6490=
=di0+
-----END PGP SIGNATURE-----

--==_Exmh_1318465118_2509P--

