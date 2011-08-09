Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196Ab1HIOiQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 10:38:16 -0400
Received: from cernmx31.cern.ch ([137.138.144.179]:53423 "EHLO
	CERNMX31.cern.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab1HIOiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 10:38:15 -0400
Date: Tue, 9 Aug 2011 16:35:09 +0200
From: Manohar Vanga <manohar.vanga@cern.ch>
To: Martyn Welch <martyn.welch@ge.com>
CC: "Emilio G. Cota" <cota@braap.org>, <gregkh@suse.de>,
        <devel@driverdev.osuosl.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/8] staging: vme: add functions for bridge module
 refcounting
Message-ID: <20110809143509.GA10411@becoht-mvanga>
Mail-Followup-To: Martyn Welch <martyn.welch@ge.com>,
	"Emilio G. Cota" <cota@braap.org>, gregkh@suse.de,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <4E39555C.30507@ge.com>
 <20110803140630.GA29460@becoht-mvanga>
 <20110803152317.GA21903@flamenco.cs.columbia.edu>
 <4E3A4904.3040007@ge.com>
 <20110804163451.GA18422@flamenco.cs.columbia.edu>
 <4E3B9FA2.3060303@ge.com>
 <20110805090416.GA4806@becoht-mvanga>
 <4E3BB6E7.6020809@ge.com>
 <20110809132413.GA9762@becoht-mvanga>
 <4E414381.7070808@ge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4E414381.7070808@ge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [137.138.192.18]
Keywords: CERN SpamKiller Note: -50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Martyn,

> > I am not really an expert in these matters but would something like a sysfs file
> > be a cleaner approach to providing information on allocated resources within the
> > driver?
> 
> That would probably be a better idea.

Great! We'll add a sysfs file for this :)

> >     int ret = 0;
> >     ...
> >     vme_bridge_get(bridge);
> >     if (driver->probe)
> >             ret = driver->probe(vdev);
> >     if (ret)
> >         vme_bridge_put(bridge);
> >     return ret;
> 
> After looking at the PCI and RapidIO subsystems, I think this is probably the
> correct approach. I guess the only quiestion then is at which point is
> vme_bridge_put() called assuming the probe is successful. I guess at module
> unload time, though I haven't checked in the PCI and RapidIO code.

vme_bus_remove()? If it's incorrect, we can always change this later.

If we are agreed on this, let me know and I will make the changes and
resend the patches today.

> (Thank you for your patience)

(no problem)!

Thanks!

--
/manohar
