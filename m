Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625Ab1C1Ook (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 10:44:40 -0400
Received: from cantor.suse.de ([195.135.220.2]:36344 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754577Ab1C1Ooj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 10:44:39 -0400
Date: Mon, 28 Mar 2011 07:39:55 -0700
From: Greg KH <gregkh@suse.de>
To: Par-Gunnar HJALMDAHL <par-gunnar.p.hjalmdahl@stericsson.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        Pavan Savoy <pavan_savoy@sify.com>, Vitaly Wool <vitalywool@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Marcel Holtmann <marcel@holtmann.org>,
        Lukasz Rymanowski <Lukasz.Rymanowski@tieto.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Par-Gunnar Hjalmdahl <pghatwork@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: Re: [PATCH v2 2/2] mach-ux500: Add CG2900 devices
Message-ID: <20110328143955.GB23892@suse.de>
References: <1301302992-10671-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com>
 <201103281500.38954.arnd@arndb.de>
 <20110328141237.GB19350@suse.de>
 <AFCDDB4A3EA003429EEF1E7B211FDBBA3377B51A1F@EXDCVYMBSTM005.EQ1STM.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AFCDDB4A3EA003429EEF1E7B211FDBBA3377B51A1F@EXDCVYMBSTM005.EQ1STM.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 04:29:44PM +0200, Par-Gunnar HJALMDAHL wrote:
> > >
> > > Not exactly what I had in mind, but probably good enough for a start.
> > > This adds a dependency from core code to the staging driver now,
> > > which shouldn't be there. I suppose we can add
> > >
> > > "Clean up device registration path to register the main device from
> > board code"
> > >
> > > to the TODO file.
> > 
> > No, please do not make any core code dependant on a staging driver,
> > this
> > isn't ok, it needs to be stand-alone, or at the least, the rest of the
> > kernel needs to be able to be built with no staging drivers enabled.
> > 
> > thanks,
> > 
> > greg k-h
> 
> But how should I then do this? As I understood it I was told that I should
> call an init function, but I was not allowed to add any staging folder
> inclusion in the board config makefile. And now I can't do any extern
> declaration either. I don't really see how I could do it then.

Why can't you add a staging folder inclusion?  You could do that, and
properly set up your .h file so that if the driver is not built, your
code still properly builds and runs.

thanks,

greg k-h
