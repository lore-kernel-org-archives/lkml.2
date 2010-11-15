Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758080Ab0KOSKp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 13:10:45 -0500
Received: from canuck.infradead.org ([134.117.69.58]:48055 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756654Ab0KOSKo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 13:10:44 -0500
Subject: Re: [RFC][PATCH v2 4/7] taskstats: Add per task steal time
 accounting
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        Shailabh Nagar <nagar1234@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Venkatesh Pallipadi <venki@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Oleg Nesterov <oleg@redhat.com>, John stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org,
        "jeremy.fitzhardinge" <jeremy.fitzhardinge@citrix.com>
In-Reply-To: <20101115185923.1c353d07@mschwide.boeblingen.de.ibm.com>
References: <20101111170352.732381138@linux.vnet.ibm.com>
	 <20101111170815.024542355@linux.vnet.ibm.com>
	 <1289677083.2109.167.camel@laptop>
	 <20101115155057.15f3be35@mschwide.boeblingen.de.ibm.com>
	 <1289833883.2109.494.camel@laptop>
	 <20101115184206.4463fd05@mschwide.boeblingen.de.ibm.com>
	 <1289843441.2109.520.camel@laptop>
	 <20101115185923.1c353d07@mschwide.boeblingen.de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 15 Nov 2010 19:08:44 +0100
Message-ID: <1289844524.2109.524.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-15 at 18:59 +0100, Martin Schwidefsky wrote:
> Steal time per task is at least good for performance problem analysis.
> Sometimes knowing what is not the cause of a performance problem can help you
> tremendously. If a task is slow and has no steal time, well then the hypervisor
> is likely not the culprit. On the other hand if you do see lots of steal time
> for a task while the rest of the system doesn't cause any steal time can tell
> you something as well. That task might hit a specific function which causes
> hypervisor overhead. The usefulness depends on the situation, it is another
> data point which may or may not help you. 

If performance analysis is the only reason, why not add a tracepoint on
vcpu enter that reports the duration the vcpu was out for and use perf
to gather said data? It can tell you what process was running and what
instruction it was at when the vcpu went away.

No need to add 40 bytes per task for that.
