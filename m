Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581Ab1BJQG1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 11:06:27 -0500
Received: from tomasu.net ([64.85.170.234]:52842 "EHLO mail.tomasu.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752287Ab1BJQG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 11:06:26 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Feb 2011 11:06:26 EST
From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Reply-To: thomas@fjellstrom.ca
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Wake On lan and ATL1 nic
Date: Thu, 10 Feb 2011 08:59:38 -0700
User-Agent: KMail/1.13.5 (Linux/2.6.36.1+; KDE/4.5.2; x86_64; svn-1188918; 2010-10-21)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
References: <201012141756.59591.thomas@fjellstrom.ca> <201012230832.00443.thomas@fjellstrom.ca> <201012232159.00654.rjw@sisk.pl>
In-Reply-To: <201012232159.00654.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102100859.39059.thomas@fjellstrom.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On December 23, 2010, Rafael J. Wysocki wrote:
> On Thursday, December 23, 2010, Thomas Fjellstrom wrote:
> > On December 22, 2010, Rafael J. Wysocki wrote:
> > > On Wednesday, December 15, 2010, Thomas Fjellstrom wrote:
> > > > I can't seem to get wol to work with my desktop, which has an
> > > > integrated ATL1 GbE nic. I can't be absolutely sure if it ever
> > > > worked, but I think it did at one point. I can use ethtool to look
> > > > at the wol status, that it supports magic-packet wol, and I can
> > > > enable it, which is done at boot using an init script. But No matter
> > > > how many times I try to send a wol packet to that machine it never
> > > > wakes up.
> > > > 
> > > > Looking around on the net seems to say it is supported, and should
> > > > work, but I'm not having any luck. Anyone have any hints?
> > > 
> > > It works for me with 2.6.37-rc7 and the appended patch applied (at
> > > least the machine is woken up from suspend to RAM).  Of course, the
> > > adapter needs to be configured for that with the help of ethtool.
> > 
> > Hi, thanks for making quick work of this. I have one slight problem, my
> > nic seems to use the atl1 driver, and not atl1c. I've tried using atl1c
> > and atl1e, both will load if I modprobe them, but neither actually bring
> > up the device. Even tried blacklisting atl1 first.
> 
> I see.
> 
> Please try the patch below, then.  It's analogous to the atl1c one, but
> it's untested (builds for me).
> 
> Thanks,
> Rafael
> 
> 

Hi, I just (finally) got around to testing this, and it all works now! thanks a 
lot. Though to be honest, it may not have had an impact. I noticed my BIOS 
settings for PCI device wakeup had been disabled (I could swear they were on, 
but after testing the patch, and wol STILL didn't work, I didn't have any 
other ideas...). And it seems WOL now works on both an unpatched 
2.6.36.1+autogroup, and a patched 2.6.37.

I haven't done any significant testing of this patch, other than the machine 
boots, the network comes up, and WOL works.

If you have any things you want me to try, to make sure the patch is correct, 
let me know.

Thanks again for working on the patches.

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
