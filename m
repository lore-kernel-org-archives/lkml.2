Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892Ab2CYVG0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 17:06:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34611 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751200Ab2CYVGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 17:06:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] Recent "Run the driver callback directly" patch breaks libertas suspend
Date: Sun, 25 Mar 2012 23:10:40 +0200
User-Agent: KMail/1.13.6 (Linux/3.3.0+; KDE/4.6.0; x86_64; ; )
Cc: NeilBrown <neilb@suse.de>, linux-pm@lists.linux-foundation.org,
        Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.1203251116290.16994-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1203251116290.16994-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203252310.40689.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, March 25, 2012, Alan Stern wrote:
> On Sun, 25 Mar 2012, NeilBrown wrote:
> 
> > Hi Rafael,
> > 
> >  Your recent patch:
> >    commit 35cd133c
> >    PM: Run the driver callback directly if the subsystem one is not there
> > 
> >  breaks suspend for my libertas wifi and probably other SDIO devices.
> > 
> >  SDIO (and possible MMC in general) has a protocol where the suspend
> >  method can return -ENOSYS and this means "There is no point in suspending,
> >  just turn me off".
> > 
> >  The device itself "mmc1:0001" (I think) doesn't have any bus etc 'suspend'
> >  function so the new code call the device's suspend function which returns
> >  ENOSYS and the suspend fails.
> > 
> >  The previous code ignores the device as there is no bus suspend, and when it
> >  gets to suspend the ancestor - which for me is omap_hsmmc.1, it calls the
> >  device suspend function catches the ENOSYS, and turns it off.
> > 
> >  I suspect just reverting it isn't the right long term solution, however I
> >  can confirm that it works for me for now.
> > 
> >  I'm happy to try any alternate fixes you would like to suggest (but I cannot
> >  promise how quickly I will get the testing done).
> 
> With a little restructuring, this might be a good application for
> pm_runtime_no_callbacks().

That won't cover system suspend, though.

Thanks,
Rafael
