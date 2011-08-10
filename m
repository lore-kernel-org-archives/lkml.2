Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751265Ab1HJG4D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 02:56:03 -0400
Received: from cernmx31.cern.ch ([137.138.144.179]:17112 "EHLO
	CERNMX31.cern.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab1HJG4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 02:56:02 -0400
Date: Wed, 10 Aug 2011 08:52:54 +0200
From: Manohar Vanga <manohar.vanga@cern.ch>
To: "Emilio G. Cota" <cota@braap.org>
CC: Martyn Welch <martyn.welch@ge.com>, <gregkh@suse.de>,
        <devel@driverdev.osuosl.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/8] staging: vme: add functions for bridge module
 refcounting
Message-ID: <20110810065254.GA27642@becoht-mvanga>
Mail-Followup-To: "Emilio G. Cota" <cota@braap.org>,
	Martyn Welch <martyn.welch@ge.com>, gregkh@suse.de,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <20110803140630.GA29460@becoht-mvanga>
 <20110803152317.GA21903@flamenco.cs.columbia.edu>
 <4E3A4904.3040007@ge.com>
 <20110804163451.GA18422@flamenco.cs.columbia.edu>
 <4E3B9FA2.3060303@ge.com>
 <20110805090416.GA4806@becoht-mvanga>
 <4E3BB6E7.6020809@ge.com>
 <20110809132413.GA9762@becoht-mvanga>
 <4E414381.7070808@ge.com>
 <20110809184944.GA28746@flamenco.cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110809184944.GA28746@flamenco.cs.columbia.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [137.138.192.18]
Keywords: CERN SpamKiller Note: -50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Emilio,

> This works as long as all devices are tied to the driver
> loading; i.e. when the devices can only be removed when the
> driver is removed.  A device might go away while the driver
> still manages other devices of the same kin; this is why
> particular drivers explicitly manage the get/put in
> .probe/.release.

I have still left the exports for the refcounting functions
intact so border case drivers are free to use these explicitly
(albeit on top of the automatic refcounting in .probe and
.remove).

> In vme we may one day have hotplug (VME64x supports it IIRC),
> but we're not quite there yet. One can remove devices from
> sysfs anytime though.

Won't this event trigger the .remove function? If it does, it
shouldn't be a problem.

> I still think the original patch is the sane way to go.

I think this approach is a good middle ground between both
arguments. If we really run into major issues with this
(which I somewhat doubt will happen), we can always fix
things up. It's not immutable!

Thanks!

--
/manohar
