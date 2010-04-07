Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932542Ab0DGHeY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 03:34:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45648 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932517Ab0DGHeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 03:34:17 -0400
Date: Wed, 7 Apr 2010 09:34:14 +0200
From: Michal Hocko <mhocko@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: commit 9630bdd9 changes behavior of the poweroff - bug?
Message-ID: <20100407073414.GA5174@tiehlicka.suse.cz>
References: <20100401133923.GA4104@tiehlicka.suse.cz>
 <20100401134535.GA6527@srcf.ucam.org>
 <20100401135359.GB4104@tiehlicka.suse.cz>
 <201004022131.47787.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ZGiS0Q5IWpPtfppv"
Content-Disposition: inline
In-Reply-To: <201004022131.47787.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Sorry for late reply, but I was AFK during holiday.

On Fri 02-04-10 21:31:47, Rafael J. Wysocki wrote:
> On Thursday 01 April 2010, Michal Hocko wrote:
> > On Thu 01-04-10 14:45:35, Matthew Garrett wrote:
> > > On Thu, Apr 01, 2010 at 03:39:23PM +0200, Michal Hocko wrote:
> > > > Hi Rafael, Matthew,
> > > > my laptop changed behavior during poweroff recently (after upgrading
> > > > from .33 to .34-rc1). The system seems to be powered off (status display
> > > > is off) at first glance but when I close the lid then I can hear a noise
> > > > which sounds like HDD parking and when I open lid again it starts
> > > > booting without poweroff button (same like when I suspend to RAM).
> > > 
> > > Hm. At a guess, we're somehow managing to leave the lid GPE enabled at 
> > > poweroff. Can you send the output of the acpidump command?
> > 
> > Sure, see attached.
> 
> Thanks.
> 
> Please also send the contents of /proc/acpi/wakeup.

See attached. I have checked both kernels (with and without reverted
9630bdd) and the output looks pretty much same. 2.6.34-rc3, however,
looks different a bit, so I am attaching it as well.

> 
> Rafael

-- 
Michal Hocko
L3 team 
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic

--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="acpi_wakeup-2.6.33-rc8-00213-g9630bdd"

Device	S-state	  Status   Sysfs node
PCIB	  S4	 disabled  pci:0000:00:1e.0
UAR1	  S3	 disabled  pnp:00:0a
USB1	  S3	 disabled  pci:0000:00:1d.0
USB2	  S3	 disabled  pci:0000:00:1d.1
USB3	  S3	 disabled  pci:0000:00:1d.2
USB4	  S3	 disabled  pci:0000:00:1d.3
USB7	  S3	 disabled  pci:0000:00:1d.7
MODM	  S3	 disabled  
HDEF	  S3	 disabled  pci:0000:00:1b.0
PXS1	  S4	 disabled  pci:0000:02:00.0
LID	  S4	*enabled   

--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="acpi_wakeup-2.6.34-rc3"

Device	S-state	  Status   Sysfs node
PCIB	  S4	*disabled  pci:0000:00:1e.0
UAR1	  S3	*disabled  pnp:00:0a
USB1	  S3	 disabled  pci:0000:00:1d.0
USB2	  S3	 disabled  pci:0000:00:1d.1
USB3	  S3	 disabled  pci:0000:00:1d.2
USB4	  S3	 disabled  pci:0000:00:1d.3
USB7	  S3	 disabled  pci:0000:00:1d.7
MODM	  S3	*disabled  
HDEF	  S3	*disabled  pci:0000:00:1b.0
PXS1	  S4	*disabled  pci:0000:02:00.0
LID	  S4	*enabled   

--ZGiS0Q5IWpPtfppv--
