Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430Ab2LCU1O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 15:27:14 -0500
Received: from [207.46.163.24] ([207.46.163.24]:43588 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752258Ab2LCU1M convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 15:27:12 -0500
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: 3
X-BigFish: VPS3(z1039ozbb2dI98dI9371I542I1432Izz1de0h1202h1d1ah1d2ahzzz2fh95h668h839h944hd24hf0ah119dh1220h1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h906i1155h)
From: John Linn <John.Linn@xilinx.com>
To: Arnd Bergmann <arnd@arndb.de>, Philip Balister <philip@balister.org>
CC: Greg KH <gregkh@linuxfoundation.org>,
        Eli Billauer <eli.billauer@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>, Michal Simek <michals@xilinx.com>,
        "Ira W. Snyder" <iws@ovro.caltech.edu>,
        Josh Cartwright <josh.cartwright@ni.com>
Subject: RE: [PATCH 2/2] New driver: Xillybus generic interface for FPGA
 (programmable logic)
Thread-Topic: [PATCH 2/2] New driver: Xillybus generic interface for FPGA
 (programmable logic)
Thread-Index: AQHNzyAy4+TlPD18RkuI72uNx4QPb5gDKmMAgACiwgCAASU/AIAClaVA
Date: Mon, 3 Dec 2012 20:24:52 +0000
References: <1354117293-13632-1-git-send-email-eli.billauer@gmail.com>
 <20121130173644.GA9841@kroah.com> <50B97734.3090207@balister.org>
 <201212012048.51012.arnd@arndb.de>
In-Reply-To: <201212012048.51012.arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.19.166.2]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-RCIS-Action: ALLOW
Message-ID: <c6b15bd1-09a0-4873-a094-dce39313ccf5@CO9EHSMHS017.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: Saturday, December 01, 2012 12:49 PM
> To: Philip Balister
> Cc: Greg KH; Eli Billauer; linux-kernel@vger.kernel.org; Pavel Machek; John Linn; Michal Simek; Ira W.
> Snyder; Josh Cartwright
> Subject: Re: [PATCH 2/2] New driver: Xillybus generic interface for FPGA (programmable logic)
> 
> On Saturday 01 December 2012, Philip Balister wrote:
> > On 11/30/2012 09:36 AM, Greg KH wrote:
> > > Yes, I know of at least one more device other than the ones listed above
> > > that wants this type of functionality as well, so defining it in a
> > > standard user/kernel api manner would be very good to do.
> >
> > I'm concerned that a standard driver for FPGA's will be a very difficult
> > problem.
> >
> > The Xillybus driver looks interesting on several levels, however my
> > first concern is depends on a FPGA IP block that is not open source.
> > This is not a bad thing, just a potential obstacle for some people.
> 
> I agree that is a concern, but for now, I'm mostly worried about
> the kernel-to-user interface. If we can agree on a driver interface
> that works for Xillybus as well as any of the others we know about,
> we can start using that as the generic kernel FPGA interface.
> 
> Once we get a second FPGA driver, that can use the same user
> interface but talk to the hardware in a different way, and then
> we can reorganise the code to keep the user interface bits in a
> common driver, away from the hardware specific parts.
> 
> If you see anything in the user interface that directly depends on
> the Xillybus IP block, then that would make the approach impossible
> and we should change that to be more generic.
> 
> > I've been engaged in design discussions today with my customer. Our
> > target is the Xilinx Zynq hardware. The first pass at a driver focuses
> > on creating the minimal amount of code in the kernel doing most of the
> > logic in user space. So the driver code allocates a large chunk of RAM
> > for the FPGA to read/write to, provides a mmap function so user space
> > can see this RAM, also mmaps in the address space of an AXI slave so the
> > user space can control the logic. This approach has no dependencies on
> > what is loaded into the fpga.
> >
> > This is a very different approach then the Xillybus driver, but should
> > also be useful to a large class of people. Hopefully, we can converge on
> > a set of useful drivers, and not end up with a million drivers all based
> > on custom fpga configuration :)
> 
> Agreed. If I understand you correctly though, your approach is specific
> to a particular hardware implementation (Zynq) on the user interface layer,
> which I think is exactly what we should avoid. Obviously, there is
> always a driver involved that is specific to the IP block you load into
> an FPGA at runtime, and that is ok. The two parts that I think we
> should agree on are:
> 
> a) How to get a payload into the FPGA
> 
> b) How to find a device driver that can make the payload interface to user
>    space.

Yes I agree with these 2 parts and keeping them separated.

Josh's comments were aligned with where we want to go also with the device tree
and Grant's work.

Thanks
John

> 
> 	Arnd


