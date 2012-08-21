Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab2HUBkg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 21:40:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:22754 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751638Ab2HUBka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 21:40:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,799,1336374000"; 
   d="scan'208";a="207010835"
Date: Tue, 21 Aug 2012 09:40:27 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: John Stultz <johnstul@us.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-fsdevel@vger.kernel.org
Subject: Re: BUG: NULL pointer dereference in shmem_evict_inode()
Message-ID: <20120821014027.GA12316@localhost>
References: <20120821010403.GA12018@localhost>
 <5032E021.2030400@linaro.org>
 <5032E114.30503@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5032E114.30503@us.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 06:15:00PM -0700, John Stultz wrote:
> On 08/20/2012 06:10 PM, John Stultz wrote:
> >On 08/20/2012 06:04 PM, Fengguang Wu wrote:
> >>Hi John,
> >>
> >>The below oops happens in v3.5..v3.6-rc2 and it's bisected down
> >>to commit
> >>2a8c0883c ("time: Move xtime_nsec adjustment underflow handling
> >>timekeeping_adjust").
> >>
> >>However linux-next is working fine. Do you have any fixes not
> >>yet sent to Linus?
> >Yea, there's a fix pending in tip/timers/urgent
> >(4e8b14526ca7fb046a81c94002c1c43b6fdf0e9b) to catch crazy values
> >from settimeofday or the cmos clock that might overflow a ktime_t.
> >
> >Out of curiosity, how are you triggering/reproducing this?
> >
> 
> Looking at the commit you pointed out, it seems more likely Ingo's
> fix (1d17d17484d40f2d5b35c79518597a2b25296996) might be related, but
> that should have landed in v3.6-rc2.  So I'm not sure.

Ah ok, looking back into the logs, I didn't find v3.6-rc2 being
tested. Sorry I should have confused it with another bug.

I'll test v3.6-rc2.

Thanks,
Fengguang
