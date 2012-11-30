Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933346Ab2K3R3H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 12:29:07 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:49513 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757127Ab2K3R3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 12:29:04 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Eli Billauer <eli.billauer@gmail.com>
Subject: Re: [PATCH 2/2] New driver: Xillybus generic interface for FPGA (programmable logic)
Date: Fri, 30 Nov 2012 17:28:47 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        Philip Balister <philip@balister.org>, Pavel Machek <pavel@denx.de>,
        John Linn <john.linn@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        "Ira W. Snyder" <iws@ovro.caltech.edu>
References: <1354117293-13632-1-git-send-email-eli.billauer@gmail.com> <1354117293-13632-2-git-send-email-eli.billauer@gmail.com>
In-Reply-To: <1354117293-13632-2-git-send-email-eli.billauer@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201211301728.48008.arnd@arndb.de>
X-Provags-ID: V02:K0:XhlvF1AEZMBV0GApbWgeDqnxFvj38ybA48W6hIKnF0Q
 Ci/3VvIiRu1m6Cvd7vHuRe8n3INSaiYOLaW4GugZn0zclyW1i5
 I5MX7Yu1x1Kddb4kdaQVzdc51MYCTVeZKcmH7zMqN/5W/9Z/7Q
 J8yScGEedb6PZ0JzzNXl3kvKZ5Xhb00NeS0weNNgAjDLCZ7oPD
 K0B0n7I/eebMwg3gTZhdKp03JSfbCFWgsuvaBell/lFzIEbXJA
 8leqrPYovZV3xR7htzVHhyIi34jgDFRncm7qDmGMIuxxReWIqb
 ka3jdxeKc7UzCEbAmJUvS9gieVtjfgFhGzwBFg1w87yxdF3Tje
 FZiHdbjv5kPLJrYy/7Ls=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 November 2012, Eli Billauer wrote:
> 
> Xillybus is a general-purpose framework for communication between programmable
> logic (FPGA) and a host. It provides a simple connection between hardware FIFOs
> in the FPGA and their respective device files on the host. The user space
> programming model is like piping data from or to the FPGA.
> 
> The underlying transport between the host and FPGA is either PCIe or AXI
> (AMBA bus by ARM).
> 
> The Xillybus logic (IP core) is configurable in the number of pipes it presents
> and their nature. The driver autodetects these pipes, making it essentially
> forward-compatible to future configurations. The benefit of having this driver
> enabled in the kernel is that hardware vendors may release a new card, knowing
> that it will work out of the box on any future Linux machine, with the specific
> configuration defined for the FPGA part.
> 
> This driver has been available for download for over a year, and has been
> actively used on a wide variety of kernels versions and configurations.

I have a much higher-level comment on this driver: There seem to be a number
of parties that are interested in having reprogrammable logic available in
Linux and that will want to merge their drivers. I'm aware of these other
people that must have some interest (and one person I can't mention here
because of NDA):

Philip Balister  <philip@balister.org> (OpenSDR)
Dinh Nguyen <dinguyen@altera.com> (ARM SOCFPGA maintainer)
Pavel Machek <pavel@denx.de> (SOCFPGA contributor)
John Linn <john.linn@xilinx.com> (Zynq maintainer)
Michal Simek <michal.simek@xilinx.com> (Zynq maintainer)
Ira W. Snyder <iws@ovro.caltech.edu> (Carma driver author)

I believe it is in everybody's interest to define a single kernel-to-user
interface that can be used to install a payload in an any of the FPGA
implementations, and a common way to probe logical devices that are
implemented in that FPGA.

Your driver seems like an good start for such an interface, and I
think it would be reasonable to put it into a new drivers/fpga/
subsystems rather than a "misc" driver, but that requires at least
the user level interface to be generic enough to cover all the use
cases. Ideally, the in-kernel interface would also be generic to allow
plugging in additional hardware drivers and allowing to add independent
back-ends for functionality based on the model that gets loaded into
the FPGA. However, we don't have to do it right away, as we can always
change in-kernel interfaces when needed, unlike the user interfaces
that have to remain stable.

	Arnd
