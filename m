Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935303Ab1JEUAu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 16:00:50 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60629 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934378Ab1JEUAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 16:00:47 -0400
Date: Wed, 5 Oct 2011 13:00:30 -0700
From: Tejun Heo <tj@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Fenghua Yu <fenghua.yu@intel.com>,
        Ingo Molnar <mingo@elte.hu>, H Peter Anvin <hpa@zytor.com>,
        Zwane Mwaikambo <zwane@arm.linux.org.uk>,
        Tony Luck <tony.luck@intel.com>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Len Brown <lenb@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/8] kernel/workqueue.c: unbound work queue rescuer
 runs on first cpu in cpumask_online_cpu
Message-ID: <20111005200030.GA373@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1317832759-10223-1-git-send-email-fenghua.yu@intel.com>
 <1317832759-10223-5-git-send-email-fenghua.yu@intel.com>
 <alpine.LFD.2.02.1110052050010.18778@ionos>
 <1317842362.6766.42.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317842362.6766.42.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 05, 2011 at 09:19:22PM +0200, Peter Zijlstra wrote:
> On Wed, 2011-10-05 at 20:52 +0200, Thomas Gleixner wrote:
> > On Wed, 5 Oct 2011, Fenghua Yu wrote:
> > 
> > > From: Fenghua Yu <fenghua.yu@intel.com>
> > > 
> > > If work queue is unbound to a specific cpu, run rescuer on first cpu in
> > > cpumask_online_cpu instead BSP which could be offlined.
> > 
> > This patch needs to be applied separate from that series as it fixes a
> > bug which affects all architectures which can offline the boot cpu.
> 
> AFAIKT it really doesn't matter in this case, all the rescuer_thread()
> needs is some bit set in that mask, since its UNBOUND it won't actually
> try and migrate to any cpu and just run wherever it woke up.

Yeah, for unbound, it's just a random fixed ID.  Changing it
dynamically wouldn't break anything but is pointless.  So, NACK.

Thanks.

-- 
tejun
