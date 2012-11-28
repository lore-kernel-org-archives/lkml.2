Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab2K1MpL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 07:45:11 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:35154 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754275Ab2K1MpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 07:45:08 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: linux-pm@vger.kernel.org, cpufreq@vger.kernel.org,
        Rickard Andersson <rickard.andersson@stericsson.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] cpufreq: handle SW coordinated CPUs
Date: Wed, 28 Nov 2012 13:49:52 +0100
Message-ID: <2440132.24rRKQ8HXi@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc7; KDE/4.9.3; x86_64; ; )
In-Reply-To: <20121128105120.GB22300@balto.lan>
References: <1353947996-26723-1-git-send-email-fabio.baltieri@linaro.org> <1723557.AFJjisZlEm@vostro.rjw.lan> <20121128105120.GB22300@balto.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 28, 2012 11:51:20 AM Fabio Baltieri wrote:
> Hello Rafael,

Hi,

> On Tue, Nov 27, 2012 at 11:05:52PM +0100, Rafael J. Wysocki wrote:
> > >  static inline void dbs_timer_init(struct dbs_data *dbs_data,
> > > -		struct cpu_dbs_common_info *cdbs, unsigned int sampling_rate)
> > > +				  struct cpu_dbs_common_info *cdbs,
> > > +				  unsigned int sampling_rate,
> > > +				  int cpu)
> > >  {
> > >  	int delay = delay_for_sampling_rate(sampling_rate);
> > > +	struct cpu_dbs_common_info *cdbs_local = dbs_data->get_cpu_cdbs(cpu);
> > > +	struct od_cpu_dbs_info_s *od_dbs_info;
> > > +
> > > +	cancel_delayed_work_sync(&cdbs_local->work);
> > > +
> > > +	if (dbs_data->governor == GOV_ONDEMAND) {
> > > +		od_dbs_info = dbs_data->get_cpu_dbs_info_s(cpu);
> > > +		od_dbs_info->sample_type = OD_NORMAL_SAMPLE;
> > > +	}
> > 
> > The patch looks good in general except for the special case above.
> > 
> > Why exactly is it necessary?
> 
> Now that you point it out... it's not!  It was part of ondemand init and
> moved in cpufreq_governor_dbs, I forgot to take it out the way.
> 
> Also, I think that cancel_delayed_work_sync can be removed too.
> 
> Should I send an updated version as soon as I get an ack for the other
> patches in the series or do you want me to wait until 3.8-rc1?

Well, if it's not very urgent, I'd prefer it to wait a bit longer,
get some more testing and so on.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
