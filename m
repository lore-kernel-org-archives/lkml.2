Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215Ab2FMQHG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 12:07:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:35590 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534Ab2FMQHE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 12:07:04 -0400
Message-ID: <1339603608.8980.55.camel@twins>
Subject: Re: [RFC 3/4] ARM: topology: Update cpu_power according to DT
 information
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, devicetree-discuss@lists.ozlabs.org,
        linux@arm.linux.org.uk, grant.likely@secretlab.ca,
        rob.herring@calxeda.com
Date: Wed, 13 Jun 2012 18:06:48 +0200
In-Reply-To: <CAKfTPtDkRZJmfwmOeR6TPc5etbWRRneWAmN13X2_ace4wFwf7A@mail.gmail.com>
References: <1339502524-10265-1-git-send-email-vincent.guittot@linaro.org>
	 <1339502524-10265-4-git-send-email-vincent.guittot@linaro.org>
	 <1339592856.8980.33.camel@twins>
	 <CAKfTPtDkRZJmfwmOeR6TPc5etbWRRneWAmN13X2_ace4wFwf7A@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-13 at 16:54 +0200, Vincent Guittot wrote:
> On 13 June 2012 15:07, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Tue, 2012-06-12 at 14:02 +0200, Vincent Guittot wrote:
> >> +struct cpu_capacity cpu_capacity[NR_CPUS];
> >
> > I know ARM isn't likely to suffer from the 4k cpu issue, but is there a
> > reason to use a NR_CPUS array over a per-cpu variable?
> 
> At this stage, we don't know which logical CPU will match which hwid.
> During the boot of each CPU, we parse the table to found an efficiency
> value for the booting CPU. The whole table is used by one CPU at a
> time.

Its not so much the usage as the dynamic sizing that I was after.
NR_CPUS will always be the max size, whereas per-cpu data will only use
the amount of storage required to back the number of cpus present.

For this reason we've spend a great deal of effort to remove NR_CPUS
sized arrays all over the core (and x86/ia64 arch) code, since distros
now build with NR_CPUS=4096 but hardly anybody has that many cpus, so
arrays sized that way waste tons of resources.
