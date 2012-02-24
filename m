Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757127Ab2BXK1o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 05:27:44 -0500
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:55510
	"EHLO AM1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756563Ab2BXK1m convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 05:27:42 -0500
X-SpamScore: -18
X-BigFish: VS-18(zz9371I179dN542M1432N98dKzz1202hzzz2dh2a8h668h839h8e2h8e3h946hbe9k)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Liu Shengzhou-B36685 <B36685@freescale.com>
To: "balbi@ti.com" <balbi@ti.com>, "Eibach, Dirk" <Eibach@gdsys.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>
Subject: RE: Commit 529febe breaks usb on Freescale P1022
Thread-Topic: Commit 529febe breaks usb on Freescale P1022
Thread-Index: Aczyzrz7Op4ygo1gSgGaOHDIktPOMwAAI4WAABAGdoAADIzlkA==
Date: Fri, 24 Feb 2012 10:27:36 +0000
Message-ID: <3F453DDFF675A64A89321A1F3528102170B1BA@039-SN1MPN1-004.039d.mgd.msft.net>
References: <48D3D52125C49B43AE880038E2E5314BB5BF89@SRV101.gdsys.de>
 <20120224100513.GH17178@legolas.emea.dhcp.ti.com>
 <48D3D52125C49B43AE880038E2E5314BB5BF8C@SRV101.gdsys.de>
 <20120224101432.GK17178@legolas.emea.dhcp.ti.com>
In-Reply-To: <20120224101432.GK17178@legolas.emea.dhcp.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.193.20.89]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: Felipe Balbi [mailto:balbi@ti.com]
> Sent: Friday, February 24, 2012 6:15 PM
> To: Eibach, Dirk
> Cc: balbi@ti.com; Liu Shengzhou-B36685; linux-kernel@vger.kernel.org;
> gregkh@linuxfoundation.org; linux-usb@vger.kernel.org;
> stern@rowland.harvard.edu
> Subject: Re: Commit 529febe breaks usb on Freescale P1022
> 
> Hi,
> 
> On Fri, Feb 24, 2012 at 11:11:46AM +0100, Eibach, Dirk wrote:
> >
> >
> > > > This commit introduces a check for the USB PHY clock.
> > > > Problem is that CTRL_PHY_CLK_VALID bit seems not to be
> > > present on all
> > > > Freescale ehci implementations, at least P1022 does not have it.
> > > > So this check always fails and the driver never gets loaded.
> > >
> > > hmm, you would need a revision check on that function then.
> >
> > Since I have no idea which Freescale platforms provide this bit and
> > which platforms don't, I suggest withdrawing this commit and do some
> > investigation on Freescales side to do this properly.
> 
> Could be, but I would like to hear from Shengzhou first. Not sure what
> Greg thinks though :-)
> 
> --
> balbi

Hello,  

Just now I checked it on P1022, P1022 does not have this bit.
So far what I know as below: 
       - P1023/P3041/P5020 have this bit, and mentions it in RM.
       - P3060/4080/PSC913x do have this bit, but not mentioned in RM.
       - P1022 have no this bit, not mention it in RM.

I'm confirming this on more chips and will work out a new patch to fix it.

Regards,
Shengzhou

