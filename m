Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944Ab2LKQN0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 11:13:26 -0500
Received: from mail.skyhub.de ([78.46.96.112]:49769 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753215Ab2LKQNY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 11:13:24 -0500
Date: Tue, 11 Dec 2012 17:13:21 +0100
From: Borislav Petkov <bp@alien8.de>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Alex Shi <alex.shi@intel.com>, Alex Shi <lkml.alex@gmail.com>,
        rob@landley.net, mingo@redhat.com, peterz@infradead.org,
        gregkh@linuxfoundation.org, andre.przywara@amd.com, rjw@sisk.pl,
        paul.gortmaker@windriver.com, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        pjt@google.com, vincent.guittot@linaro.org,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/18] sched: simplified fork, enable load average into LB
 and power awareness scheduling
Message-ID: <20121211161320.GA28827@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Arjan van de Ven <arjan@linux.intel.com>,
	Alex Shi <alex.shi@intel.com>, Alex Shi <lkml.alex@gmail.com>,
	rob@landley.net, mingo@redhat.com, peterz@infradead.org,
	gregkh@linuxfoundation.org, andre.przywara@amd.com, rjw@sisk.pl,
	paul.gortmaker@windriver.com, akpm@linux-foundation.org,
	paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
	pjt@google.com, vincent.guittot@linaro.org,
	Preeti U Murthy <preeti@linux.vnet.ibm.com>
References: <1355127754-8444-1-git-send-email-alex.shi@intel.com>
 <CAGjg+kGAokK0oOAOJL=apkcyi_deqtHHsaJCViCz9tOMKG56bw@mail.gmail.com>
 <50C722AC.3080806@intel.com>
 <20121211154819.GC8873@liondog.tnic>
 <50C75935.1040004@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <50C75935.1040004@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 08:03:01AM -0800, Arjan van de Ven wrote:
> On 12/11/2012 7:48 AM, Borislav Petkov wrote:
> >On Tue, Dec 11, 2012 at 08:10:20PM +0800, Alex Shi wrote:
> >>Another testing of parallel compress with pigz on Linus' git tree.
> >>results show we get much better performance/power with powersaving and
> >>balance policy:
> >>
> >>testing command:
> >>#pigz -k -c  -p$x -r linux* &> /dev/null
> >>
> >>On a NHM EP box
> >>          powersaving               balance   	         performance
> >>x = 4    166.516 /88 68           170.515 /82 71         165.283 /103 58
> >>x = 8    173.654 /61 94           177.693 /60 93         172.31 /76 76
> >
> >This looks funny: so "performance" is eating less watts than
> >"powersaving" and "balance" on NHM. Could it be that the average watts
> >measurements on NHM are not correct/precise..? On SNB they look as
> >expected, according to your scheme.
> 
> well... it's not always beneficial to group or to spread out
> it depends on cache behavior mostly which is best

Let me try to understand what this means: so "performance" above with
8 threads means that those threads are spread out across more than one
socket, no?

If so, this would mean that you have a smaller amount of tasks on each
socket, thus the smaller wattage.

The "powersaving" method OTOH fills up the one socket up to the brim,
thus the slightly higher consumption due to all threads being occupied.

Is that it?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
