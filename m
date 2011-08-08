Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950Ab1HHIBy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 04:01:54 -0400
Received: from exprod5og104.obsmtp.com ([64.18.0.178]:48134 "EHLO
	exprod5og104.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725Ab1HHIBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 04:01:50 -0400
Message-ID: <4E3F97EA.2020600@ge.com>
Date: Mon, 08 Aug 2011 09:01:46 +0100
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: "Emilio G. Cota" <cota@braap.org>
CC: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/8] staging: vme: add functions for bridge module refcounting
References: <1312194053-32310-1-git-send-email-manohar.vanga@cern.ch> <1312194053-32310-6-git-send-email-manohar.vanga@cern.ch> <4E39555C.30507@ge.com> <20110803140630.GA29460@becoht-mvanga> <20110803152317.GA21903@flamenco.cs.columbia.edu> <4E3A4904.3040007@ge.com> <20110804163451.GA18422@flamenco.cs.columbia.edu> <4E3B9FA2.3060303@ge.com> <20110805090416.GA4806@becoht-mvanga> <4E3BB6E7.6020809@ge.com> <20110805174728.GA1741@flamenco.cs.columbia.edu>
In-Reply-To: <20110805174728.GA1741@flamenco.cs.columbia.edu>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Aug 2011 08:01:47.0761 (UTC) FILETIME=[6C0A4610:01CC55A1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/11 18:47, Emilio G. Cota wrote:
> On Fri, Aug 05, 2011 at 10:24:55 +0100, Martyn Welch wrote:
>> I think that by refcounting the resources being used we
>> will know whether a bridge module is being used or not,
>> thus whether it can be unloaded or not.
> 
> But the granularity is wrong; if you want to know whether the
> bridge is being used, just keep track of the devices *which
> want to make known* that they're under the bridge.
> 

I disagree, it shouldn't be up to the driver to determine whether it's use of
the bus should be known by the system. The system should know when the bus is
being used.

>> By reference counting the use of resources we minimise the
>> chance of poorly written drivers using resources, but not
>> registering the fact that they are in fact using a VME bridge.
> 
> A driver leaking a resource will then leave a bogus refcount
> on the bus driver--a clear case of self-inflicted pain.
> 

As opposed to adding a function that *only* refcounts and therefore requires
every driver to make extra explicit function call just to keep the refcounts
up-to-date.

> The argument of "poorly written drivers" does not apply;
> I would expect all the merged drivers to be "good quality"
> only, that's why we want to be upstream and why we put effort
> in reviewing. Your point is well-intentioned, but in
> practice we'd be shooting ourselves in the foot, potentially
> ending up with an unremovable vme bridge module--which is
> worse than a driver leaking a resource.
> 

Which wouldn't happen because all the upstreamed drivers are "good quality". I
might add that failing to free a resource will mean that it won't be
re-allocated, so having visibility of the number of resources having been
allocated would be advantageous.

> Refcounting must be kept simple & stupid; doing it behind the
> backs of the drivers we're trying to protect is a mistake.
> 

I just simply disagree. Forcing each driver to specifically maintain the
refcount is just stupid when an alternative is possible.

Martyn

-- 
Martyn Welch (Principal Software Engineer) | Registered in England and
GE Intelligent Platforms                   | Wales (3828642) at 100
T +44(0)127322748                          | Barbirolli Square, Manchester,
E martyn.welch@ge.com                      | M2 3AB  VAT:GB 927559189
