Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506Ab0DUUYS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 16:24:18 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45321 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756429Ab0DUUYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 16:24:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=boZ9BKit+czVo+8Dz49W6Gg7mNGVl6OkEnedwQzBHaBHaAQxsSRB+cDU0yp5Al3vTZ
         aVU1SptTwaQJJpIQxNFUXz/vKJ5yzs46OUHMD/TqHWNHVKiOOd47xMrKJ4hIlK/v+r55
         7gtGrOyItrcw72xKey98oLc7/E4okTPt0nhYI=
Date: Wed, 21 Apr 2010 22:24:21 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: mingo@elte.hu, peterz@infradead.org, gorcunov@gmail.com, aris@redhat.com,
       linux-kernel@vger.kernel.org, randy.dunlap@oracle.com
Subject: Re: [PATCH 1/6] [watchdog] combine nmi_watchdog and softlockup
Message-ID: <20100421202418.GA8677@nowhere>
References: <1271777043-3807-1-git-send-email-dzickus@redhat.com> <1271777043-3807-2-git-send-email-dzickus@redhat.com> <20100421172730.GD5650@nowhere> <20100421175021.GV15159@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100421175021.GV15159@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21, 2010 at 01:50:21PM -0400, Don Zickus wrote:
> On Wed, Apr 21, 2010 at 07:27:33PM +0200, Frederic Weisbecker wrote:
> > Some minor things:
> > 
> > 
> > On Tue, Apr 20, 2010 at 11:23:58AM -0400, Don Zickus wrote:
> > > +#ifdef CONFIG_PERF_EVENTS_NMI
> > > +struct perf_event_attr wd_hw_attr = {
> > > +	.type		= PERF_TYPE_HARDWARE,
> > > +	.config		= PERF_COUNT_HW_CPU_CYCLES,
> > > +	.size		= sizeof(struct perf_event_attr),
> > > +	.pinned		= 1,
> > > +	.disabled	= 1,
> > > +};
> > 
> > 
> > 
> > Shouldn't it be static?
> 
> yes.  thanks.
> 
> > 
> > 
> > > +
> > > +/* Callback function for perf event subsystem */
> > > +void watchdog_overflow_callback(struct perf_event *event, int nmi,
> > > +		 struct perf_sample_data *data,
> > > +		 struct pt_regs *regs)
> > > +{
> > > +	int this_cpu = smp_processor_id();
> > > +	unsigned long touch_ts = per_cpu(watchdog_touch_ts, this_cpu);
> > > +	char warn = per_cpu(watchdog_warn, this_cpu);
> > 
> > 
> > 
> > You can use __get_cpu_var() here
> 
> well, I already have this_cpu and need it later, I figured I would just
> use it with per_cpu and save _get_cpu_var the work of re-running
> smp_processor_id().



This is more about code clarity in fact. per_cpu() suggests we are
fetching something from another cpu.

This is a very minor issue though.

