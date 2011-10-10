Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645Ab1JJRhZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 13:37:25 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:27834 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750893Ab1JJRhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 13:37:24 -0400
Date: Mon, 10 Oct 2011 10:37:22 -0700 (PDT)
From: Andrei Warkentin <awarkentin@vmware.com>
To: Greg KH <greg@kroah.com>
Cc: "G, Manjunath Kondaiah" <manjugk@ti.com>,
        linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>, linux-omap@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dilan Lee <dilee@nvidia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, Manjunath@jasper.es,
        Josh Triplett <josh@joshtriplett.org>
Message-ID: <361419345.198335.1318268242916.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
In-Reply-To: <20111008155502.GB616@kroah.com>
Subject: Re: [PATCH 2/5] drivercore: Add driver probe deferral mechanism
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.113.61.162]
X-Mailer: Zimbra 7.1.1_GA_3225 (ZimbraWebClient - FF3.0 (Linux)/7.1.1_GA_3225)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

----- Original Message -----
> From: "Greg KH" <greg@kroah.com>
> To: "Josh Triplett" <josh@joshtriplett.org>
> Cc: "G, Manjunath Kondaiah" <manjugk@ti.com>, linux-arm-kernel@lists.infradead.org, "Grant Likely"
> <grant.likely@secretlab.ca>, linux-omap@vger.kernel.org, linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
> "Dilan Lee" <dilee@nvidia.com>, "Mark Brown" <broonie@opensource.wolfsonmicro.com>, Manjunath@jasper.es
> Sent: Saturday, October 8, 2011 11:55:02 AM
> Subject: Re: [PATCH 2/5] drivercore: Add driver probe deferral mechanism
> 

I'm a bit of a fly on the wall here, but I'm curious how this impacts suspend/resume.
device_initialize->device_pm_init are called from device_register, so certainly this
patch doesn't also ensure that the PM ordering matches probe ordering, which is bound
to break suspend, right? Was this ever tested with the OMAP target? Shouldn't the
PM change be also part of this patch set? I don't see why you would want to have this in
without the PM changes.

Maybe I have it all wrong though :-).

A
