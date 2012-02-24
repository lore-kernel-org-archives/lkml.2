Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758133Ab2BXVMv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 16:12:51 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41737 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756593Ab2BXVMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 16:12:50 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.196.161 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
Date: Fri, 24 Feb 2012 13:07:06 -0800
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Liu Shengzhou-B36685 <B36685@freescale.com>,
        "Eibach, Dirk" <Eibach@gdsys.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>
Subject: Re: Commit 529febe breaks usb on Freescale P1022
Message-ID: <20120224210706.GA13759@kroah.com>
References: <48D3D52125C49B43AE880038E2E5314BB5BF89@SRV101.gdsys.de>
 <20120224100513.GH17178@legolas.emea.dhcp.ti.com>
 <48D3D52125C49B43AE880038E2E5314BB5BF8C@SRV101.gdsys.de>
 <20120224101432.GK17178@legolas.emea.dhcp.ti.com>
 <3F453DDFF675A64A89321A1F3528102170B1BA@039-SN1MPN1-004.039d.mgd.msft.net>
 <20120224144549.GR17178@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120224144549.GR17178@legolas.emea.dhcp.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 04:45:50PM +0200, Felipe Balbi wrote:
> On Fri, Feb 24, 2012 at 10:27:36AM +0000, Liu Shengzhou-B36685 wrote:
> > 
> > > -----Original Message-----
> > > From: Felipe Balbi [mailto:balbi@ti.com]
> > > Sent: Friday, February 24, 2012 6:15 PM
> > > To: Eibach, Dirk
> > > Cc: balbi@ti.com; Liu Shengzhou-B36685; linux-kernel@vger.kernel.org;
> > > gregkh@linuxfoundation.org; linux-usb@vger.kernel.org;
> > > stern@rowland.harvard.edu
> > > Subject: Re: Commit 529febe breaks usb on Freescale P1022
> > > 
> > > Hi,
> > > 
> > > On Fri, Feb 24, 2012 at 11:11:46AM +0100, Eibach, Dirk wrote:
> > > >
> > > >
> > > > > > This commit introduces a check for the USB PHY clock.
> > > > > > Problem is that CTRL_PHY_CLK_VALID bit seems not to be
> > > > > present on all
> > > > > > Freescale ehci implementations, at least P1022 does not have it.
> > > > > > So this check always fails and the driver never gets loaded.
> > > > >
> > > > > hmm, you would need a revision check on that function then.
> > > >
> > > > Since I have no idea which Freescale platforms provide this bit and
> > > > which platforms don't, I suggest withdrawing this commit and do some
> > > > investigation on Freescales side to do this properly.
> > > 
> > > Could be, but I would like to hear from Shengzhou first. Not sure what
> > > Greg thinks though :-)
> > > 
> > > --
> > > balbi
> > 
> > Hello,  
> > 
> > Just now I checked it on P1022, P1022 does not have this bit.
> > So far what I know as below: 
> >        - P1023/P3041/P5020 have this bit, and mentions it in RM.
> >        - P3060/4080/PSC913x do have this bit, but not mentioned in RM.
> >        - P1022 have no this bit, not mention it in RM.
> > 
> > I'm confirming this on more chips and will work out a new patch to fix it.
> 
> Ok, Greg will have the final word whether the original commit should be
> reverted or we wait for a fix from you.

If I can get a fix that works soon, I'll take it, and not revert the
original...
