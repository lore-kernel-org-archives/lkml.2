Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758232Ab1DZVAw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:00:52 -0400
Received: from imr4.ericy.com ([198.24.6.8]:58182 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754071Ab1DZVAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:00:51 -0400
Subject: Re: [PATCH v2 3/3] thermal: Make THERMAL_HWMON implementation
 fully internal
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: Jean Delvare <khali@linux-fr.org>
CC: Len Brown <len.brown@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Rene Herman <rene.herman@gmail.com>
In-Reply-To: <20110426213953.6cc227de@endymion.delvare>
References: <20110426165600.1d9ac91b@endymion.delvare>
	 <20110426170407.3694e430@endymion.delvare>
	 <20110426155212.GB18176@ericsson.com>
	 <20110426182905.72bbf7b6@endymion.delvare>
	 <1303839812.31666.98.camel@groeck-laptop>
	 <20110426213953.6cc227de@endymion.delvare>
Content-Type: text/plain; charset="UTF-8"
Organization: Ericsson
Date: Tue, 26 Apr 2011 14:00:31 -0700
Message-ID: <1303851631.31666.109.camel@groeck-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-26 at 15:39 -0400, Jean Delvare wrote:
> Hi Guenter,
> 
> On Tue, 26 Apr 2011 10:43:32 -0700, Guenter Roeck wrote:
> > On Tue, 2011-04-26 at 12:29 -0400, Jean Delvare wrote:
> > > On Tue, 26 Apr 2011 08:52:12 -0700, Guenter Roeck wrote:
> > > > On Tue, Apr 26, 2011 at 11:04:07AM -0400, Jean Delvare wrote:
> > > > > * Removal code path is untested, as I have never been able to unload
> > > > > the thermal_sys module on any of my systems. Something is pinning it
> > > > > and I have no idea what it is.
> > > > > 
> > > > Doesn't lsmod show the culprit ?
> > > 
> > > No, it's not a module dependency. The reference counter is set to 1,
> 
> Sorry I realize I have been inaccurate. thermal_sys indeed depends on
> the processor module, and that's what prevents me from unloading it.
> It's the processor module which has a reference count of 1, and no
> dependency, so I have no idea how I could unload it.
> 
You mean the ACPI processor driver ? This comment might explain it:

/*
 * We keep the driver loaded even when ACPI is not running.
 * This is needed for the powernow-k8 driver, that works even without
 * ACPI, but needs symbols from this driver
 */

> > > so somewhere in the kernel something is taking a reference to the
> > > module and won't release it. I wish this was better instrumented so
> > > that it would be possible to know who is doing that.
> > 
> > The most likely culprit seems to be acpi.
> 
> I'm not sure. I don't see any relevant call to try_module_get under
> drivers/acpi, and I'm not aware of any other way to increase the
> reference count.
> 
What happens if the calling code (such as, in my case here, the acpi
video code) gets built into the kernel ? Would that force the module to
be and remain loaded ?

Guenter


