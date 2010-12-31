Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066Ab0LaAvN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 19:51:13 -0500
Received: from mga01.intel.com ([192.55.52.88]:27711 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797Ab0LaAvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 19:51:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,252,1291622400"; 
   d="scan'208";a="873174770"
Message-ID: <4D1D28F9.7010808@linux.intel.com>
Date: Thu, 30 Dec 2010 16:51:05 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
Organization: Intel Open Source Technology Center
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        devicetree-discuss@lists.ozlabs.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, sodaville@linutronix.de
Subject: Re: [sodaville] [PATCH 02/11] x86: Add device tree support
References: <1290706801-7323-1-git-send-email-bigeasy@linutronix.de>	<1290706801-7323-3-git-send-email-bigeasy@linutronix.de>	<1290807736.32570.143.camel@pasglop>	<20101128134907.GA30784@www.tglx.de> <20101230082654.GB11721@angua.secretlab.ca>
In-Reply-To: <20101230082654.GB11721@angua.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/30/2010 12:26 AM, Grant Likely wrote:
> 
> Since Linux on x86 has pretty much always depended on a two stage boot
> (firmware boots a bootloader like grub which in turn boots the
> kernel), then what is the use case for pursuing an in-kernel dtb
> linkage?  simpleimage was used on powerpc for the use-case where there
> is no 2nd stage bootloader, but instead only the kernel which is
> booted from some firmware that is non-upgradeable (or at least too
> risky to upgrade).  Same with the cuImages.  The wrapper is
> effectively a 2nd stage bootloader to adapt from what older u-boot
> provides and what the kernel needs.
> 
> What is the boot sequence for the embedded x86 platforms?  Is there
> still a bootloader?  If so, what prevents always depending on the
> bootloader to pass in the device tree blob?  If the bootloader is
> software (not firmware) then it should be something we have control
> over when shipping a distribution.
> 
> BTW, don't take microblaze as the example to be emulated.  Some of
> the things it does for device tree support is not scalable, like
> linking the .dtbs directly into the kernel.
> 
> John Bonesio has also prototyped doing a similar zImage bootwrapper on
> arm which allows a dtb to be concatenated to the kernel image and
> updated before passing it to the kernel.  As it stands, there are no
> plans to use in-kernel .dtb linking on ARM.
> 
> I know it's not very fair to bring up these issues again right before
> the merge window opens.  I got myself overcommitted and dropped the
> ball over the last 1.5 months and I beg forgiveness.  However, I do
> want to make sure that the right decision is made and I'd be happier
> if a consistent scheme is used for passing the .dtb on all
> architectures.
> 

There are a number of different boot loader solutions in use on embedded
platforms, as much as we would like to avoid it.

However, the ability to link in the dtb will provide a
architecture-neutral option of last resort.  I'm not saying it's a good
option, but it's better than random ad hoc stuff, and if that means that
it will only ever be used during in-lab platform bringup, *that is still
a huge win*.

	-hpa
