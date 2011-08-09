Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198Ab1HIPFw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 11:05:52 -0400
Received: from exprod5og105.obsmtp.com ([64.18.0.180]:51577 "EHLO
	exprod5og105.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006Ab1HIPFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 11:05:40 -0400
Message-ID: <4E414CC0.2020701@ge.com>
Date: Tue, 09 Aug 2011 16:05:36 +0100
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: "Emilio G. Cota" <cota@braap.org>, gregkh@suse.de,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/8] staging: vme: add functions for bridge module refcounting
References: <4E39555C.30507@ge.com> <20110803140630.GA29460@becoht-mvanga> <20110803152317.GA21903@flamenco.cs.columbia.edu> <4E3A4904.3040007@ge.com> <20110804163451.GA18422@flamenco.cs.columbia.edu> <4E3B9FA2.3060303@ge.com> <20110805090416.GA4806@becoht-mvanga> <4E3BB6E7.6020809@ge.com> <20110809132413.GA9762@becoht-mvanga> <4E414381.7070808@ge.com> <20110809143509.GA10411@becoht-mvanga>
In-Reply-To: <20110809143509.GA10411@becoht-mvanga>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Aug 2011 15:02:20.0689 (UTC) FILETIME=[56734810:01CC56A5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/11 15:35, Manohar Vanga wrote:
> Hey Martyn,
> 
>>> I am not really an expert in these matters but would something like a sysfs file
>>> be a cleaner approach to providing information on allocated resources within the
>>> driver?
>>
>> That would probably be a better idea.
> 
> Great! We'll add a sysfs file for this :)
> 

I'm thinking either one for each resource type (slave, master, lm, dma) would
be great. Though it might also be nice to be able to track how each resource
is being used (though I guess that would be quite a bit of work).

>>>     int ret = 0;
>>>     ...
>>>     vme_bridge_get(bridge);
>>>     if (driver->probe)
>>>             ret = driver->probe(vdev);
>>>     if (ret)
>>>         vme_bridge_put(bridge);
>>>     return ret;
>>
>> After looking at the PCI and RapidIO subsystems, I think this is probably the
>> correct approach. I guess the only quiestion then is at which point is
>> vme_bridge_put() called assuming the probe is successful. I guess at module
>> unload time, though I haven't checked in the PCI and RapidIO code.
> 
> vme_bus_remove()? If it's incorrect, we can always change this later.
> 

Yes, that seems to follow how it's done in RapidIO.

> If we are agreed on this, let me know and I will make the changes and
> resend the patches today.
> 

RapidIO has rio_dev_get and rio_dev_put functions that are called in
rio_device_probe and rio_device_remove. This is equivalent to vme_bus_probe
and vme_bus_remove in the VME code. That seems to be a very appropriate
solution and I'd be happy with that.

Martyn

>> (Thank you for your patience)
> 
> (no problem)!
> 
> Thanks!
> 
> --
> /manohar


-- 
Martyn Welch (Principal Software Engineer) | Registered in England and
GE Intelligent Platforms                   | Wales (3828642) at 100
T +44(0)127322748                          | Barbirolli Square, Manchester,
E martyn.welch@ge.com                      | M2 3AB  VAT:GB 927559189
