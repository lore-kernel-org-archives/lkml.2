Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156Ab1GAJt7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 05:49:59 -0400
Received: from lo.gmane.org ([80.91.229.12]:57531 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756098Ab1GAJt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 05:49:57 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Subject: Re: [PATCH 1/3] PWM: add pwm framework support
Date: Fri, 1 Jul 2011 09:49:43 +0000 (UTC)
Message-ID: <iuk57m$4av$1@dough.gmane.org>
References: <1309430517-23821-1-git-send-email-s.hauer@pengutronix.de> <1309430517-23821-2-git-send-email-s.hauer@pengutronix.de> <BANLkTikQGFA7XcuAtEEi7_4m-j6-00sZ6Q@mail.gmail.com> <201106301441.24493.arnd@arndb.de> <BANLkTin_htv2z3D9Bbf6N8Y7UKFRvPtvOg@mail.gmail.com> <20110630170229.GP6069@pengutronix.de> <4E0D0595.5070205@gmail.com> <20110701073755.GR6069@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 91.213.169.4
User-Agent: XPN/1.2.6 (Street Spirit ; Linux)
Cc: linux-arm-kernel@lists.infradead.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sascha Hauer wrote:

> On Fri, Jul 01, 2011 at 09:24:05AM +1000, Ryan Mallon wrote:
>> On 01/07/11 03:02, Sascha Hauer wrote:
>> >Bill,
>> >
>> >On Thu, Jun 30, 2011 at 11:17:54AM -0500, Bill Gatliff wrote:
>> >>Guys:
>> >>
>> >>On Thu, Jun 30, 2011 at 7:41 AM, Arnd Bergmann<arnd@arndb.de>  wrote:
>> >>
>> >>>A lot of people want to see a framework get merged, and I think it's
>> >>>great that Sascha has volunteered to do the work to push that
>> >>>through this time, especially since you have not been able to
>> >>>finish your work.
>> >>Sascha is wasting his time by reinventing the wheel.  He's traveling
>> >>over exactly the same path I have already covered.  In fact, some of
>> >>his reviewer comments are almost word-for-word the same as those I
>> >>have received and addressed in the past.
>> >>
>> >>My patches were always kept current in this mailing list and others,
>> >>and Sascha clearly has the skills necessary to make improvements and
>> >>corrections should he have chosen to do so.
>> >I think that you made the fundamental mistake to completly ignore the
>> >existing pwm API and its users. With a competing api we are basically
>> >stuck. We can't convert the existing hardware drivers to the new API
>> >because leds-pwm.c, pwm_bl.c and others still depend on the old API and
>> >boards using it would break.
>> 
>> I don't think this is really a blocker to Bill's patches. There are
>> three (that I can see) pwm users currently:
>> drivers/video/backlight/pwm_bl.c
>> drivers/leds/leds-pwm.c
>> drivers/input/misc/pwm-beeper.c
>> 
>> All of those drivers are trivial and good easily be updated to work
>> with Bill's patches. Bill already provided a leds-pwm driver.
>
> Yes, it is easy but that's not my point. The point is that you can't
> convert the drivers without converting *all* hardware drivers in a
> *single* step. If you choose to have two competing APIs in the tree
> for one purpose you can't convert the drivers but instead you have
> to copy them, either with cp or ifdefs. I have just looked at the
> leds-pwm driver Bill provided. Applying it immediately breaks all
> users.

Just my 2c: if we were to introduce another "new" PWM API now
(no matter how good it will be) it would take quite a few years to
convert all current drivers (both following the current PWM API and not
following ones) to this new API. Consider leds API: we had led class for
several years already and only now we can foresee porting of "old" leds
users to new API. I'd definitely vote first to collect all current PWM
drivers into drivers/pwm and then step by step convert all other PWM
providers/users to it, introducing API changes as necessary, step by
step.

-- 
With best wishes
Dmitry



