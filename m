Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700Ab0KXGKE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 01:10:04 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:35261 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854Ab0KXGKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 01:10:01 -0500
Date: Wed, 24 Nov 2010 15:09:13 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: "Nori, Sekhar" <nsekhar@ti.com>, Ben Gardiner <bengardiner@nanometrics.ca>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Govindarajan, Sriramakrishnan" <srk@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexander Clouter <alex@digriz.org.uk>,
        Chris Cordahi <christophercordahi@nanometrics.ca>
Subject: Re: [PATCH v2 2/4] da850-evm: add UI Expander pushbuttons
Message-ID: <20101124060913.GE11705@linux-sh.org>
References: <cover.1289835508.git.bengardiner@nanometrics.ca> <cover.1289935504.git.bengardiner@nanometrics.ca> <95f48a32a0256ecdb7148aa08d16f64928a7e5d8.1289935504.git.bengardiner@nanometrics.ca> <B85A65D85D7EB246BE421B3FB0FBB59302477EA939@dbde02.ent.ti.com> <AANLkTi=HS7ym8n6=hF8vAg2WR33Md5=YRZL2NS7a+F2y@mail.gmail.com> <B85A65D85D7EB246BE421B3FB0FBB59302477EB2BE@dbde02.ent.ti.com> <AANLkTimRbsmR6xMok8P_wXpQAd1Xykew6_pPhqUWGsEN@mail.gmail.com> <B85A65D85D7EB246BE421B3FB0FBB5930247931247@dbde02.ent.ti.com> <8739qshwhm.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8739qshwhm.fsf@deeprootsystems.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 23, 2010 at 07:48:21AM -0800, Kevin Hilman wrote:
> "Nori, Sekhar" <nsekhar@ti.com> writes:
> > On Mon, Nov 22, 2010 at 19:20:48, Ben Gardiner wrote:
> >> Yes -- only gpio-keys is affected but enabling the option does
> >> introduce an additional .o file:
> >>
> >> drivers/input/Makefile:obj-$(CONFIG_INPUT_POLLDEV)      += input-polldev.o
> >>
> >> I agree that in its current state a user couls inadvertently disable
> >> the gpio-keys support on da850-evm simply by disabling INPUT_POLLDEV
> >> -- which is less than Ideal. How about I replace the current changes
> >> to arch/arm/mach-davinci/Kconfig with:
> >>
> >> config KEYBOARD_GPIO
> >>         default MACH_DAVINCI_DA850_EVM
> >>         select INPUT_POLLDEV
> >>
> >> So 1) gpio-keys functionality is default for the da850evm and 2)
> >> whenever gpio-keys is enabled so is INPUT_POLLDEV.
> >
> > This looks better than what was posted earlier, but I am not
> > sure if platforms should influence driver configuration this
> > way.
> 
> Agreed.  In general, we should not have machine/platform specific
> conditionals in generic Kconfigs.   Generally, this should be handled in
> machine/platform specific Kconfigs.
> 
The patch that I originally wrote for this had the select under the
Kconfig option for the driver itself, with the decision to use it or not
being dynamically determined based on the platform data. I maintain that
this is the only sensible way to deal with things, but this was rejected
by the input folks at the time who felt that it was adding in extra
overhead for a corner case. The alternatives then are to either make an
identical copy of the driver that uses a polled interface, come up with
lame INPUT_POLLDEV wrapper shims, or simply accept the fact that drivers
using optional interfaces are going to have to have those interfaces
built in to the kernel. There has been zero progress on getting this
functionality integrated for years now because of this issue, and I don't
really see that changing until people accept that drivers will sometimes
require additional functionality to be built-in, or provide a suitable
alternative. Personally I don't care enough about this particular problem
to put any more cycles in to it, and the hardware that I wrote this patch
for initially will be end-of-lifed long before there's any coherent
consensus in driver land.
