Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128Ab2KGOSA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 09:18:00 -0500
Received: from mailserver5.natinst.com ([130.164.80.5]:54467 "EHLO
	spamkiller05.natinst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab2KGOR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 09:17:59 -0500
Date: Wed, 7 Nov 2012 08:17:59 -0600
From: Josh Cartwright <josh.cartwright@ni.com>
To: Michal Simek <michal.simek@xilinx.com>
Cc: "arm@kernel.org" <arm@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        John Linn <linnj@xilinx.com>, Nick Bowler <nbowler@elliptictech.com>
Subject: Re: [PATCH v4 1/5] zynq: use GIC device tree bindings
Message-ID: <20121107141759.GA1718@beefymiracle.amer.corp.natinst.com>
References: <20121024200222.GA6713@beefymiracle.amer.corp.natinst.com>
 <20121024200310.GB6713@beefymiracle.amer.corp.natinst.com>
 <0d1c4cf8-70d8-4d12-bd77-393009d32b22@CH1EHSMHS001.ehs.local>
 <20121027140053.GB5190@beefymiracle.amer.corp.natinst.com>
 <4fd22fac-49c4-4000-9e70-12e94f248753@AM1EHSMHS010.ehs.local>
 <20121027144253.GC5190@beefymiracle.amer.corp.natinst.com>
 <60e4cbf9-52b4-4c02-8537-ecd3a7dbbf06@CO1EHSMHS020.ehs.local>
 <20121105183509.GA1254@beefymiracle.amer.corp.natinst.com>
 <CAHTX3dLgWxCzLT=TH+7ydep-m4+euVCP2cBo=Yx1qhe4xVL7NA@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAHTX3dLgWxCzLT=TH+7ydep-m4+euVCP2cBo=Yx1qhe4xVL7NA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-MIMETrack: Itemize by SMTP Server on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 11/07/2012 08:17:48 AM,
	Serialize by Router on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 11/07/2012 08:17:49 AM,
	Serialize complete at 11/07/2012 08:17:49 AM
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vtzGhvizbBRQ85DL"
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8185,1.0.431,0.0.0000
 definitions=2012-11-06_05:2012-11-06,2012-11-06,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 07, 2012 at 01:05:57PM +0100, Michal Simek wrote:
> 2012/11/5 Josh Cartwright <josh.cartwright@ni.com>:
[..]
> > Our usecase may admittedly be a bit weird, because what logic is in the
> > PL is ultimately determined (and even implemented) by the end user and
> > is loaded at runtime.  There is a lot of machinery to make that happen,
> > but the point is that I don't have sufficient knowledge upfront to
> > generate appropriate bindings for what's in the PL.
>
> ok. It means that you need to use just the part of DTS without PL logic at all.
> Does it mean that PL will be connected with any DTS fragment?

Yes.  For the time being, this is true.  We have our own mechanisms for
enumerating IP at runtime.

> > > > Having a dtsi allows for easy extension of the zynq-7000
> > > > platform for our boards, without having to carry duplicate data.
> > >
> > > ok. I think that make sense if you send the next your series as
> > > RFC to see how exactly you would like to use it.
> >
> > It seems like you caught a glimpse of this in my COMMON_CLK
> > patchset. :)
>
> Yes. Just need to get some time to analyze it.
>
[..]
> > I wouldn't be as opposed to device tree generation if the device tree
> > generator was in tree.
>
> Which tree do you exactly mean? Linux kernel or just any git tree?

No, I mean in the upstream Linux kernel tree.  I don't think this is
likely to happen.  My point here is that the generator necessarily has a
dependency on how the bindings are written.  If those bindings change
(or new bindings are added), the generator must be updated to generate
device trees according to the new bindings.

I fail to see how these changes are handled with your generator.

> Let me give you more information about the generator. It uses TCL in SDK
> where it provides all structure from the system. It means device-tree generator
> will read all information from design tool and based on that will generate
> DTS file. It also means if user will setup specific irq lines in design, special
> paramters setting in registers then all these values will be added to DTS.
>
> > Device tree bindings change, how would/could an out-of-tree
> > generator possibly handle changes in bindings?
>
> What do you mean by that? Any example?

Yes, I have a real life example.  In 3.2 (?), GIC bindings were added to
the kernel.  It was necessary for us to update our board descriptions to
reflect the new #interrupt-cells = <3>; and figure out the appropriate
interrupt numbers (which differed from how they were specified before).

How would your generator have known whether or not I was targetting a
kernel with the GIC bindings, and appropriately generate the GIC node,
and generate interruptspecs for all children with #interrupt-cells = <3>?

Or, maybe another example: say clk bindings are added to the upstream
kernel, and I would like to use a kernel that contains them on my board.
Say this has all happened before Xilinx has even released a new version
of their SDK.  How could I use your dts generator to output proper clk
nodes in my dts?

