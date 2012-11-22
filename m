Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757797Ab2KVVXd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:23:33 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:33132 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932119Ab2KVVWm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 16:22:42 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        Rickard Andersson <rickard.andersson@stericsson.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] cpufreq: ondemand: handle SW coordinated CPUs
Date: Thu, 22 Nov 2012 22:27:10 +0100
Message-ID: <7225350.Xenu33kWOn@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc6; KDE/4.9.3; x86_64; ; )
In-Reply-To: <20121122170237.GA16948@gmail.com>
References: <1353413176-21723-1-git-send-email-fabio.baltieri@linaro.org> <1708590.LLn32jdgxe@vostro.rjw.lan> <20121122170237.GA16948@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 22, 2012 06:02:37 PM Fabio Baltieri wrote:
> Hello Rafael,
> 
> thanks for the review!  I only have one concern before sending a v4:
> 
> On Thu, Nov 22, 2012 at 01:10:15AM +0100, Rafael J. Wysocki wrote:
> > > @@ -627,32 +659,41 @@ static void do_dbs_timer(struct work_struct *work)
> > >  				delay -= jiffies % delay;
> > >  		}
> > >  	} else {
> > > -		__cpufreq_driver_target(dbs_info->cur_policy,
> > > -			dbs_info->freq_lo, CPUFREQ_RELATION_H);
> > > +		if (sample)
> > > +			__cpufreq_driver_target(dbs_info->cur_policy,
> > > +						dbs_info->freq_lo,
> > > +						CPUFREQ_RELATION_H);
> > >  		delay = dbs_info->freq_lo_jiffies;
> > >  	}
> > > -	schedule_delayed_work_on(cpu, &dbs_info->work, delay);
> > > +	schedule_delayed_work_on(smp_processor_id(), dw, delay);
> > 
> > We're not supposed to be using smp_processor_id() any more.
> > get_cpu()/put_cpu() should be used instead.
> 
> That's going to add preemption protection, do I need that?  The function
> is called from a kworker with the affinity set on a specific CPU, so it
> should not migrate to a different one during execution.

Yes, you're right, in that case it should be OK.

> I agree with you for all the other comments.

Cool. :-)

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
