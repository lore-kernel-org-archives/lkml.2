Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860Ab0KPSja (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 13:39:30 -0500
Received: from claw.goop.org ([74.207.240.146]:51776 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756785Ab0KPSj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 13:39:29 -0500
Message-ID: <4CE2CFDC.4070402@goop.org>
Date: Tue, 16 Nov 2010 10:39:24 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        Shailabh Nagar <nagar1234@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Venkatesh Pallipadi <venki@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Oleg Nesterov <oleg@redhat.com>, John stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Roland McGrath <roland@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>
Subject: Re: [RFC][PATCH v2 4/7] taskstats: Add per task steal time accounting
References: <20101111170352.732381138@linux.vnet.ibm.com>	<20101111170815.024542355@linux.vnet.ibm.com>	<1289677083.2109.167.camel@laptop>	<20101115155057.15f3be35@mschwide.boeblingen.de.ibm.com>	<1289833883.2109.494.camel@laptop>	<20101115184206.4463fd05@mschwide.boeblingen.de.ibm.com>	<1289843441.2109.520.camel@laptop>	<20101115185923.1c353d07@mschwide.boeblingen.de.ibm.com>	<1289844524.2109.524.camel@laptop>	<20101116095101.5d86d1e5@mschwide.boeblingen.de.ibm.com>	<1289909768.2109.592.camel@laptop>	<20101116163325.755a709f@mschwide.boeblingen.de.ibm.com>	<1289922329.2109.627.camel@laptop> <20101116170549.05d9e5c6@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <20101116170549.05d9e5c6@mschwide.boeblingen.de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2010 08:05 AM, Martin Schwidefsky wrote:
>>> Yes and no. The tracepoint idea looks interesting in itself. But that does
>>> not completely replace the per-task steal time. The hypervisor can take
>>> away the cpu anytime, it is still interesting to know which task was hit
>>> hardest by that. You could view the cpu time lost by a hypercall as
>>> "synchronous" steal time for the task, the remaining delta to the total
>>> per-task steal time as "asynchronous" steal time. 
>> Right, so there is no way the guest knows about the vcpu getting
>> scheduled, it can only derive the fact from hardware clocks after the
>> fact?
> Correct.

Yes, same for Xen.

    J

