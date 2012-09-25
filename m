Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825Ab2IYLq3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 07:46:29 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39152 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755444Ab2IYLq2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 07:46:28 -0400
Message-ID: <1348573571.3881.32.camel@twins>
Subject: Re: [PATCH 3/3] workqueue: Schedule work on non-idle cpu instead of
 current one
From: Peter Zijlstra <peterz@infradead.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linux-kernel@vger.kernel.org, pjt@google.com, paul.mckenney@linaro.org,
        tglx@linutronix.de, tj@kernel.org, suresh.b.siddha@intel.com,
        venki@google.com, mingo@redhat.com, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Arvind.Chauhan@arm.com,
        amit.kucheria@linaro.org, vincent.guittot@linaro.org,
        linaro-dev@lists.linaro.org, patches@linaro.org
Date: Tue, 25 Sep 2012 13:46:11 +0200
In-Reply-To: <1348573208.3881.27.camel@twins>
References: <viresh.kumar@linaro.org>
	 <cover.1348568074.git.viresh.kumar@linaro.org>
	 <3232b3192e2e373cc4aaf43359d454c5ad53cddb.1348568074.git.viresh.kumar@linaro.org>
	 <1348572145.3881.18.camel@twins>
	 <CAKohpokju4=fVKtq=rG0y-_c54n0yErzredW1BEJ5eTSaDyHpg@mail.gmail.com>
	 <1348573208.3881.27.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-09-25 at 13:40 +0200, Peter Zijlstra wrote:
> On Tue, 2012-09-25 at 17:00 +0530, Viresh Kumar wrote:
> > But this is what the initial idea during LPC we had.
> 
> Yeah.. that's true.
> 
> >  Any improvements here you can suggest? 
> 
> We could uhm... /me tries thinking ... reuse some of the NOHZ magic?
> Would that be sufficient, not waking a NOHZ cpu, or do you really want
> not waking any idle cpu?

Depending on the trade-off we could have the NOHZ stuff track a
non-NOHZ-idle cpu and avoid having to compute one every time we need it.




