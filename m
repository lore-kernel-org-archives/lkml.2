Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244Ab0I3LRh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 07:17:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:36332 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508Ab0I3LRg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 07:17:36 -0400
Subject: Re: [PATCH] si time accounting accounts bh_disable'd time to si
From: Peter Zijlstra <peterz@infradead.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        Paul Turner <pjt@google.com>
In-Reply-To: <1285619753-10892-1-git-send-email-venki@google.com>
References: <1285003599.2275.756.camel@laptop>
	 <1285619753-10892-1-git-send-email-venki@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 30 Sep 2010 13:17:01 +0200
Message-ID: <1285845421.2144.12.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-27 at 13:35 -0700, Venkatesh Pallipadi wrote:
> >> >> > You still do have the problem with local_bh_disable() though, since you
> >> >> > cannot distinguish between having bh disabled and processing softirq.
> >> >> >
> >> >> > So a hardirq that hits while you have bh disabled will inflate your
> >> >> > softirq time.
> 
> >> >> Hmm, that bug is valid for CONFIG_VIRT_CPU_ACCOUNTING=y as well.
> >> >
> >> > And nobody ever noticed?
> >> >
> >> Yes. I inherited the API from VIRT_CPU_ACCOUNTING along with this
> >> local_bh_disable bug. Agree that we need one extra bit to handle this
> >> case. I will take a stab at fixing this along with refresh of this
> >> patchset if no one else has beaten me to it until then.
> >
> >Make sure to only fix the softirq processing on the hardirq tail, not
> > the ksoftirqd one :-)
> 
> softirq processing from hardirq tail and ksoftirqd are currently
> handled in the same way and I didn't see any issues changing both of
> them. Am I missing something? 

Well, ksoftirq is a task and its runtime should be accounted to that
task, not softirq.. otherwise softirq and task time get all funny, makes
sense?
