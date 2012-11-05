Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932961Ab2KESfM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 13:35:12 -0500
Received: from mailserver6.natinst.com ([130.164.80.6]:40436 "EHLO
	spamkiller06.natinst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932446Ab2KESfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 13:35:10 -0500
Date: Mon, 5 Nov 2012 12:35:09 -0600
From: Josh Cartwright <josh.cartwright@ni.com>
To: Michal Simek <michal.simek@xilinx.com>
Cc: "arm@kernel.org" <arm@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        John Linn <linnj@xilinx.com>, Nick Bowler <nbowler@elliptictech.com>
Subject: Re: [PATCH v4 1/5] zynq: use GIC device tree bindings
Message-ID: <20121105183509.GA1254@beefymiracle.amer.corp.natinst.com>
References: <20121024200222.GA6713@beefymiracle.amer.corp.natinst.com>
 <20121024200310.GB6713@beefymiracle.amer.corp.natinst.com>
 <0d1c4cf8-70d8-4d12-bd77-393009d32b22@CH1EHSMHS001.ehs.local>
 <20121027140053.GB5190@beefymiracle.amer.corp.natinst.com>
 <4fd22fac-49c4-4000-9e70-12e94f248753@AM1EHSMHS010.ehs.local>
 <20121027144253.GC5190@beefymiracle.amer.corp.natinst.com>
 <60e4cbf9-52b4-4c02-8537-ecd3a7dbbf06@CO1EHSMHS020.ehs.local>
MIME-Version: 1.0
In-Reply-To: <60e4cbf9-52b4-4c02-8537-ecd3a7dbbf06@CO1EHSMHS020.ehs.local>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-MIMETrack: Itemize by SMTP Server on MailServ59-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 11/05/2012 12:35:00 PM,
	Serialize by Router on MailServ59-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 11/05/2012 12:35:00 PM,
	Serialize complete at 11/05/2012 12:35:00 PM
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RnlQjJ0d97Da+TV1"
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.431,0.0.0000
 definitions=2012-11-05_03:2012-11-05,2012-11-05,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Oct 27, 2012 at 03:20:59PM +0000, Michal Simek wrote:
> On Saturday, October 27, 2012 4:43 PM, Josh Cartwright wrote:
> > On Sat, Oct 27, 2012 at 02:06:45PM +0000, Michal Simek wrote:
> > [...]
> > > I am not big fan to use dtsi solution because dts can be simple
> > > generated directly From Xilinx design tool based on your hw design.
> > > That's why I can't see any benefit To have dtsi file.
> >
> > Can I ask you to reconsider?
>
> I am open to all solution which will help others. I am not definitely
> saying NO for this features I just haven't found a reason to support
> it.
>
> > We, for example, don't make any use of the Xilinx
> > dev tools to generate our device trees.
>
> Ok. How does your working flow looks like?  I mean you don't get any
> information from hardware guys how does your hw design look like?

Our usecase may admittedly be a bit weird, because what logic is in the
PL is ultimately determined (and even implemented) by the end user and
is loaded at runtime.  There is a lot of machinery to make that happen,
but the point is that I don't have sufficient knowledge upfront to
generate appropriate bindings for what's in the PL.

> > Having a dtsi allows for easy extension of the zynq-7000 platform
> > for our boards, without having to carry duplicate data.
>
> ok. I think that make sense if you send the next your series as RFC to
> see how exactly you would like to use it.

It seems like you caught a glimpse of this in my COMMON_CLK patchset. :)

> In my workflow we generate DTS directly from design tool which I
> expect your hw guys use because it is probably needed to generate
> boot.bin/fsbl/etc.  Then there is one more additional step to setup
> device-tree bsp to generate DTS which directly fits to your HW design.
> If you have the same boards with different programmable logic I
> understand that you would like to share that PS part and then just add
> it that IPs in PL.
[..]
> From my point of view. You have to use design tools at least once to
> get bitstream and boot.bin with fsbl. Please correct me if I am wrong.
> In this step you can use device-tree BSP to generate DTS ( I doesn't
> need to be perfect with all attached devices on i2c,spi, phys, etc but
> it reflects your hardware).  You will get it in some seconds and your
> dts has correct irq numbers/ip description, compatible strings,
> addresses, position in the system - if you use bus bridges, etc) and
> you can just directly use it and kernel will boot. If you need to do
> changes in dts by hand, you can of course do it.

