Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751035Ab1EAEp4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 00:45:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:54529 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748Ab1EAEpz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 00:45:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,296,1301900400"; 
   d="scan'208";a="686590838"
Date: Sat, 30 Apr 2011 21:45:51 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Pekka Enberg <penberg@kernel.org>,
        Vince Weaver <vweaver1@eecs.utk.edu>, torvalds@linux-foundation.org,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@gmail.com>, Carl Love <carll@us.ibm.com>
Subject: Re: re-enable Nehalem raw Offcore-Events support
Message-ID: <20110501044551.GB16177@alboin.amr.corp.intel.com>
References: <alpine.DEB.2.00.1104291056220.22212@cl320.eecs.utk.edu>
 <BANLkTimjmYUJMGw0aB+w+E76H+kxSpqFZg@mail.gmail.com>
 <20110429172525.GA2745@tassilo.jf.intel.com>
 <alpine.LFD.2.02.1104291938240.3005@ionos>
 <4DBC6BC1.5090102@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DBC6BC1.5090102@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I would say that most if not all of the events are not generalizable
> in the sense that you are talking about; the events are very
> specific to the Torrent chip.  For example, the Torrent chip

It's similar also on Intel chips. There are lots of events 
which are useful, but are unlikely to have any equivalents
on other designs (or sometimes not even in later/earlier chip
generations). So such a requirement would make it impossible
to support them.

Given a lot of them are obscure, but a lot of others are not
and they can be very useful for specific analyses.
Computers are getting more and more complex and we need all
the help we can get to understand their behaviour.

For example we've been recently using various Nehalem+ events for NUMA
tuning (memory latency and offcore) and it is very useful and 
fuitful.  But there are a lot of specialities there which do not extend to 
other chips.

I've been working around that now by programming the special registers 
in user space from special wrapper scripts, but clearly that's not a good 
solution and doesn't also work in all cases.

-Andi
