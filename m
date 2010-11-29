Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154Ab0K2Q7I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 11:59:08 -0500
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:47045 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922Ab0K2Q7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 11:59:07 -0500
X-Greylist: delayed 1612 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Nov 2010 11:59:07 EST
Date: Mon, 29 Nov 2010 08:32:11 -0800
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] fpga: add basic CARMA board support
Message-ID: <20101129163210.GA27013@ovro.caltech.edu>
References: <1283964082-30133-1-git-send-email-iws@ovro.caltech.edu>
 <1283964082-30133-4-git-send-email-iws@ovro.caltech.edu>
 <1290991094.32570.213.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290991094.32570.213.camel@pasglop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (ovro.ovro.caltech.edu); Mon, 29 Nov 2010 08:32:12 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 11:38:14AM +1100, Benjamin Herrenschmidt wrote:
> On Wed, 2010-09-08 at 09:41 -0700, Ira W. Snyder wrote:
> > This adds basic support for the system controller FPGA on the OVRO CARMA
> > board. This patch only adds infrastructure that will be used by later
> > drivers.
> 
> Oh and another comment ...
> 
> I'm not sure about drivers/fpga ... in the end, one would expect such a
> directory to contain stuff to manipulate FPGAs in the sense of
> downloading bitfiles, instanciating devices (device-tree manipulation ?)
> etc...
> 
> From what I see in your code, the fact that these are FPGAs is almost
> irrelevant, you are providing support for "carma" devices, and such are
> no different than some other platform device, they just happen to be
> implemented as FPGAs. Or am I missing something ?
> 

You are exactly right. They are just regular platform devices. One
devices does happen to be a bitfile downloading driver
(carma-fpga-program), but it does not create any generic infrastructure
for downloading bitfiles.

Regarding your earlier comment about the carma class: no, it isn't
necessary. I found it convenient to have everything related to this
hardware appear in /sys/class/carma/, nothing more. It just wasn't as
easy to remember something like:
/sys/bus/platform/devices/f0000000.carma-fpga/.

I was thinking about changing the drivers from generic char devices into
misc devices instead. The sysfs interface would move from
/sys/class/carma/carma-fpga to /sys/class/misc/carma-fpga (for example),
but that is easy enough to remember.

Rather than putting the source code in drivers/fpga/carma, what about
drivers/misc/carma instead? I've already done that in my local tree, and
I'm much happier with the result.

Thanks for the comments.

Ira
