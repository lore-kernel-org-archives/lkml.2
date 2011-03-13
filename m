Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543Ab1CMQ7G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 12:59:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54926 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189Ab1CMQ7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 12:59:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: andy.green@linaro.org
Subject: Re: [RFC PATCH 1/4] PLATFORM: introduce structure to bind async platform data to a dev path name
Date: Sun, 13 Mar 2011 17:58:47 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.38-rc8+; KDE/4.6.0; x86_64; ; )
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, patches@linaro.org
References: <20110312222633.27020.19543.stgit@otae.warmcat.com> <201103131351.36078.rjw@sisk.pl> <4D7CCC4D.801@linaro.org>
In-Reply-To: <4D7CCC4D.801@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103131758.47663.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, March 13, 2011, Andy Green wrote:
> On 03/13/2011 12:51 PM, Somebody in the thread at some point said:
> 
> >> Okay.  This is not a PC we are talking about.
> >>
> >> If the platform / board definition file is registering the USB hosts
> >> synchronously at boot time, the driver is composed into the monolithic
> >> kernel, there are no PCI busses or whatever on the SoC, the bus indexing
> >> is totally deterministic.  This is extremely common in the platform /
> >> SoC case and is the case the patchset is targeted at.  Even further, the
> >> only time you'd use it is to reach a USB asset that is wired up the same
> >> board permanently as well.
> >>
> >> Anyway this seems moot by now.
> >
> > However, if you add a new infrastructure like this, it should be at least
> > usable on systems that you description doesn't apply to.
> 
> Sounds reasonable, except the platform data is coming from a 
> board-specific board definition file at boot-time to talk about assets 
> that are on fixed interfaces of a specific board.

I'm not sure how this contradicts what I said above.

> It's not really applicable to wider generic bus use, just like platform_data
> usually isn't and has to be targeted at "device at XYZ on I2C bus n" with 
> knowledge of what driver is bound to that device.  Despite that 
> "impedence mismatch", it covers the SoC onboard USB asset case just fine 
> as it is.

So, you want to have a mechanism telling the driver "if the device
happens to have this particular path, use that platform data", right?

And it works because the initialization code kind of knows what path the
device is going to be at, so it can predict that and provide the mathing data.

Unfortunately, this relies on how device paths are constructed at the moment,
so if this approach is adopted in general, it will prevent us from changing
that way in the future (or at least it will make that very difficult).

Perhaps you could use some other kind of device identification here?

Rafael
