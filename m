Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756488Ab1DZQ3O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 12:29:14 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:25619 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab1DZQ3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 12:29:13 -0400
Date: Tue, 26 Apr 2011 18:29:05 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Len Brown <len.brown@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Rene Herman <rene.herman@gmail.com>
Subject: Re: [PATCH v2 3/3] thermal: Make THERMAL_HWMON implementation 
 fully internal
Message-ID: <20110426182905.72bbf7b6@endymion.delvare>
In-Reply-To: <20110426155212.GB18176@ericsson.com>
References: <20110426165600.1d9ac91b@endymion.delvare>
	<20110426170407.3694e430@endymion.delvare>
	<20110426155212.GB18176@ericsson.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Apr 2011 08:52:12 -0700, Guenter Roeck wrote:
> On Tue, Apr 26, 2011 at 11:04:07AM -0400, Jean Delvare wrote:
> > THERMAL_HWMON is implemented inside the thermal_sys driver and has no
> > effect on drivers implementing thermal zones, so they shouldn't see
> > anything related to it in <linux/thermal.h>. Making the THERMAL_HWMON
> > implementation fully internal has two advantages beyond the cleaner
> > design:
> > * This avoids rebuilding all thermal drivers if the THERMAL_HWMON
> >   implementation changes, or if CONFIG_THERMAL_HWMON gets enabled or
> >   disabled.
> > * This avoids breaking the thermal kABI in these cases too, which
> >   should make distributions happy.
> > 
> > The only drawback I can see is slightly higher memory fragmentation,
> > as the number of kzalloc() calls will increase by one per thermal zone.
> > But I doubt it will be a problem in practice, as I've never seen a
> > system with more than two thermal zones.
> > 
> > Signed-off-by: Jean Delvare <khali@linux-fr.org>
> > Cc: Rene Herman <rene.herman@gmail.com>
> > Cc: Len Brown <len.brown@intel.com>
> > Cc: Guenter Roeck <guenter.roeck@ericsson.com>
> > ---
> > * If memory fragmentation is really a concern to anyone, it would be
> >   possible to save one kalloc for the first temperature input of each
> >   zone type, as the price of slightly more complex code.
> > 
> > * Removal code path is untested, as I have never been able to unload
> > the thermal_sys module on any of my systems. Something is pinning it
> > and I have no idea what it is.
> > 
> Doesn't lsmod show the culprit ?

No, it's not a module dependency. The reference counter is set to 1,
so somewhere in the kernel something is taking a reference to the
module and won't release it. I wish this was better instrumented so
that it would be possible to know who is doing that.

> Otherwise
> 
> Acked-by: Guenter Roeck <guenter.roeck@ericsson.com>

Thanks for the reviews.

-- 
Jean Delvare
