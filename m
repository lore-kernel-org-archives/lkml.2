Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366Ab1KHUPM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 15:15:12 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:50577 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab1KHUPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 15:15:10 -0500
Date: Tue, 8 Nov 2011 20:15:07 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alessandro Suardi <alessandro.suardi@gmail.com>,
        platform-driver-x86@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.2-rc1
Message-ID: <20111108201507.GA16883@srcf.ucam.org>
References: <CA+55aFzytqbGcOzWvYAo-EnJCeK5mFqdCF5OjMTeM5UBfeyCXw@mail.gmail.com>
 <CAKWSe6Dr7G3TgeMiff=hrT1bMc+StnXdtW0MEmQcuA5yFOWJYw@mail.gmail.com>
 <CA+55aFyojS9n=jP07X2BcxZ5z8YkBaZnNnthTs8xBkdtBdK1XA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFyojS9n=jP07X2BcxZ5z8YkBaZnNnthTs8xBkdtBdK1XA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 08, 2011 at 12:13:16PM -0800, Linus Torvalds wrote:
> On Tue, Nov 8, 2011 at 6:53 AM, Alessandro Suardi
> <alessandro.suardi@gmail.com> wrote:
> >
> > Dell laptop support (and I'd suspect other drivers using LED support)
> >  doesn't build with undefined LED-related functions, as in:
> >
> > ERROR: "led_classdev_unregister" [drivers/platform/x86/dell-laptop.ko]
> > undefined!
> > ERROR: "led_classdev_register" [drivers/platform/x86/dell-laptop.ko] undefined!
> > make[1]: *** [__modpost] Error 1
> > make: *** [modules] Error 2
> >
> > It's enough to configure NEW_LEDS (unneeded in 3.1.0) to allow the build to go
> >  through; maybe NEW_LEDS should be auto-selected in Kconfig by drivers that
> >  make use of led_classdev_* functions ?
> 
> Yeah, that sounds like the right fix. There are a lot of "select
> NEW_LEDS" around already, but apparently not the Dell driver.

Sorry, missed that change. Yes, that sounds completely reasonable.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
