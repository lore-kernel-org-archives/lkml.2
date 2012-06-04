Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911Ab2FDKRA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 06:17:00 -0400
Received: from gate.crashing.org ([63.228.1.57]:32926 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885Ab2FDKQ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 06:16:59 -0400
Message-ID: <1338804972.7150.77.camel@pasglop>
Subject: Re: [PATCH] x86/platform: sta2x11: add platform code
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alessandro Rubini <rubini@gnudd.com>, linux-kernel@vger.kernel.org,
        giancarlo.asnaghi@st.com, alan@linux.intel.com, tglx@linutronix.de,
        mingo@redhat.com, sameo@linux.intel.com, x86@kernel.org,
        Len Brown <lenb@kernel.org>
Date: Mon, 04 Jun 2012 20:16:12 +1000
In-Reply-To: <4FC47D49.50204@zytor.com>
References: <4FC477A1.4010709@zytor.com>  <4FC47003.1080906@zytor.com>
	 <4FC40C74.8050003@zytor.com>  <20120527205020.GA3050@mail.gnudd.com>
	 <20120529063738.GA22711@mail.gnudd.com>
	 <20120529070557.GA23373@mail.gnudd.com>
	 <20120529073417.GA25041@mail.gnudd.com> <4FC47D49.50204@zytor.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-29 at 00:39 -0700, H. Peter Anvin wrote:
> > So, it seems I must go device-tree for the chipset-like mounting.
> And
> > what about plug in boards? I may arrange a firmware-loader mechanism
> > as an alternative, so the vendor of each board can provide the the
> > platform data for all the sub devices. Actually, if firmware loader
> is
> > acceptable, I'd try it first, to avoid changing the boot procedure;
> > maybe I can save myself from the device tree.
> > 
> 
> If you're going to use a binary blob for the loader, use either ACPI 5
> SSDT or device tree format.  This is *not* something where
> (re)invention is encouraged.

Right, a device-tree blob could easily be passed an x86 has the
infrastructure to use it already afaik.

It then becomes a matter of the bootloader to carry it over to the
kernel a way or another. If the "vendor" boards don't do the right
thing, you can always do like powerpc for those cases and "package" the
device-tree blob in the zImage wrapper.

That way, distribution install tools etc.... can stick the right
device-tree before doing whatever "flashing" of the image is needed for
booting etc... and the main kernel image remains agnostic.

That or the ACPI way but I know nothing about it and thus naturally
assume it's harder :-)

Cheers,
Ben.

