Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab1IPQWJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 12:22:09 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:38059 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab1IPQWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 12:22:07 -0400
Date: Fri, 16 Sep 2011 18:21:51 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Alexander Stein <alexander.stein@systec-electronic.com>
Cc: guenter.roeck@ericsson.com, "R, Durgadoss" <durgadoss.r@intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [lm-sensors] coretemp: Support for Intel Atom E6XX CPU
 (TunnelCreek)?
Message-ID: <20110916182151.463d6003@endymion.delvare>
In-Reply-To: <201108031640.31196.alexander.stein@systec-electronic.com>
References: <201106271220.51953.alexander.stein@systec-electronic.com>
	<201108031458.01805.alexander.stein@systec-electronic.com>
	<D6D887BA8C9DFF48B5233887EF04654109E88956B7@bgsmsx502.gar.corp.intel.com>
	<201108031640.31196.alexander.stein@systec-electronic.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexander,

On Wed, 3 Aug 2011 16:40:30 +0200, Alexander Stein wrote:
> On Wednesday 03 August 2011 15:26:53 R, Durgadoss wrote:
> > Yes I checked with some Atom Guys here.
> > Apparently there is no way to know it from the OS Level.
> > 
> > > On Monday 27 June 2011 18:54:44 R, Durgadoss wrote:
> > > > > Unfortunately, looking at Alexander's /proc/cpuinfo output, it looks
> > > > > like the E6xx chips have no mention of E6xx in the CPU ID string,
> > > > > which unfortunately kills the idea.
> > > > > 
> > > > > Do you know if there is _any_ means to distinguish E6xx from E6xxT ?
> > > > 
> > > > Sorry I do not know. But I can ask some folks here and get back
> > > > to you guys. Should not take more time, once I identify the right
> > > > person to ask :-)
> 
> So, is there a possibility to add a module parameter to force a either 
> specific tjmax or the T model for E6xx?

A parameter to force the T model for E6xx would be very very specific,
while the problem at hand is much broader: the heuristics in
adjust_tjmax() are best effort but largely insufficient in many (most?)
cases. So, as we have been enable to provide a relative temperature
scale interface in the past 2 years, a module parameter letting the
user set TjMax as needed seems the best approach to me. I'll submit a
patch doing this in a moment.

-- 
Jean Delvare
