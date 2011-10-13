Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831Ab1JMOSL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 10:18:11 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56024 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218Ab1JMOSI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 10:18:08 -0400
MIME-Version: 1.0
In-Reply-To: <20111013040923.GE15829@ponder.secretlab.ca>
References: <20111008155502.GB616@kroah.com>
	<361419345.198335.1318268242916.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
	<CACVXFVMnt-ChUDhawhoyMm-wJ8xSQAWs1c8ykzmyshfX49HEsw@mail.gmail.com>
	<20111013040923.GE15829@ponder.secretlab.ca>
Date: Thu, 13 Oct 2011 22:18:07 +0800
Message-ID: <CACVXFVNXyzzJw7UK+OFuDe23voQvyywoP9AvUsV=iPDFPO4fPw@mail.gmail.com>
Subject: Re: [PATCH 2/5] drivercore: Add driver probe deferral mechanism
From: Ming Lei <tom.leiming@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Andrei Warkentin <awarkentin@vmware.com>, Greg KH <greg@kroah.com>,
        Dilan Lee <dilee@nvidia.com>, "G, Manjunath Kondaiah" <manjugk@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>, Manjunath@jasper.es,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Linux PM List <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC Rafael and linux-pm

On Thu, Oct 13, 2011 at 12:09 PM, Grant Likely
<grant.likely@secretlab.ca> wrote:
> On Tue, Oct 11, 2011 at 08:29:18PM +0800, Ming Lei wrote:
>> On Tue, Oct 11, 2011 at 1:37 AM, Andrei Warkentin <awarkentin@vmware.com> wrote:
>> > Hi,
>> >
>> > ----- Original Message -----
>> >> From: "Greg KH" <greg@kroah.com>
>> >> To: "Josh Triplett" <josh@joshtriplett.org>
>> >> Cc: "G, Manjunath Kondaiah" <manjugk@ti.com>, linux-arm-kernel@lists.infradead.org, "Grant Likely"
>> >> <grant.likely@secretlab.ca>, linux-omap@vger.kernel.org, linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
>> >> "Dilan Lee" <dilee@nvidia.com>, "Mark Brown" <broonie@opensource.wolfsonmicro.com>, Manjunath@jasper.es
>> >> Sent: Saturday, October 8, 2011 11:55:02 AM
>> >> Subject: Re: [PATCH 2/5] drivercore: Add driver probe deferral mechanism
>> >>
>> >
>> > I'm a bit of a fly on the wall here, but I'm curious how this impacts suspend/resume.
>> > device_initialize->device_pm_init are called from device_register, so certainly this
>> > patch doesn't also ensure that the PM ordering matches probe ordering, which is bound
>> > to break suspend, right? Was this ever tested with the OMAP target? Shouldn't the
>>
>> Inside device_add(), device_pm_add is called before bus_probe_device,
>> so the patch can't change the device order in pm list, and just change
>> the driver probe order.
>
> That's the way it works now, but can it be reworked?  It would be

IMO, it depends on what shape you plan to rework.  Currently, the
deferred probe may found a resource dependency, but I am not sure
that pm dependency is same with the resource dependency found
during probe.

> possible to adjust the list order after successful probe.  However,
> I'm not clear on the ordering rules for the dpm_list.  Right now it is
> explicitly ordered to have parents before children, but as already
> expressed, that doesn't accurately represent ordering constraints for
> multiple device dependancies.

Maybe we should understand the correct model of the ordering constraints
for the multiple device dependancies first, could you give a description or
some examples about it?

>
> So, reordering the list would probably require maintaining the
> existing parent-child ordering constraint, but to also shift
> devices (and any possible children?) to be after drivers that are
> already probed.  That alone will be difficult to implement and get
> right, but maybe the constraints can be simplified.  It needs some
> further thought.
>
> g.
>
>


thanks,
-- 
Ming Lei
