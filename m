Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431Ab1FBOXw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 10:23:52 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52908 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab1FBOXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 10:23:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dVyyUFwaKJxCzG04ffPUiqKuvgAiGmocOLNP/XU7/7Fi5jlymTJQ355sgeC8hoEPnJ
         M7aR/81WIcvtI7xcq7aMYBwuIOXpS22mdIojzZzHQJ2driReRLZwmD0bxMyg4WnC+GmG
         Wf1J09m4+tLWiqkDhztzXNo/OJZFPpoVgPzbg=
Date: Thu, 2 Jun 2011 22:23:40 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Borislav Petkov <bp@amd64.org>, Borislav Petkov <bp@alien8.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "markus@trippelsdorf.de" <markus@trippelsdorf.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:sched/urgent] sched: Fix cross-cpu clock sync on remote
 wakeups
Message-ID: <20110602142340.GA3356@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1306835745.2353.3.camel@twins>
 <tip-f01114cb59d670e9b4f2c335930dd57db96e9360@git.kernel.org>
 <20110531125621.GA24439@gere.osrc.amd.com>
 <1306847516.2353.80.camel@twins>
 <20110601070547.GB3368@liondog.tnic>
 <1306924612.2353.176.camel@twins>
 <20110601155017.GD24028@aftab>
 <BANLkTikT6OT-HDi-DR+_ZWEhfp_CYWJ3Hg@mail.gmail.com>
 <1307019866.2497.675.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1307019866.2497.675.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 02, 2011 at 03:04:26PM +0200, Peter Zijlstra wrote:
> On Thu, 2011-06-02 at 15:52 +0800, Yong Zhang wrote:
> > In sched_clock_local(), clock is calculated around ->tick_gtod even if
> > that ->tick_gtod is stale for long time because we stays in idle state. 
> > You know ->tick_gtod is only updated in sched_clock_tick();
> 
> (well, no, there's idle callbacks as you said below)
> 
> > IOW, when a cpu goes out of idle, sched_clock_tick() is called from
> > tick_nohz_stop_idle() which is later than interrupt.
> 
> Gah, that would be awefull and mean wakeups from interrupts were already
> borken. /me goes look at code.
> 
> irq_enter() -> tick_check_idle() -> tick_check_nohz() ->
> tick_nohz_stop_idle() -> sched_clock_idle_wakeup_event()
> 
> should update the thing before we run any isrs, right?

Hmmm, you are right.

But smp_reschedule_interrupt() doesn't call irq_enter()/irq_exit(),
is that correct?

Thanks,
Yong
