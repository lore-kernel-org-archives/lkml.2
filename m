Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751563Ab1KIBB2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 20:01:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34954 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071Ab1KIBB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 20:01:27 -0500
Date: Tue, 8 Nov 2011 16:49:03 -0800
From: Greg KH <gregkh@suse.de>
To: KY Srinivasan <kys@microsoft.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "joe@perches.com" <joe@perches.com>,
        "jkosina@suse.cz" <jkosina@suse.cz>
Subject: Re: [PATCH 1/1] Staging: hv: Move the mouse driver out of staging
Message-ID: <20111109004903.GA2144@suse.de>
References: <1319841316-29136-1-git-send-email-kys@microsoft.com>
 <20111105064739.GA31111@core.coreip.homeip.net>
 <6E21E5352C11B742B20C142EB499E0481AA68580@TK5EX14MBXC128.redmond.corp.microsoft.com>
 <20111107055109.GA21095@core.coreip.homeip.net>
 <6E21E5352C11B742B20C142EB499E0481AA69FD0@TK5EX14MBXC128.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E0481AA69FD0@TK5EX14MBXC128.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 09, 2011 at 12:45:30AM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> > Sent: Monday, November 07, 2011 12:51 AM
> > To: KY Srinivasan
> > Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; virtualization@lists.osdl.org; ohering@suse.com;
> > joe@perches.com; jkosina@suse.cz
> > Subject: Re: [PATCH 1/1] Staging: hv: Move the mouse driver out of staging
> > 
> > Hi K. Y,
> > 
> > On Mon, Nov 07, 2011 at 01:04:53AM +0000, KY Srinivasan wrote:
> > >
> > >
> > > > -----Original Message-----
> > > > From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> > > > Sent: Saturday, November 05, 2011 2:48 AM
> > > > To: KY Srinivasan
> > > > Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> > > > devel@linuxdriverproject.org; virtualization@lists.osdl.org;
> > ohering@suse.com;
> > > > joe@perches.com; jkosina@suse.cz
> > > > Subject: Re: [PATCH 1/1] Staging: hv: Move the mouse driver out of staging
> > > >
> > > > Hi KY,
> > >
> > > Dimitry,
> > >
> > > Let me begin by thanking you for taking the time to review. I have incorporated
> > > pretty much all your suggestions.
> > 
> > Thank you very much for considering my suggestions.
> 
> > 
> > > >
> > > > Instead of potentially ever-increasing buffer that you also allocate
> > > > (and it looks like leaking on every callback invocation) can you just
> > > > repeat the read if you know that there are more data and use single
> > > > pre-allocated buffer?
> > >
> > > The ring-buffer protocol is such that we need to consume the full message.
> > > Also, why do you say we are leaking memory?
> > 
> > Ah, OK, I see, we keep reading until read returns 0-sized reply and then
> > we free the buffer... Never mind then.
> > 
> > > > > +
> > > > > +	hid_dev->ll_driver = &mousevsc_ll_driver;
> > > > > +	hid_dev->driver = &mousevsc_hid_driver;
> > > >
> > > > You are not really hid driver; you are more of a "provider" so why do
> > > > you need to set hid_dev->driver in addition to hid_dev->ll_driver?
> > > >
> > > True, but hid_parse_report() expects that the driver field be set; so I
> > > need to fake this.
> > 
> > If you supply .parse() method for your mousevsc_ll_driver structure and
> > call hid_parse_report() from it then HID core will set the default
> > driver and call parse at appropriate time.
> 
> Would it be ok if I were to make this change after Jiri accepts the driver out of staging?

Why not fix this now?  No need to take a driver that is known to have
issues, right?

greg k-h
