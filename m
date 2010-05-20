Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830Ab0ETLR7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 07:17:59 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:48988 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753729Ab0ETLR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 07:17:58 -0400
Date: Thu, 20 May 2010 13:17:53 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Nigel Cunningham <nigel@tuxonice.net>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@linux.jf.intel.com>,
       Venkatesh Pallipadi <venki@google.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>, ego@in.ibm.com,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <ncunningham@crca.org.au>
Subject: Re: [patch 0/7] sched: change nohz idle load balancing logic to
	push model
Message-ID: <20100520111753.GA2264@isilmar-3.linta.de>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Nigel Cunningham <nigel@tuxonice.net>,
	Suresh Siddha <suresh.b.siddha@intel.com>,
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
	Thomas Gleixner <tglx@linutronix.de>,
	Arjan van de Ven <arjan@linux.jf.intel.com>,
	Venkatesh Pallipadi <venki@google.com>,
	Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>, ego@in.ibm.com,
	LKML <linux-kernel@vger.kernel.org>,
	Nigel Cunningham <ncunningham@crca.org.au>
References: <20100517182726.089700767@sbs-t61.sc.intel.com> <4BF517FE.1000103@tuxonice.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BF517FE.1000103@tuxonice.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Thu, May 20, 2010 at 09:07:42PM +1000, Nigel Cunningham wrote:
> "Load balancing tick" is still number one in my powertop list of top  
> causes of wakeups (sitting at ~60 to 80 per second as I type this, with  
> ~170 wakeups per second total). Comparing this to the numbers I posted  
> earlier, we seem to have a win.
>
> I do wonder, though, whether further work could still be done. If I take  
> one core offline, for example, I'm still getting load balancing ticks.  
> Intuitively, I'd expect there to be no need for them with only one core  
> available. But maybe I'm just ignorant of what's going on.

Are you using HZ=1000, and is the CPU active ~ 6-8 % ? If so, is it just the
regular timer tick while the CPU is active, and so not a real "wakeup"? (Or
possibly double the number if both CPUs are active)

Best,
	Dominik
