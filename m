Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756976Ab0DIUjh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 16:39:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44862 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754568Ab0DIUje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 16:39:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Michal Hocko <mhocko@suse.cz>
Subject: Re: commit 9630bdd9 changes behavior of the poweroff - bug?
Date: Fri, 9 Apr 2010 22:42:17 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc3-rjw; KDE/4.3.5; x86_64; ; )
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Tony Vroon <tony@linx.net>
References: <20100401133923.GA4104@tiehlicka.suse.cz> <20100408094905.GA3948@tiehlicka.suse.cz> <201004082243.18393.rjw@sisk.pl>
In-Reply-To: <201004082243.18393.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004092242.17341.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 April 2010, Rafael J. Wysocki wrote:
> On Thursday 08 April 2010, Michal Hocko wrote:
> > On Wed 07-04-10 21:49:23, Rafael J. Wysocki wrote:
> > > On Wednesday 07 April 2010, Michal Hocko wrote:
> > > > Sorry for late reply, but I was AFK during holiday.
> > > > 
> > > > On Fri 02-04-10 21:31:47, Rafael J. Wysocki wrote:
> > > > > On Thursday 01 April 2010, Michal Hocko wrote:
> > > > > > On Thu 01-04-10 14:45:35, Matthew Garrett wrote:
> > > > > > > On Thu, Apr 01, 2010 at 03:39:23PM +0200, Michal Hocko wrote:
> > > > > > > > Hi Rafael, Matthew,
> > > > > > > > my laptop changed behavior during poweroff recently (after upgrading
> > > > > > > > from .33 to .34-rc1). The system seems to be powered off (status display
> > > > > > > > is off) at first glance but when I close the lid then I can hear a noise
> > > > > > > > which sounds like HDD parking and when I open lid again it starts
> > > > > > > > booting without poweroff button (same like when I suspend to RAM).
> > > > > > > 
> > > > > > > Hm. At a guess, we're somehow managing to leave the lid GPE enabled at 
> > > > > > > poweroff. Can you send the output of the acpidump command?
> > > > > > 
> > > > > > Sure, see attached.
> > > > > 
> > > > > Thanks.
> > > > > 
> > > > > Please also send the contents of /proc/acpi/wakeup.
> > > > 
> > > > See attached. I have checked both kernels (with and without reverted
> > > > 9630bdd) and the output looks pretty much same. 2.6.34-rc3, however,
> > > > looks different a bit, so I am attaching it as well.
> > > 
> > > Well, I fail to see the possible failure scenario, so let's first try a blind
> > > shot.
> > > 
> > > Please check if this patch helps:
> > > https://patchwork.kernel.org/patch/86238/
> > 
> > No change, sorry. I have tried that on top of 0fdf867 which is not the
> > most recent one (does it make sense to retest on the most recent one
> > f5284e7?)
> 
> There were no other changes in that area I know of, but the current git
> contains the above patch, so I'd recommend to use it for further testing.
> 
> I'll try to prepare a debug patch for this issue.

Please check if the patch below changes anything.

Rafael

---
 drivers/acpi/wakeup.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/acpi/wakeup.c
===================================================================
--- linux-2.6.orig/drivers/acpi/wakeup.c
+++ linux-2.6/drivers/acpi/wakeup.c
@@ -71,9 +71,9 @@ void acpi_enable_wakeup_device(u8 sleep_
 		    || sleep_state > (u32) dev->wakeup.sleep_state)
 			continue;
 
-		/* The wake-up power should have been enabled already. */
+		/* The wake-up power should have been enabled already.
 		acpi_set_gpe(dev->wakeup.gpe_device, dev->wakeup.gpe_number,
-				ACPI_GPE_ENABLE);
+				ACPI_GPE_ENABLE);*/
 	}
 }
 
