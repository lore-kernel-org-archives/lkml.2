Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495Ab2K1Kvb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 05:51:31 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:49442 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754388Ab2K1Kv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 05:51:27 -0500
Date: Wed, 28 Nov 2012 11:51:20 +0100
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@vger.kernel.org, cpufreq@vger.kernel.org,
        Rickard Andersson <rickard.andersson@stericsson.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] cpufreq: handle SW coordinated CPUs
Message-ID: <20121128105120.GB22300@balto.lan>
Mail-Followup-To: Fabio Baltieri <fabio.baltieri@linaro.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@vger.kernel.org,
	cpufreq@vger.kernel.org,
	Rickard Andersson <rickard.andersson@stericsson.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org
References: <1353947996-26723-1-git-send-email-fabio.baltieri@linaro.org>
 <1353947996-26723-2-git-send-email-fabio.baltieri@linaro.org>
 <1723557.AFJjisZlEm@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1723557.AFJjisZlEm@vostro.rjw.lan>
X-Operating-System: Linux balto 3.7.0-rc6-00227-g28c4467-dirty x86_64
 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Rafael,

On Tue, Nov 27, 2012 at 11:05:52PM +0100, Rafael J. Wysocki wrote:
> >  static inline void dbs_timer_init(struct dbs_data *dbs_data,
> > -		struct cpu_dbs_common_info *cdbs, unsigned int sampling_rate)
> > +				  struct cpu_dbs_common_info *cdbs,
> > +				  unsigned int sampling_rate,
> > +				  int cpu)
> >  {
> >  	int delay = delay_for_sampling_rate(sampling_rate);
> > +	struct cpu_dbs_common_info *cdbs_local = dbs_data->get_cpu_cdbs(cpu);
> > +	struct od_cpu_dbs_info_s *od_dbs_info;
> > +
> > +	cancel_delayed_work_sync(&cdbs_local->work);
> > +
> > +	if (dbs_data->governor == GOV_ONDEMAND) {
> > +		od_dbs_info = dbs_data->get_cpu_dbs_info_s(cpu);
> > +		od_dbs_info->sample_type = OD_NORMAL_SAMPLE;
> > +	}
> 
> The patch looks good in general except for the special case above.
> 
> Why exactly is it necessary?

Now that you point it out... it's not!  It was part of ondemand init and
moved in cpufreq_governor_dbs, I forgot to take it out the way.

Also, I think that cancel_delayed_work_sync can be removed too.

Should I send an updated version as soon as I get an ack for the other
patches in the series or do you want me to wait until 3.8-rc1?

Thanks,
Fabio

-- 
Fabio Baltieri
