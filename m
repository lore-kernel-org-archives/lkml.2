Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab1FCKzb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 06:55:31 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57179 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664Ab1FCKza convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 06:55:30 -0400
Subject: Re: [tip:sched/urgent] sched: Fix cross-cpu clock sync on remote
 wakeups
From: Peter Zijlstra <peterz@infradead.org>
To: Milton Miller <miltonm@bga.com>
Cc: Yong Zhang <yong.zhang0@gmail.com>, Borislav Petkov <bp@amd64.org>,
        Borislav Petkov <bp@alien8.de>, "mingo@redhat.com" <mingo@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "markus@trippelsdorf.de" <markus@trippelsdorf.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
In-Reply-To: <1307097360.2353.3071.camel@twins>
References: <1307029711.2497.717.camel@laptop>
	 <1306835745.2353.3.camel@twins>
	 <tip-f01114cb59d670e9b4f2c335930dd57db96e9360@git.kernel.org>
	 <20110531125621.GA24439@gere.osrc.amd.com> <1306847516.2353.80.camel@twins>
	 <20110601070547.GB3368@liondog.tnic> <1306924612.2353.176.camel@twins>
	 <20110601155017.GD24028@aftab>
	 <BANLkTikT6OT-HDi-DR+_ZWEhfp_CYWJ3Hg@mail.gmail.com>
	 <1307019866.2497.675.camel@laptop> <20110602142340.GA3356@zhy>
	 <schedulerIPIirqEnter@mdm.bga.com>  <1307097360.2353.3071.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 03 Jun 2011 12:55:06 +0200
Message-ID: <1307098506.2353.3094.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-03 at 12:36 +0200, Peter Zijlstra wrote:
> > Can we get some numbers for how often the two cases occur on some
> > various workloads?
> 
> Sure, let me stick some counters in. 

Of 128765 IPIs, 17483 were with an empty list (boot + make -j64).

I didn't yet look at where those empty ones originated from.
