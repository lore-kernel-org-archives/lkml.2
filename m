Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117Ab2FKVBV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 17:01:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19162 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988Ab2FKVBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 17:01:20 -0400
Date: Mon, 11 Jun 2012 17:01:12 -0400
From: Don Zickus <dzickus@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>, nzimmer@sgi.com,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3] watchdog: Quiet down the boot messages
Message-ID: <20120611210112.GM32472@redhat.com>
References: <1339445050-29941-1-git-send-email-dzickus@redhat.com>
 <1339448210.19977.2.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339448210.19977.2.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 01:56:50PM -0700, Joe Perches wrote:
> On Mon, 2012-06-11 at 16:04 -0400, Don Zickus wrote:
> > A bunch of bugzillas have complained how noisy the nmi_watchdog is during
> > boot-up especially with its expected failure cases (like virt and bios
> > resource contention).
> []
> > diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> []
> > @@ -390,11 +397,23 @@ static int watchdog_nmi_enable(int cpu)
> []
> >  	if (!IS_ERR(event)) {
> > -		pr_info("enabled, takes one hw-pmu counter.\n");
> > +		/* only print for cpu0 or different than cpu0 */
> > +		if (cpu == 0 || cpu0_err) {
> > +			pr_info("enabled on all CPUs, permanently consumes ");
> > +			pr_cont("one hw-PMU counter.\n");
> 
> Don't worry about formats exceeding 80 column please.
> Don't break up pr_info into multiple bits either.
> 
> 			pr_info("enabled on all cpus, permanently consumes one hw-PMU counter\n");

Ok.  Thanks.

Cheers,
Don
