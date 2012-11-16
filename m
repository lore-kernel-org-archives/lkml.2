Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537Ab2KPBZd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 20:25:33 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:47490 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151Ab2KPBZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 20:25:32 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Huang Ying <ying.huang@intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [BUGFIX] PM: Fix active child counting when disabled and forbidden
Date: Fri, 16 Nov 2012 02:29:54 +0100
Message-ID: <1965322.pSDJypqR3K@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc5; KDE/4.8.5; x86_64; ; )
In-Reply-To: <1353027296.7176.312.camel@yhuang-dev>
References: <Pine.LNX.4.44L0.1211141608200.1620-100000@iolanthe.rowland.org> <5403446.Qq6ASJZlmy@vostro.rjw.lan> <1353027296.7176.312.camel@yhuang-dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 16, 2012 08:54:56 AM Huang Ying wrote:
> On Fri, 2012-11-16 at 01:55 +0100, Rafael J. Wysocki wrote:
> > On Friday, November 16, 2012 01:44:00 AM Rafael J. Wysocki wrote:
> > > On Friday, November 16, 2012 08:36:14 AM Huang Ying wrote:
> > > > On Thu, 2012-11-15 at 10:51 +0100, Rafael J. Wysocki wrote:
> > 
> > [...]
> > 
> > > > 
> > > > For this situation, if user "echo auto > .../power/control" for the
> > > > device, the runtime PM callbacks of device will be called.  I think that
> > > > is not intended.  So I think it is better to use some kind of flag or
> > > > state for that.
> > > 
> > > I'm not sure what situation exactly you have in mind.  Care to give an
> > > exact scenario?
> > 
> > Ah, I see.  When we've just called drv->remove(), there is a window in
> > which user space may cause the driver's runtime PM callbacks to be
> > executed by changing its attribute to "auto".
> > 
> > So perhaps we should check pci_dev->driver rather than pci_dev->dev.driver
> > in the runtime PM callbacks?  With a few more changes that should allow us
> > to close that race.
> 
> Yes.  And I think, with pci_dev->driver (after some changes suggested by
> Alan), we need not to use pm_runtime_get/put_skip_callbacks().

Good.  Can you please prepare a patch, then? :-)

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
