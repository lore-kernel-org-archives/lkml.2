Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619Ab1JKM3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 08:29:20 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43587 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961Ab1JKM3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 08:29:19 -0400
MIME-Version: 1.0
In-Reply-To: <361419345.198335.1318268242916.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
References: <20111008155502.GB616@kroah.com>
	<361419345.198335.1318268242916.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
Date: Tue, 11 Oct 2011 20:29:18 +0800
Message-ID: <CACVXFVMnt-ChUDhawhoyMm-wJ8xSQAWs1c8ykzmyshfX49HEsw@mail.gmail.com>
Subject: Re: [PATCH 2/5] drivercore: Add driver probe deferral mechanism
From: Ming Lei <tom.leiming@gmail.com>
To: Andrei Warkentin <awarkentin@vmware.com>
Cc: Greg KH <greg@kroah.com>, Dilan Lee <dilee@nvidia.com>,
        "G, Manjunath Kondaiah" <manjugk@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>,
        Grant Likely <grant.likely@secretlab.ca>, Manjunath@jasper.es,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 11, 2011 at 1:37 AM, Andrei Warkentin <awarkentin@vmware.com> wrote:
> Hi,
>
> ----- Original Message -----
>> From: "Greg KH" <greg@kroah.com>
>> To: "Josh Triplett" <josh@joshtriplett.org>
>> Cc: "G, Manjunath Kondaiah" <manjugk@ti.com>, linux-arm-kernel@lists.infradead.org, "Grant Likely"
>> <grant.likely@secretlab.ca>, linux-omap@vger.kernel.org, linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
>> "Dilan Lee" <dilee@nvidia.com>, "Mark Brown" <broonie@opensource.wolfsonmicro.com>, Manjunath@jasper.es
>> Sent: Saturday, October 8, 2011 11:55:02 AM
>> Subject: Re: [PATCH 2/5] drivercore: Add driver probe deferral mechanism
>>
>
> I'm a bit of a fly on the wall here, but I'm curious how this impacts suspend/resume.
> device_initialize->device_pm_init are called from device_register, so certainly this
> patch doesn't also ensure that the PM ordering matches probe ordering, which is bound
> to break suspend, right? Was this ever tested with the OMAP target? Shouldn't the

Inside device_add(), device_pm_add is called before bus_probe_device,
so the patch can't change the device order in pm list, and just change
the driver probe order.

> PM change be also part of this patch set? I don't see why you would want to have this in
> without the PM changes.
>


thanks,
-- 
Ming Lei
