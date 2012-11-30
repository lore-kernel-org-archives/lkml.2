Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758959Ab2K3Rgv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 12:36:51 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40005 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755697Ab2K3Rgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 12:36:49 -0500
Date: Fri, 30 Nov 2012 09:36:44 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Eli Billauer <eli.billauer@gmail.com>, linux-kernel@vger.kernel.org,
        Philip Balister <philip@balister.org>, Pavel Machek <pavel@denx.de>,
        John Linn <john.linn@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        "Ira W. Snyder" <iws@ovro.caltech.edu>
Subject: Re: [PATCH 2/2] New driver: Xillybus generic interface for FPGA
 (programmable logic)
Message-ID: <20121130173644.GA9841@kroah.com>
References: <1354117293-13632-1-git-send-email-eli.billauer@gmail.com>
 <1354117293-13632-2-git-send-email-eli.billauer@gmail.com>
 <201211301728.48008.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201211301728.48008.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2012 at 05:28:47PM +0000, Arnd Bergmann wrote:
> On Wednesday 28 November 2012, Eli Billauer wrote:
> > 
> > Xillybus is a general-purpose framework for communication between programmable
> > logic (FPGA) and a host. It provides a simple connection between hardware FIFOs
> > in the FPGA and their respective device files on the host. The user space
> > programming model is like piping data from or to the FPGA.
> > 
> > The underlying transport between the host and FPGA is either PCIe or AXI
> > (AMBA bus by ARM).
> > 
> > The Xillybus logic (IP core) is configurable in the number of pipes it presents
> > and their nature. The driver autodetects these pipes, making it essentially
> > forward-compatible to future configurations. The benefit of having this driver
> > enabled in the kernel is that hardware vendors may release a new card, knowing
> > that it will work out of the box on any future Linux machine, with the specific
> > configuration defined for the FPGA part.
> > 
> > This driver has been available for download for over a year, and has been
> > actively used on a wide variety of kernels versions and configurations.
> 
> I have a much higher-level comment on this driver: There seem to be a number
> of parties that are interested in having reprogrammable logic available in
> Linux and that will want to merge their drivers. I'm aware of these other
> people that must have some interest (and one person I can't mention here
> because of NDA):
> 
> Philip Balister  <philip@balister.org> (OpenSDR)
> Dinh Nguyen <dinguyen@altera.com> (ARM SOCFPGA maintainer)
> Pavel Machek <pavel@denx.de> (SOCFPGA contributor)
> John Linn <john.linn@xilinx.com> (Zynq maintainer)
> Michal Simek <michal.simek@xilinx.com> (Zynq maintainer)
> Ira W. Snyder <iws@ovro.caltech.edu> (Carma driver author)

Yes, I know of at least one more device other than the ones listed above
that wants this type of functionality as well, so defining it in a
standard user/kernel api manner would be very good to do.

thanks,

greg k-h
