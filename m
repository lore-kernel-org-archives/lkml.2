Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664Ab2LDUzN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 15:55:13 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:55760 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab2LDUzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 15:55:11 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Philip Balister <philip@balister.org>
Subject: Re: [PATCH 2/2] New driver: Xillybus generic interface for FPGA (programmable logic)
Date: Tue, 4 Dec 2012 20:54:59 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Eli Billauer <eli.billauer@gmail.com>, linux-kernel@vger.kernel.org,
        Pavel Machek <pavel@denx.de>, John Linn <john.linn@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        "Ira W. Snyder" <iws@ovro.caltech.edu>,
        Josh Cartwright <josh.cartwright@ni.com>
References: <1354117293-13632-1-git-send-email-eli.billauer@gmail.com> <201212012048.51012.arnd@arndb.de> <50BE53E4.1040303@balister.org>
In-Reply-To: <50BE53E4.1040303@balister.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201212042054.59754.arnd@arndb.de>
X-Provags-ID: V02:K0:3d1IaudPM1mPoSOlqgJttGNCuxHRphXtQFgHzpC4nEe
 mRYQmX+qECN+PhBbpJeHzk8hmY0GOSqJi8MGBQlJlDoV5ndNlW
 KVWq/uwSj55aox0i5FgEqbaeAUlIUBJUbALKR5xY8tGOGImHWw
 ROTswh7uM8/xNS9mpZ7vuQmAGlv8gp59uuHUusCyMw+YHfzcs1
 rL8uXAITiGyTfzbOm2xgqwvd4N4hy719NHTq7WnLK3fif/aQZD
 k7V8yQjysGIObdW0B3g7TgHGTUFtcYUXmJHD/co5Mx9T/ObUIB
 9YHdi/ITVo2VwwYR6CFB8eqmiwuHITJR+5cg2M08kuDEVTDgG3
 wmtwVMqM/GMVRCenNWFc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 December 2012, Philip Balister wrote:
> On 12/01/2012 12:48 PM, Arnd Bergmann wrote:
> > On Saturday 01 December 2012, Philip Balister wrote:
> >> On 11/30/2012 09:36 AM, Greg KH wrote:
> >>> Yes, I know of at least one more device other than the ones listed above
> >>> that wants this type of functionality as well, so defining it in a
> >>> standard user/kernel api manner would be very good to do.
> >>
> >> I'm concerned that a standard driver for FPGA's will be a very difficult
> >> problem.
> >>
> >> The Xillybus driver looks interesting on several levels, however my
> >> first concern is depends on a FPGA IP block that is not open source.
> >> This is not a bad thing, just a potential obstacle for some people.
> >
> > I agree that is a concern, but for now, I'm mostly worried about
> > the kernel-to-user interface. If we can agree on a driver interface
> > that works for Xillybus as well as any of the others we know about,
> > we can start using that as the generic kernel FPGA interface.
> >
> > Once we get a second FPGA driver, that can use the same user
> > interface but talk to the hardware in a different way, and then
> > we can reorganise the code to keep the user interface bits in a
> > common driver, away from the hardware specific parts.
> 
> Actually, the user interface will depend on what "code" is loaded into 
> the FPGA (side note, people argue over FPGA's being hardware or 
> software). So it is entirely possible to load an FPGA with a XillyBus 
> device, and ethernet interface, I2S, and the "UIO" appraoch I am working on.

Yes, absolutely. Or multiple instances each of them even. Or constantly
reload the FPGA depending on the application running in user space.

> We can use device tree to tell the kernel what drivers are needed, and 
> Josh mentioned some ideas on managing device tree entries combined with 
> the fpga image.
> 
> So it is very possible for one fpga to have several device drivers, each 
> using different user interfaces. It is entirely possible to create a 
> device in the fpga that uses an existing hardware interface so you could 
> use the existing Linux driver to control it.

One implication of using the device tree though is that it's statically
configured, and you can't just load something else into it if you
want to run something else. This is certainly fine in many cases,
but I think we also need to consider the case where it is not know
at boot time which image will get loaded into the FPGA.

Note that you can actually put the byte stream for the FPGA image
into a device tree property so you don't have to load it from
disk, which may not be easy for technical (e.g. the FPGA 
implementing you storage interface) or legal (e.g. the patents
preventing you from shipping the image with a standard Linux
distro) reasons.
 
> Just to be clear, what are you calling payload here? Is it the data that 
> is used to configure the fpga, or actual data going back and forth? I'm 
> a little concerned that not everyone understand how flexible the FPGA is.

I mean the configuration byte stream.

	Arnd
