Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505Ab2LAUdV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 15:33:21 -0500
Received: from mailserver6.natinst.com ([130.164.80.6]:42524 "EHLO
	spamkiller06.natinst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898Ab2LAUdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 15:33:19 -0500
Date: Sat, 1 Dec 2012 14:33:13 -0600
From: Josh Cartwright <josh.cartwright@ni.com>
To: Philip Balister <philip@balister.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>,
        Eli Billauer <eli.billauer@gmail.com>, linux-kernel@vger.kernel.org,
        Pavel Machek <pavel@denx.de>, John Linn <john.linn@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        "Ira W. Snyder" <iws@ovro.caltech.edu>
Subject: Re: [PATCH 2/2] New driver: Xillybus generic interface for FPGA
 (programmable logic)
Message-ID: <20121201203313.GO1718@beefymiracle.amer.corp.natinst.com>
References: <1354117293-13632-1-git-send-email-eli.billauer@gmail.com>
 <1354117293-13632-2-git-send-email-eli.billauer@gmail.com>
 <201211301728.48008.arnd@arndb.de>
 <20121130173644.GA9841@kroah.com>
 <50B97734.3090207@balister.org>
 <20121201165612.GG3113@kroah.com>
 <50BA5AEF.3010109@balister.org>
MIME-Version: 1.0
In-Reply-To: <50BA5AEF.3010109@balister.org>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-MIMETrack: Itemize by SMTP Server on MailServ59-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 12/01/2012 02:33:06 PM,
	Serialize by Router on MailServ59-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 12/01/2012 02:33:06 PM,
	Serialize complete at 12/01/2012 02:33:06 PM
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ON0CT8LY+wgE1XqS"
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8185,1.0.431,0.0.0000
 definitions=2012-12-01_01:2012-11-30,2012-12-01,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ON0CT8LY+wgE1XqS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Dec 01, 2012 at 11:30:55AM -0800, Philip Balister wrote:
> On 12/01/2012 08:56 AM, Greg KH wrote:
> >On Fri, Nov 30, 2012 at 07:19:16PM -0800, Philip Balister wrote:
[..]
> >
> >>I've been engaged in design discussions today with my customer. Our
> >>target is the Xilinx Zynq hardware. The first pass at a driver
> >>focuses on creating the minimal amount of code in the kernel doing
> >>most of the logic in user space. So the driver code allocates a
> >>large chunk of RAM for the FPGA to read/write to, provides a mmap
> >>function so user space can see this RAM, also mmaps in the address
> >>space of an AXI slave so the user space can control the logic. This
> >>approach has no dependencies on what is loaded into the fpga.
> >
> >Would a simple UIO driver work best for this type of arrangement?  Then
> >those types of hardware wouldn't even need to mess with a fpga-type
> >interface.
>
> It is very close to a UIO approach. My key problem I am trying to solve is
> getting a "large" buffer space for the driver and a way to communicate the
> physical address and size of the buffer to the fpga. The fpga has several
> ports that allow it to directly read/write RAM, but it needs to know
> physical addresses.
>
> >>This is a very different approach then the Xillybus driver, but
> >>should also be useful to a large class of people. Hopefully, we can
> >>converge on a set of useful drivers, and not end up with a million
> >>drivers all based on custom fpga configuration :)
> >
> >Odds are, this should look something like the firmware interface in the
> >end, right?  Userspace dumps a bunch of data to the device, and then
> >needs the driver to toggle some bits somewhere to enable the device.
> >Also, a few control calls like clearing the device, and other minor
> >things should be all that is needed, right?
> >
>
> For zynq, there is an out of tree ( :) ) driver that handles the firmware
> loading. This is an independent problem.
>
> >So, in the grand tradition of, "The first one there wins", why not base
> >it all off of your driver, and how that works, and we can go from there :)
>
> I do not think there will be any one driver that will work for all use cases
> due to the variety of devices that can be implemented in the fpga.

I see this working such that each IP block/independent logic unit in the
FPGA bitfile would be reified as an independent device to the kernel,
perhaps as a child of an 'fpga' bus (or similar).  These devices would
have their own drivers, and would come and go as the logic is
reprogrammed.

This is really useful if you're taking and integrating IP that exposes a
known interface with existing in-kernel Linux drivers.  Think a soft
Ethernet MAC IP or a 16550 or something.

For more application specific things, or lower level/less defined IO
like you described, an instance of a UIO driver might fit well.
(Anything more complicated then simple register accesses or interrupts
might require something more.)

The key point here is that there is a need for a common reprogrammable
logic subsystem that provides an abstraction over the various
reprogrammable logic devices and exposes a common user interfaces for
download and configuration.

This user interface would need to encompass a way to hand the kernel a
blob and a description of the IP contained within.  Grant's recent
dynamic device tree work seems like would be a great fit for this (and
infact, I believe this use case was explicitly listed as a userstory).

  Josh

--ON0CT8LY+wgE1XqS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQummJAAoJEEef0niEbw+lNokP/2T4IWj2bBaoaObVHwZ6OudP
iL3dyqr9t1k9qUsga35xN5PJZphADScHM1cyj/dmnswexgefaVcp/+MtTULh2Pjw
iqkeJWe8To5U+2t6d1p8ICVon7hBMvGNSL6K57W64dok/RsDP7FRDFABtTajGkU2
SeJS7fVAg9Rpca3Mtp3JhLdZptIieatrqfcbw5gYZcO1Dh5P7vTbL3M+NY6uus6w
jsjeFcG09RbRcGN/4S5FxzARR80YHQ4VfRmHFDoqvEki74IS8hy99WSbTN2/KFiS
7Mdz5ja4ar9Vlw2+Sevyd8BCutSHH2TE9YnEfg1SlwHmVmWv8Je8TRPprLO7ZcWt
6Xa9EYTdx5PAt1PxfRZKKLvTHP/hl/rHevhwNrzG0I8KqjOaBTYJ3KPKA6nCQp86
VlkXVMEpz1yD1JtyBb87Z0r83C+5YLlzt1/50rxn+m64yzoSxe5o/u537ulljHqJ
mUWtNPKiTUeQ23AOM53Hvf/1bGBniGMzNCUuj1ROsRMHzVjDY9NXF8/+9uDBnVAM
MH4u6cuwLjbDa5L0yuFw5LIGdn3R8PeORMFH9FUY4SLkt3yUGxYGFTURYlmYhOCQ
+2i3FKJMNUQLB26T+ojFnVF/AuQtJA7oWuX1JUVkuo9q+IINbgFqbv12N37KNvpm
fdEoQccvjuRf8+rjLoT3
=I3Tg
-----END PGP SIGNATURE-----

--ON0CT8LY+wgE1XqS--
