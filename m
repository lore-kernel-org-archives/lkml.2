Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161Ab2GAKpJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 06:45:09 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:33287 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755674Ab2GAKpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 06:45:05 -0400
Date: Sun, 1 Jul 2012 12:44:01 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, giancarlo.asnaghi@st.com,
        alan@linux.intel.com, linux@arm.linux.org.uk, x86@kernel.org,
        gregkh@linuxfoundation.org, arnd@arndb.de,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH V2 5/6] x86: add CONFIG_ARM_AMBA, selected by STA2X11
Message-ID: <20120701104401.GA4352@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <4FECB95D.7010200@zytor.com>
References: <4FECB95D.7010200@zytor.com>
  <cover.1338222460.git.rubini@gnudd.com>
 <f85fefb10b7a7407b77180be65b18bf0426145b9.1338222461.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> The sta2x11 I/O Hub is a bridge from PCIe to AMBA. It reuses a number
>> of amba drivers and needs to activate core bus support.

> Nacked-by: H. Peter Anvin <hpa@zytor.com>
> 
> This brings in tons of code into the x86 all{yes,mod}config builds, and 
> as perhaps one could expect some of it doesn't compile.  For example:

Ok. I apologize for not checking this. Actually, I only fixed the ones
that I needed to compile.

How should I address the problem? (original code, published on
sourceforge was simply replicating a number of amba drivers into pci
drivers, but I don't think massive code duplication is ever sensible,
thus I preferred to reuse the existing drivers).

I doubt all amba drivers can easily be made x86-compatible.
I see these possible approaces, all of them with their cons

  1- add STA2X11 dependencies to ARM_AMBA _and_ the drivers that do work

  2- leave CONFIG_ARM_AMBA undefined and play select file in Makefiles
   using obj-$(CONFIG_STA2X11)

  3- add ARM dependencies to the drivers that do not compile on x86

  any other option?

(1) and (2) bring chipset-specific stuff into the amba world, which is
bad, especially since I suspect other similar bridges will appear soon.

(3) looks like a temporary hack and stuff can be fixed over time, but
it has the disadvantage of adding a big number of needless drivers in
the dsitributions' packages -- like my nacked patch did.

thanks
/alessandro
