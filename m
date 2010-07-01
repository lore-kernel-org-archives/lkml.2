Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756441Ab0GAOzU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 10:55:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:45929 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246Ab0GAOzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 10:55:18 -0400
Message-ID: <4C2CABF2.2020801@kernel.org>
Date: Thu, 01 Jul 2010 16:53:38 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Sridhar Samudrala <sri@us.ibm.com>, netdev <netdev@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dmitri Vorobiev <dmitri.vorobiev@movial.com>,
       Jiri Kosina <jkosina@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH repost] sched: export sched_set/getaffinity to modules
References: <1277983179.1917.10.camel@laptop> <1277984603.1917.15.camel@laptop> <20100701115507.GA31333@redhat.com> <20100701122340.GB31333@redhat.com> <1277987657.1917.32.camel@laptop> <1277988395.1917.47.camel@laptop> <20100701130816.GB32223@redhat.com> <1277991024.1917.108.camel@laptop> <20100701133956.GD32223@redhat.com> <4C2CA5C5.4040402@kernel.org> <20100701144624.GA11171@redhat.com>
In-Reply-To: <20100701144624.GA11171@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 01 Jul 2010 14:53:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 07/01/2010 04:46 PM, Oleg Nesterov wrote:
>> It might be a good idea to make the function take extra clone flags
>> but anyways once created cloned task can be treated the same way as
>> other kthreads, so nothing else needs to be changed.
> 
> This makes kthread_stop() work. Otherwise the new thread is just
> the CLONE_VM child of the caller, and the caller is the user-mode
> task doing ioctl() ?

Hmmm, indeed.  It makes the attribute inheritance work but circumvents
the whole reason there is kthreadd.

Thanks.

-- 
tejun
