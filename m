Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526Ab0LHRqR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 12:46:17 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:65422 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257Ab0LHRqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 12:46:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=njmEMxurPuGEKYT4F35gToDkyz0bA6q6TywUdPo3+HmL3JiwOKNel9tPfafx8ZQWyK
         xoIo4xvIZeSULgXclG6RdMi07e2ybdcbTkLVLM0ZMm1GAY4bm6ja8+2drnv3gDAoHGGM
         jprssMOOHFulay/+Sn5gp2BY1M3E3uCq5TREc=
Date: Wed, 8 Dec 2010 09:46:04 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Corentin Chary <corentin.chary@gmail.com>, sedat.dilek@gmail.com,
        Matthew Garrett <mjg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: linux-next: Tree for December 8
 (drivers/platform/x86/Kconfig:422:error: recursive dependency detected!)
Message-ID: <20101208174603.GA7107@core.coreip.homeip.net>
References: <AANLkTim3FJjVpbjM10kJJhXbONpvGSGQFE+mfGX9pAS6@mail.gmail.com>
 <AANLkTimjVY-6OwRfFUzUbmyacM81M35wf5qDWqAouUYb@mail.gmail.com>
 <1291801990.5992.105.camel@i7.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291801990.5992.105.camel@i7.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 08, 2010 at 09:53:09AM +0000, David Woodhouse wrote:
> On Wed, 2010-12-08 at 10:12 +0100, Corentin Chary wrote:
> > 
> > I don't really see how it's a recursive dependency, but maybe it's
> > time to clean this KConfig.
> > What is our current policy about that ?
> > 
> > I think we should *depends* on important subsystem (ACPI, INPUT, ...)
> > and select obscure things so
> > that the driver does not get lost if you don't enable the leds.
> 
> A better policy is: "NEVER USE SELECT".
> 

No, this is BS. User selecting, for example, a button driver should not
care that it is working in polling mode only and needs polled device
library to work. As it was said before, drivers need to depend on major
subsystems and select minors and library modules.

The fact that our Kconfig can't really provide us with the functionality
we desire (be it because the logic is fuzzy and hard to formalize or
some other reason) shoud not force "NO SELECT" policy, we just need to
be careful when using it.

Thanks.

-- 
Dmitry