I wouldn't be as opposed to device tree generation if the device tree
generator was in tree.  Device tree bindings change, how would/could an
out-of-tree generator possibly handle changes in bindings?  Would a user
target the generator at a specific version of the kernel?  (An in tree
generator would also seem to necessitate a more formal specification
language for DT bindings).

It is odd to me that the use of a generator would be required to create
what is completely static data.  What I'm referring to here is the
collection of peripherals on the zynq-7000 that are not in the PL.  For
me, this requirement adds an unnecessary dependency on the Xilinx EDK
that I would like to avoid.

Would it make sense to limit what the device tree generator produces to
only what is in the PL?  (Forgive my ignorance about this tool, I've
never used it.)

This could just be an extension of what I've started to do with the
COMMON_CLK patchset.  A zynq board would be described using several
device tree snippets, one for the baked-in zynq-7000 peripheral set, one
for a generated description of what is in the PL, and one describing any
board-specific details (phy, etc).  Something like below:

zynq-7000.dtsi  : description of static zynq-7000 peripherals

	/ {
		amba : amba@0 {
			slcr: slcr@f8000000 {
				clocks {
					ps_clk : ps_clk {
						compatible = "fixed-clock";
					};
					...
				}
			};
			i2c0 : i2c0@e0004000 {
				compatible = "xlnx,i2cps";
				...
			};
			eth0 : eth0@e000b000 {
				compatible = "xlnx,emacps";
				...
			};
		};
	};

zynq-zc702-pl.dtsi : generated description of what is in the PL

	&amba {
		/* PL IP generated descriptions here. */
	};

zynq-zc702.dts  : board-specific descriptions (osc freq, i2c, spi, phys, etc)

	/include/ "zynq-7000.dtsi"
	/include/ "zynq-zc702-pl.dtsi"
	&ps_clk {
		clock-frequency = <33333330>;
	};
	&i2c0 {
		pca9548@74 {
			...
			reg = <0x74>;
			...
		};
	};
	&eth0 {
		phy@7 {
			compatible = "marvell,888e1116r";
			...
			reg = <0x7>;
		};
	};

Thoughts?

Thanks,
  Josh

--RnlQjJ0d97Da+TV1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQmAbdAAoJEEef0niEbw+lElgP+gOt/cY4ew6jNSqHPwt5HiZj
qZ9MPZ4j6VfskJbVydk4eoweSNTFgyCDXlV3wF013PUzadfZJEbs90fcvcpf2jwR
+cSjoV3Wyan3+G1cEvlWxN/5QVGYG/WBBTm6MkK6T5/WGjTlhSRDCjrGHyHL/nBp
Wqh4l579mBlB/iR90SwfbInbNRl2Bm5oNaytyL8kmWXw5UvRoy/v6g0fBrBFsGL2
t48za1NEqXvmjIc8lAhH9W6VzYDjYLt1khp3p+3JL/wf/URW+UpaHeSek9HeQG2O
WFT6X3BH4nff+0c/rSJA85WVbWFJlbtPUnZFHp8ZhoXx39bSnG3BJyFa80+/0cNe
okJ9H9BfRjiMUdlDNNKWhSXjywh/0kXT7e+aZDTHfoY+2ouK+pNKgSmoLzUs1qIX
OhDNVAIABgsyJicAxdLsxABU61+20c1DPbG1b+d9oplGTptW1ZCaPCW54hKxSyb6
xQ4mOv+y10Lt9o1Thc667k6ncIp6RDud4OcIG3YGg07rALNxIyRaQKZKLeC8DScT
J0S/mb28VG7iA+N0AZqOl4s91cZNuxXBJT4+tJypJMKFfSc3NVNyQVyIaM24/CxK
HHCnDh5D7cp/+DMFhJwxjXvfPxNPfjKIEGh8E2vmnxDgdJc7bTDeN/CrE111unf6
34lPkWCK1eMIdNsBLjEV
=8ea0
-----END PGP SIGNATURE-----

--RnlQjJ0d97Da+TV1--
