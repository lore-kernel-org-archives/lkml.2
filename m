Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934887Ab1JETTh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 15:19:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:60802 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934402Ab1JETTf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 15:19:35 -0400
Subject: Re: [PATCH 4/8] kernel/workqueue.c: unbound work queue rescuer runs
 on first cpu in cpumask_online_cpu
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@elte.hu>,
        H Peter Anvin <hpa@zytor.com>,
        Zwane Mwaikambo <zwane@arm.linux.org.uk>,
        Tony Luck <tony.luck@intel.com>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Len Brown <lenb@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
Date: Wed, 05 Oct 2011 21:19:22 +0200
In-Reply-To: <alpine.LFD.2.02.1110052050010.18778@ionos>
References: <1317832759-10223-1-git-send-email-fenghua.yu@intel.com>
	 <1317832759-10223-5-git-send-email-fenghua.yu@intel.com>
	 <alpine.LFD.2.02.1110052050010.18778@ionos>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317842362.6766.42.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-10-05 at 20:52 +0200, Thomas Gleixner wrote:
> On Wed, 5 Oct 2011, Fenghua Yu wrote:
> 
> > From: Fenghua Yu <fenghua.yu@intel.com>
> > 
> > If work queue is unbound to a specific cpu, run rescuer on first cpu in
> > cpumask_online_cpu instead BSP which could be offlined.
> 
> This patch needs to be applied separate from that series as it fixes a
> bug which affects all architectures which can offline the boot cpu.

AFAIKT it really doesn't matter in this case, all the rescuer_thread()
needs is some bit set in that mask, since its UNBOUND it won't actually
try and migrate to any cpu and just run wherever it woke up.


