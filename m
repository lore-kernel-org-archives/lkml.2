Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943Ab1EXTs0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 15:48:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38996 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752184Ab1EXTsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 15:48:25 -0400
Date: Tue, 24 May 2011 21:48:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        paulus@samba.org, acme@redhat.com
Subject: Re: perf: regression -- missing /sys/devices/system/cpu/perf_events
Message-ID: <20110524194810.GB27634@elte.hu>
References: <alpine.DEB.2.00.1105240955050.9203@cl320.eecs.utk.edu>
 <1306246306.18455.36.camel@twins>
 <alpine.DEB.2.00.1105241341160.24062@cl320.eecs.utk.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1105241341160.24062@cl320.eecs.utk.edu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vince Weaver <vweaver1@eecs.utk.edu> wrote:

> On Tue, 24 May 2011, Peter Zijlstra wrote:
> 
> > A much more reliable way is simply doing the syscall and seeing what
> > happens. But if you want to poke around in sysfs, /sys/bus/event_source/
> > is the new location.
> 
> It's been suggested that they can look for the existence of:
>   /proc/sys/kernel/perf_event_paranoid
> 
> is that something not likely to go away?

Well, we indeed do not remove kernel parameters, but checking for that would 
break on systems (or chroot environments) that do not have /proc mounted or 
visible.

So, what is wrong with the method Peter suggested: the presence of the perf 
syscall (it not returning -ENOSYS) is bona fide evidence that perf is 
available.

Thanks,

	Ingo
