Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab0FWPER (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 11:04:17 -0400
Received: from imr1.ericy.com ([198.24.6.9]:36364 "EHLO imr1.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753036Ab0FWPEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 11:04:16 -0400
Date: Wed, 23 Jun 2010 08:03:25 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>
CC: "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [lm-sensors] Adding critical/fault limits to hwmon sysfs API
Message-ID: <20100623150325.GA19461@ericsson.com>
References: <20100620163759.GA7077@ericsson.com>
 <20100623144346.10acd898@hyperion.delvare>
 <20100623133147.GA19143@ericsson.com>
 <20100623162911.2028f817@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100623162911.2028f817@hyperion.delvare>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 23, 2010 at 10:29:11AM -0400, Jean Delvare wrote:
> On Wed, 23 Jun 2010 06:31:47 -0700, Guenter Roeck wrote:
> > On Wed, Jun 23, 2010 at 08:43:46AM -0400, Jean Delvare wrote:
> > > Hi Guenter,
> > > 
> > > On Sun, 20 Jun 2010 09:37:59 -0700, Guenter Roeck wrote:
> > > > the current hwmon sysfs API does not specify critical or fault limits for voltage
> > > > and current readings.
> > > > 
> > > > Many recent power controller/monitoring chips have support for such limits in addition
> > > > to alarm limits. Typical action, when a the critical or fault limit is reached,
> > > > may be a board reset or power shutdown, or to report the fault condition.
> > > > 
> > > > Examples for chips supporting critical/fault limits are SMM665 and variants as well
> > > > as many PMBus devices, such as MAX8688, MAX16064, LTC2978, and others.
> > > > 
> > > > I think it would make sense to add critical/fault limits to the hwmon sysfs API,
> > > > to be able to report those limits if supported by a chip.
> > > > 
> > > > Any thoughts on this ?
> > > 
> > > I agree it would be good to have standard names (and libsensors
> > > support) if these features are popular. It might be a little difficult
> > > to come up with the right attribute names though.
> > > 
> > > For temperatures, we have temp[1-*]_crit, for the critical limit on the
> > > high end. We don't have a name for the critical limit on the low end,
> > > because no chip ever implemented that. The name we chose doesn't offer
> > > much possibilities for a nice name while staying consistent. Maybe
> > > "lcrit" would be acceptable for the low end critical limit, and we keep
> > > "crit" for the high end critical limit?
> > > 
> > How about {curr|in|temp}[1-*]_[min_]crit ?
> > 
> > In other words, keep _crit for the upper limit and introduce min_crit for the lower limit.
> > This would be a bit better aligned with the existing _min while maintaining _crit for the 
> > upper limit.
> 
> I expected a counter-proposal of this kind. The problem I see is that
> the new limit we are adding is unrelated to _min. However, the other
> _min_* file we have (_min_alarm) expresses something which is relative
> to _min. Same as _max_hyst and _crit_hyst, which are relative to _max
> and _critn respectively. So I have the feeling that _min_crit sends the
> wrong signal to the reader. Especially if we keep _crit for the high
> bound, the asymmetry raises questions.
> 
> This is my rationale for suggesting _crit and _lcrit. Now, I won't
> argue forever if others disagree, these is really only a naming
> convention and everything will be fine as long as the drivers and
> libsensors agree.

Makes sense. No strong opinion on my side, really. Using crit/lcrit is fine for me as well.
Maybe we should wait if there is input from others and go with lcrit if there is none.

On a side note, libsensors does not support inX_fault today, even though 
it is mentioned in the API, and there is no currX_fault. Likewise, libsensors supports 
currX_alarm but it is not mentioned in hwmon/sysfs-interface.
Unless there are objections, I'll clean that up when I add support for the _[l]crit objects.

Also, lib/sensors.conf.5 has a comment "Likewise, tempX_crit often comes with tempX_max_crit".
Since tempX_max_crit does not exist, it might make sense to remove that comment.

Guenter
