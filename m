Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494Ab2IFNDb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 09:03:31 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:51965 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830Ab2IFND2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 09:03:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
Subject: Re: [PATCH v7 1/7] drivers: usb: phy: add a new driver for omap usb2 phy
Date: Thu, 6 Sep 2012 13:03:02 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Greg KH <gregkh@linuxfoundation.org>, Felipe Balbi <balbi@ti.com>,
        grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux@arm.linux.org.uk, b-cousson@ti.com, rnayak@ti.com,
        tony@atomide.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-usb@vger.kernel.org
References: <1344258480-4304-1-git-send-email-kishon@ti.com> <1344258480-4304-2-git-send-email-kishon@ti.com> <CAAe_U6KBNZpT03xATmPTNTgxm5hj+wJdsShdnm08EmF4Q=hTCw@mail.gmail.com>
In-Reply-To: <CAAe_U6KBNZpT03xATmPTNTgxm5hj+wJdsShdnm08EmF4Q=hTCw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209061303.02454.arnd@arndb.de>
X-Provags-ID: V02:K0:8GaIIT2SX9R3Xgsa0xZI0kJbg1BWkz76AQCna1Kf2Ym
 vEdUw1zotc0uPxUjvQoUK1Tp+KkHd28IBfHGnCW/3bbcnX8N1a
 rv12p6aGIBbDwOrc5tI0+Ih0JXyHOKWm5D7/4eBhMGOb/uWStm
 d1bA/sVWFw8k6dfUY/34xPknE2n7x7+f1xCI9AFak6HRaggFGl
 PleOzfvTlG46tRDz4cu8K8Ik+mmMn83MwceOYglpi0kqLdq4nC
 PBvpLW6ehu4MlaXg6XepvY1Vn6TSsDcPYwniuthHrzOZCYMCyG
 34YF30Kzszn25Yht5A4DEas3rY2uzoUEBq43dZf9Qpp8hEuUoy
 unNGBMcIifWuQvt9IVcA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 September 2012, ABRAHAM, KISHON VIJAY wrote:
> > diff --git a/Documentation/devicetree/bindings/bus/omap-ocp2scp.txt b/Documentation/devicetree/bindings/bus/omap-ocp2scp.txt
> > index d2fe064..bb0c7f4 100644
> > --- a/Documentation/devicetree/bindings/bus/omap-ocp2scp.txt
> > +++ b/Documentation/devicetree/bindings/bus/omap-ocp2scp.txt
> > @@ -8,3 +8,6 @@ properties:
> >
> >  Sub-nodes:
> >  All the devices connected to ocp2scp are described using sub-node to ocp2scp
> > +- usb2phy :
> > +   The binding details of usb2phy can be found in:
> > +   Documentation/devicetree/bindings/usb/omap-usb.txt
> 
> The above two lines should be added in omap-ocp2scp.txt (this file was
> added as part of omap: add ocp2scp as a bus driver and is in
> linux-next). However this file is still not in Felipe's xceiv branch.
> So I'm not sure how I can get this patch merged in Felipe's tree
> without conflict.
> 

There are three possible ways to do that:

* Not add that text. Is is actually required? The ocp2scp bus driver 
doesn't actually care what is connected to it, does it?

* Ask Felipe to merge the drivers/ocp2scp branch from arm-soc into
his branch, then apply your patch on top. The branch is scheduled
for merging in 3.7 and is stable, so there is no harm merging it
into his tree, as long as Olof and I are aware of this.

* Split out this change and apply the patch to add this documentation
change on top of the drivers/ocp2scp branch in the arm-soc tree.
There is no strict dependency between this change and the others
you want to merge, so it does not matter which tree it is merged through.

	Arnd
