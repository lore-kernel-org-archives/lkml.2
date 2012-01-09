Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583Ab2AILAj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 06:00:39 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:36500 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050Ab2AILAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 06:00:37 -0500
Date: Mon, 9 Jan 2012 16:30:25 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Youquan Song <youquan.song@intel.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        suresh.b.siddha@intel.com, arjan@linux.intel.com, len.brown@intel.com,
        anhua.xu@intel.com, chaohong.guo@intel.com,
        Youquan Song <youquan.song@linux.intel.com>,
        Paul Turner <pjt@google.com>
Subject: Re: [PATCH] x86,sched: Fix sched_smt_power_savings totally broken
Message-ID: <20120109110025.GA7988@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <1326099367-4166-1-git-send-email-youquan.song@intel.com>
 <1326103578.2442.50.camel@twins>
 <1326104915.2442.53.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1326104915.2442.53.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12010911-5564-0000-0000-000000D6F401
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2012-01-09 11:28:35]:

> On Mon, 2012-01-09 at 11:06 +0100, Peter Zijlstra wrote:
> > I'm >< close to committing a patch removing all the power_saving
> > magic from the scheduler. 
> 
> Unless someone steps up that says they care about this crap and are
> willing to clean it up this goes in...

Hi Peter,

Power savings knob in the schedule is a good feature to have and it
benefits Linux users.  I will help to clean this up.

> And that very much includes ripping out the current interface and
> replacing it with something sane, the current setup of {0,1,2}x{0,1,2}
> possible configuration settings is completely unacceptable, esp since
> people seem to want to inflate that to 27 or worse.

Lets combine the MC/SMT options and create sched_powersavings={0,1,2}
That will make it only one sysfs knob without any dependencies.

Based on the architecture, kernel can consolidate at core level or
thread level when available.

First let me propose the fix for Youquan Song's problem and then send
a patch to simplify the sched_powersavings knob.

--Vaidy

