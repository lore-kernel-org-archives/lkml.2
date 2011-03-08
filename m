Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086Ab1CHD6P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 22:58:15 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:57175 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753933Ab1CHD6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 22:58:14 -0500
Date: Tue, 8 Mar 2011 09:27:59 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: jacob pan <jacob.jun.pan@linux.intel.com>
Cc: Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Gautham R Shenoy <ego@in.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Matt Helsley <matthltc@us.ibm.com>
Subject: Re: [CFS Bandwidth Control v4 0/7] Introduction
Message-ID: <20110308035759.GI2868@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20110216031831.571628191@google.com>
 <20110224161111.7d83a884@jacob-laptop>
 <AANLkTi=i-fgng0Pa2JDSy8RgqRs2mo2vc2CKbx12-=Ri@mail.gmail.com>
 <20110225050646.2828709c@jacob-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20110225050646.2828709c@jacob-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* jacob pan <jacob.jun.pan@linux.intel.com> [2011-02-25 05:06:46]:

> On Fri, 25 Feb 2011 02:03:54 -0800
> Paul Turner <pjt@google.com> wrote:
> 
> > On Thu, Feb 24, 2011 at 4:11 PM, jacob pan
> > <jacob.jun.pan@linux.intel.com> wrote:
> > > On Tue, 15 Feb 2011 19:18:31 -0800
> > > Paul Turner <pjt@google.com> wrote:
> > >
> > >> Hi all,
> > >>
> > >> Please find attached v4 of CFS bandwidth control; while this rebase
> > >> against some of the latest SCHED_NORMAL code is new, the features
> > >> and methodology are fairly mature at this point and have proved
> > >> both effective and stable for several workloads.
> > >>
> > >> As always, all comments/feedback welcome.
> > >>
> > >
> > > Hi Paul,
> > >
> > > Your patches provide a very useful but slightly different feature
> > > for what we need to manage idle time in order to save power. What we
> > > need is kind of a quota/period in terms of idle time. I have been
> > > playing with your patches and noticed that when the cgroup cpu usage
> > > exceeds the quota the effect of throttling is similar to what I have
> > > been trying to do with freezer subsystem. i.e. freeze and thaw at
> > > given period and percentage runtime.
> > > https://lkml.org/lkml/2011/2/15/314
> > >
> > > Have you thought about adding such feature (please see detailed
> > > description in the link above) to your patches?
> > >
> > 
> > So reading the description it seems like rooting everything in a
> > 'freezer' container and then setting up a quota of
> > 
> > (1 - frozen_percentage)  * nr_cpus * frozen_period * sec_to_usec
> > 
> I guess you meant frozen_percentage is less than 1, i.e. 90 is .90. my
> code treat 90 as 90. just a clarification.
> > on a period of
> > 
> > frozen_period * sec_to_usec
> > 
> > Would provide the same functionality.  Is there other unduplicated
> > functionality beyond this?
> Do you mean the same functionality as your patch? Not really, since my
> approach will stop the tasks based on hard time slices. But seems your
> patch will allow them to run if they don't exceed the quota. Am i
> missing something?
> That is the only functionality difference i know.
> 
> Like the reviewer of freezer patch pointed out, it is a more logical
> fit to implement such feature in scheduler/yours in stead of freezer. So
> i am wondering if your patch can be expended to include limiting quota
> on real time.
>

Do you mean sched rt group controller? Have you looked at
cpu.rt_runtime_us and cpu.rt_perioud_us?
 
> I did a comparison study between CFS BW and freezer patch on skype with
> identical quota setting as you pointed out earlier. Both use 2 sec
> period and .2 sec quota (10%). Skype typically uses 5% of the CPU on my
> system when placing a call(below cfs quota) and it wakes up every 100ms
> to do some quick checks. Then I run skype in cpu then freezer cgroup
> (with all its children). Here is my result based on timechart and
> powertop.
> 
> patch name	wakeups		skype call?
> ------------------------------------------------------------------
> CFS BW		10/sec		yes
> freezer		1/sec		no
>

Is this good or bad for CFS BW?

-- 
	Three Cheers,
	Balbir