It seems the only way that Xilinx can possibly handle this is to tightly
couple the version of the kernel and their generator.

With increasing support for Zynq in the mainline kernel tree, it may
become more palatable for some existing users to switch to using the
upstream kernel instead of the Xilinx tree for their boards, and
coupling between the generator and target kernel version will be broken.

[..]
> > It is odd to me that the use of a generator would be required to create
> > what is completely static data.  What I'm referring to here is the
> > collection of peripherals on the zynq-7000 that are not in the PL.  For
> > me, this requirement adds an unnecessary dependency on the Xilinx EDK
> > that I would like to avoid.
>
> I am not saying that you need to use it. If you want to write your DTS
> by hand, you still can but I expect that the most of zynq users will
> use generator and generate it because it is just easier than to
> describe it by hand and they can be sure that all parameters are
> correctly generated.

Again, you can only make this assurance _for a specific version of the
kernel_.  If a user is not using the version of the kernel that came
with the SDK (and, maybe instead using a vanilla upstream kernel), all
bets are off.

> If you are using any non-standard solution where you will load pl
> logic at runtime then you can use just generated DTS for hardblock or
> write it by hand.

I choose 'write it by hand'.  I want what I write by hand to also be
useful to others by including the zynq-7000.dtsi in the upstream kernel.

[..]
> If you want to use solution with several dtsi files and compose it as
> you describe then it is completely fine but forcing others to use this
> structure and write dts by hand will be big pain for a lot of users.

Using a composed model in the upstream kernel doesn't force anything
upon the existing users of your generator.  They can still use whatever
gets spit out of your generator (assuming it generates nodes with
appropriate bindings).  Unless I'm missing something here.

> Also in design tools you can setup if you use qspi,nor,nand flash
> memory interface.
> memory interface, baudrates, dma, ports to PL logic, connections, etc.
> and from my point of view is very complicated to describe it by
>
> There are a lot of combination which you can have on one reference
> board.  You can't enable all hard IPs at one time and use all of them
> that's why you shouldn't list all of them in the kernel.

I disagree with this.  In my opinion, all of the "hard IPs" should be
described in the zynq-7000.dtsi, and those nodes which aren't available
explicitly disabled in the board-specific file.

> From my point of view make sense to have one DTS file in the kernel
> and one defconfig for the most popular zynq board where will be
> exactly written that this DTS is connected to this reference hw
> design. If you want to get more reference design go to this page and
> download it.  Adding all DTSes for zynq boards to the kernel is
> overkill.  If you want to use your hw design you can use this
> generator and generate it or write it by hand.

All I'm asking for is for there to be a common zynq-7000.dtsi that
describes all of the static PS logic ("hard IPs") in the upstream kernel
source that I can include in my own (hand maintained) board
descriptions.  It would be nice if there was an example of its use, like
with a zc702 board file also upstream, but it is not really important to
me.

I do not want a dependency on the EDK.

My request does not sound unreasonable to me and is what other platforms
are doing.

  Josh

--vtzGhvizbBRQ85DL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQmm2XAAoJEEef0niEbw+luR8QAMWysTiMk2Awy+joAK7X6IF7
VE8nsKLyweVM/+ar6KAPLLu+TDZIM4Vt7FhNOHK2TDGlCv+BfTB5fzRss31ynKc1
6Za44lTCZCMoDkk+6BUHtV1Eqo7MVqvBtaSD7ou1i5SLfnFGH3cuDzzXKTzD62cg
VVpM0gMEm1lyQol5weaFoi3rRtrQrLMfKFirfLEQbVII3jgJoqWTt/5Z5LXuXx/9
LD/oBT4dDP73wM10ToDNb8ZxLjiqDH5NxW8YmYA4sicBmJGLPieguc4M8iSMx8hy
b5P0ZxB3av5z9BJoQHflj+DptLDE/3H/E3uOn2Ht3JK+DelypYWGgoTTR+xby52d
88+HXSjDXyrzHcYLq4lETU6xvnWZwttKkNy7OIn1gcmR7YgIBzUnPIiP8XcZ0ehZ
4sKoB4lpUwGv64nPmx2/jyCZmoA28PIaHeMYB9cFintUaO86jEVndzOq4GW2guNV
0+99rSeCb+CNKYNuDSiphfE8fRaqR8EdeQItXLIzVvkM2FMCWCIxf6/bu5RdV4qk
vdlyAXQ5QTQbMaGsm9MSMfCDkJAMT0vvhNmxEFvMWPdSwEeyiA0Woj8P73CBX0sH
zTMyEVB2yDzNWrVlb4ZKtXpX+klyWQev9H7WSrhblNrjcFFi9Zr5L9dSA4hneXqi
2vLa6/WtOFIpmaJnIk+F
=JDjj
-----END PGP SIGNATURE-----

--vtzGhvizbBRQ85DL--
