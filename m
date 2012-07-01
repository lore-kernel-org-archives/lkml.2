Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166Ab2GALBF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 07:01:05 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35975 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932073Ab2GALBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 07:01:03 -0400
Date: Sun, 1 Jul 2012 11:59:35 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, giancarlo.asnaghi@st.com,
        alan@linux.intel.com, x86@kernel.org, gregkh@linuxfoundation.org,
        arnd@arndb.de, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH V2 5/6] x86: add CONFIG_ARM_AMBA, selected by STA2X11
Message-ID: <20120701105934.GD16319@n2100.arm.linux.org.uk>
References: <4FECB95D.7010200@zytor.com> <cover.1338222460.git.rubini@gnudd.com> <f85fefb10b7a7407b77180be65b18bf0426145b9.1338222461.git.rubini@gnudd.com> <20120701104401.GA4352@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120701104401.GA4352@mail.gnudd.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 01, 2012 at 12:44:01PM +0200, Alessandro Rubini wrote:
> How should I address the problem? (original code, published on
> sourceforge was simply replicating a number of amba drivers into pci
> drivers, but I don't think massive code duplication is ever sensible,
> thus I preferred to reuse the existing drivers).

I think the answer is... those primecell drivers need fixing in some way.
Re-defining CS, DS and ES in drivers is rather silly given that they're
x86 segment register names - so if PL330 can be fixed to make its names
more specific, that sorts it out.

As for PL08x, which depends on asm/hardware/pl080.h, I think that's going
to have to be a config dependency - it would be nice to move that header
into drivers/dma and make it private to the amba-pl08x driver, but we have
definitions in there which platforms supply to the pl08x driver via
platform data.  I'd rather not stuff the register definitions into
include/linux/platform_data/...

Note also that hpa has only reported the first errors he encountered, so
there may be more, and that's somehting which needs checking.
