Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317Ab0HXHvt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 03:51:49 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34344 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749Ab0HXHvr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 03:51:47 -0400
Subject: Re: [PATCH 0/4] Finer granularity and task/cgroup irq time
 accounting
From: Peter Zijlstra <peterz@infradead.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
        Paul Turner <pjt@google.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Tony Luck <tony.luck@intel.com>
In-Reply-To: <AANLkTim==2J3Fo8Axz0yLvpfWf1bq_e0c0EYWi6y3xRe@mail.gmail.com>
References: <1279583835-22854-1-git-send-email-venki@google.com>
	 <20100720095546.2f899e04@mschwide.boeblingen.de.ibm.com>
	 <AANLkTiktBNr3pVOHwxX3piwagtkGxHpp5TepBFS3UGhb@mail.gmail.com>
	 <20100722131239.208d9501@mschwide.boeblingen.de.ibm.com>
	 <AANLkTim==2J3Fo8Axz0yLvpfWf1bq_e0c0EYWi6y3xRe@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 24 Aug 2010 09:51:26 +0200
Message-ID: <1282636286.2605.2307.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-22 at 19:12 -0700, Venkatesh Pallipadi wrote:
> >
> > Well, the task and cgroup information is there but what does it really
> > tell me? As long as the irq & softirq time can be caused by any other
> > process I don't see the value of this incorrect data point.
> >
> 
> Data point will be correct. How it gets used is a different qn. This
> interface will be useful for Alert/Paranoid/Annoyed user/admin who
> sees that the job exec_time is high but it is not doing any useful
> work. 

I'm very sympathetic with Martin's POV. irq/softirq times per task don't
really make sense. In the case you provide above the solution would be
to subtract these times from the task execution time, not break it out.
In that case he would see his task not do much, and end up with the same
action list.


