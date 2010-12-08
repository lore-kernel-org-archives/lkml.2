Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831Ab0LHVwn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 16:52:43 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:45035 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003Ab0LHVwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 16:52:42 -0500
Date: Wed, 8 Dec 2010 13:51:05 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Corentin Chary <corentin.chary@gmail.com>, sedat.dilek@gmail.com,
        Matthew Garrett <mjg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: Tree for December 8
 (drivers/platform/x86/Kconfig:422:error: recursive dependency detected!)
Message-Id: <20101208135105.a8482d46.randy.dunlap@oracle.com>
In-Reply-To: <20101208174603.GA7107@core.coreip.homeip.net>
References: <AANLkTim3FJjVpbjM10kJJhXbONpvGSGQFE+mfGX9pAS6@mail.gmail.com>
	<AANLkTimjVY-6OwRfFUzUbmyacM81M35wf5qDWqAouUYb@mail.gmail.com>
	<1291801990.5992.105.camel@i7.infradead.org>
	<20101208174603.GA7107@core.coreip.homeip.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Dec 2010 09:46:04 -0800 Dmitry Torokhov wrote:

> On Wed, Dec 08, 2010 at 09:53:09AM +0000, David Woodhouse wrote:
> > On Wed, 2010-12-08 at 10:12 +0100, Corentin Chary wrote:
> > > 
> > > I don't really see how it's a recursive dependency, but maybe it's
> > > time to clean this KConfig.
> > > What is our current policy about that ?
> > > 
> > > I think we should *depends* on important subsystem (ACPI, INPUT, ...)
> > > and select obscure things so
> > > that the driver does not get lost if you don't enable the leds.
> > 
> > A better policy is: "NEVER USE SELECT".
> > 
> 
> No, this is BS. User selecting, for example, a button driver should not
> care that it is working in polling mode only and needs polled device
> library to work. As it was said before, drivers need to depend on major
> subsystems and select minors and library modules.

I dislike select, but reality is that modules do need to select/enable
library code and minor features sometimes.

OTOH, where drivers/platform/x86/Kconfig:ACPI_CMPC does "select INPUT"
to enable an entire subsystem is wrong and bad IMO.


> The fact that our Kconfig can't really provide us with the functionality
> we desire (be it because the logic is fuzzy and hard to formalize or
> some other reason) shoud not force "NO SELECT" policy, we just need to
> be careful when using it.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
