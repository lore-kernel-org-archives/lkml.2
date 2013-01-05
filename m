Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453Ab3ADX5j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 18:57:39 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:60561 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754749Ab3ADX5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 18:57:35 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Daniel Lezcano <daniel.lezcano@linaro.org>, Russ Anderson <rja@sgi.com>
Cc: linux-pm@vger.kernel.org, pdeschrijver@nvidia.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        rja@americas.sgi.com
Subject: Re: [PATCH] cpuidle - fix lock contention in the idle path
Date: Sat, 05 Jan 2013 01:03:11 +0100
Message-ID: <3077900.eue4T2ZoF8@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc2+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <50E6764C.9060608@linaro.org>
References: <1356516108-11191-1-git-send-email-daniel.lezcano@linaro.org> <20130102211314.GA29447@sgi.com> <50E6764C.9060608@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 04, 2013 07:27:24 AM Daniel Lezcano wrote:
> On 01/02/2013 10:13 PM, Russ Anderson wrote:
> > On Wed, Dec 26, 2012 at 11:01:48AM +0100, Daniel Lezcano wrote:
> >> The commit bf4d1b5ddb78f86078ac6ae0415802d5f0c68f92 introduces
> >> a lock in the cpuidle_get_cpu_driver function. This function
> >> is used in the idle_call function.
> >>
> >> The problem is the contention with a large number of cpus because
> >> they try to access the idle routine at the same time.
> >>
> >> The lock could be safely removed because of how is used the
> >> cpuidle api. The cpuidle_register_driver is called first but
> >> until the cpuidle_register_device is not called we don't
> >> enter in the cpuidle idle call function because the device
> >> is not enabled.
> >>
> >> The cpuidle_unregister_driver function, leading the a NULL driver,
> >> is not called before the cpuidle_unregister_device.
> >>
> >> This is how is used the cpuidle api from the different drivers.
> >>
> >> However, a cleanup around the lock and a proper refcounting
> >> mechanism should be used to ensure the consistency in the api,
> >> like cpuidle_unregister_driver should failed if its refcounting
> >> is not 0.
> >>
> >> These modifications will need some code reorganization and rewrite
> >> which does not fit with a fix.
> > 
> > I agree.
> > 
> >> The following patch is a hot fix by returning to the initial behavior
> >> by removing the lock when getting the driver.
> > 
> > The patch fixes the problem.  Verified on a system with 1024 cpus.
> > Thanks.
> > 
> >> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> > 
> > Reported-by: Russ Anderson <rja@sgi.com>
> > Acked-by: Russ Anderson <rja@sgi.com>
> 
> Hi Rafael,
> 
> could you consider this patch for merging ?

Yes, I've taken it already.

I'll include it into the next pull request.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
