Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113Ab2ASMDz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 07:03:55 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:40853 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab2ASMDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 07:03:50 -0500
Message-ID: <4F18066D.9050102@linux.vnet.ibm.com>
Date: Thu, 19 Jan 2012 17:32:53 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ming Lei <tom.leiming@gmail.com>, Djalal Harouni <tixxdz@opendz.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Tony Luck <tony.luck@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@linux.intel.com>,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>,
        gouders@et.bocholt.fh-gelsenkirchen.de,
        Marcos Souza <marcos.mage@gmail.com>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "tglx@linutronix.de" <tglx@linutronix.de>, prasad@linux.vnet.ibm.com,
        justinmattock@gmail.com, Jeff Chua <jeff.chua.linux@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>,
        Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: x86/mce: machine check warning during poweroff
References: <CACVXFVMZhVFZajbZxng9dJqicy1XCK5n_QZLoefvkLkXvMsSZg@mail.gmail.com> <4F10929E.8070007@linux.vnet.ibm.com> <CA+55aFzGZ_eSTChemYczKr3-0zQ3J3MJ3TfGtxh9wkhSKrrfCA@mail.gmail.com> <4F10BDF7.8030306@linux.vnet.ibm.com> <CA+55aFyD=9MZCyo-Tq0J7g2p9Qvp=S+GADpUfoQ0dcde_bvzSg@mail.gmail.com> <4F10EB5B.5060804@linux.vnet.ibm.com> <1326766892.16150.21.camel@sbsiddha-desk.sc.intel.com> <4F1544EA.5060907@linux.vnet.ibm.com> <1326856624.5291.20.camel@sbsiddha-mobl2> <4F16C60B.4030903@linux.vnet.ibm.com> <20120118133236.GA3878@swordfish.minsk.epam.com> <1326924509.13915.29.camel@sbsiddha-mobl2>
In-Reply-To: <1326924509.13915.29.camel@sbsiddha-mobl2>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12011902-3568-0000-0000-000001141DF6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2012 03:38 AM, Suresh Siddha wrote:

> On Wed, 2012-01-18 at 16:32 +0300, Sergey Senozhatsky wrote:
>> Just a small note, since you're talking about removing CPU from nohz.idle_cpus_mask, 
>> that I'm able to reproduce this problem not only when offlining CPU, but during
>> onlininig as well (kernel 3.3):
> 
> yes, if the nohz state is not cleared properly during offline, then the
> issue can happen any time including cpu online etc.
> 
> Srivatsa, I thought CPU_PRI_SCHED_INACTIVE as INT_MAX for some reason
> and was expecting sched_ilb_notifier() will be called after setting that
> cpu as inactive. I am now using CPU_DYING which will be called from the
> cpu going down.
> 

> Here is the v2 version of the fix. Can you folks please give it another

> try?
> 


Suresh, your patch works perfectly! Thanks a lot!
Tested-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

And the reasoning behind the patch matches the test results:
we don't allow select_nohz_load_balancer() to undo the cleanup that we
did in sched_ilb_notifier(), by ensuring that sched_ilb_notifier() runs
*after* sched_cpu_inactive().

So, you can have my "Reviewed-by" too, if you like!

By the way, it would be great if you could kindly describe the above
mentioned subtle aspect in the patch description as well..

Regards,
Srivatsa S. Bhat

