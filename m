Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800Ab1CRPAT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 11:00:19 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:64629 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862Ab1CRPAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 11:00:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: andy.green@linaro.org
Subject: Re: RFC: Platform data for onboard USB assets
Date: Fri, 18 Mar 2011 16:00:09 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Greg KH <greg@kroah.com>, Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
References: <20110311165642.GA9996@kroah.com> <201103172333.01474.arnd@arndb.de> <4D82979B.2050003@linaro.org>
In-Reply-To: <4D82979B.2050003@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103181600.09877.arnd@arndb.de>
X-Provags-ID: V02:K0:KLMHrcyloAkHFJkspiP5AWedqleyXg5AX3wsDL5UrFb
 9YmAEkcy6a/4z65YPNuCOoyvn5CSIYpdyXqa/ScN7AWZXUZQqw
 XTHuEBcsGrKjCm0sgdPWumlx8XT6sblIVYtMkas9ULXAdVuEaq
 6O5aPvwXnmQq6NPXEPyDWvxbuGDVsOctFf9cJXqG7rRRt3poMI
 xRr8tgfolk/5BtD+IMHyQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 March 2011, Andy Green wrote:
> On 03/17/2011 10:33 PM, Somebody in the thread at some point said:
> > On Thursday 17 March 2011 22:47:36 Greg KH wrote:
> >>
> >> Well, that means that the device tree work is going to be useful here,
> >> right?  :)
> >
> > I like the idea. Let's make this the first use case where a lot of
> 
> You changed your first opinion about tagging "dynamically probed 
> devices" with what is effectively platform_data, cool.

I still don't like the idea of attaching platform_data to more
devices, when we try to move people away from that in other
parts of the kernel, because of the known deficiencies.

Passing a MAC address in a device tree property is a
well-established method that is used on many drivers, and
is portable across operating systems and architectures.

> > people will want to have the device tree on ARM. The patch to the
> > driver to check for a mac-address property is trivial, and we
> > can probably come up with a decent way of parsing the device
> > tree for USB devices, after all there is an existing spec for
> > it (http://playground.sun.com/1275/bindings/usb/usb-1_0.ps).
> 
> It doesn't do it already then.
> 
> That spec you pointed to from 1998 is obviously going to be a whole 
> subproject doing the binding, it seems to fingerprint devices by VID/PID 
> if I understood it.

We don't need to implement the entire binding. My point was that
if we implement a way to attach a device_node to a usb_device, we
should do it in a way that is compatible with that binding, rather
than coming up with a new way.

Most importantly, you can ignore the entire "compatible"-
and "name"-property matching. I think we only need to look
at the "reg" property to walk the bus structure, and any
usb_device we find during the USB hub probing simply gets
linked to its device_node.

> What's the plan for leveraging that level of generality on "dynamically 
> probed devices"?  I mean I know what I want to use this for and the 
> platform_data scheme covers all the soldered-on-the-board cases fine.

Isn't there also a device tree based OMAP tree that can boot on
Panda and is just waiting to get merged?
 
> Is there actually a need for sort of not platform_data but universal 
> vid_pid_specific_usb_device_option_data coming from the board definition 
> file or bootloader for *pluggable* usb devices?  udev seems to be well 
> established doing that already in a generic, not-platform-specific way 
> that can go in all distros and so on nicely.  Maybe this is just my 
> impoverished imagination and people do want, say, some kinds of USB mice 
> to operate at higher DPI or whatever when plugged in a specific board 
> because it is that board.

It should really not be tied to a specific board, and there is a lot
of work going on to remove the need for board-specific source code
files, replacing it all with data structures.

My impression so far is that attaching a struct device_node to
static USB devices can be useful in general, but I wouldn't
go so far to suggest using this for dynamically probed devices.

	Arnd
