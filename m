Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008Ab1EJB2F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 21:28:05 -0400
Received: from mga14.intel.com ([143.182.124.37]:63389 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752560Ab1EJB2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 21:28:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,343,1301900400"; 
   d="scan'208";a="433321601"
Message-ID: <4DC894A0.5080303@intel.com>
Date: Tue, 10 May 2011 09:28:00 +0800
From: Huang Ying <ying.huang@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110402 Iceowl/1.0b2 Icedove/3.1.9
MIME-Version: 1.0
To: "prasad@linux.vnet.ibm.com" <prasad@linux.vnet.ibm.com>
CC: Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>, Vivek Goyal <vgoyal@redhat.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>
Subject: Re: [Bug] Kdump does not work when panic triggered due to MCE
References: <20110506165412.GB2719@in.ibm.com> <20110506173825.GK11636@one.firstfloor.org> <20110509163540.GA1963@in.ibm.com>
In-Reply-To: <20110509163540.GA1963@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Prasad,

On 05/10/2011 12:35 AM, K.Prasad wrote:
> On Fri, May 06, 2011 at 07:38:25PM +0200, Andi Kleen wrote:
>>> Has anybody tested this before? Or have found kdump working when fatal
>>> MCEs have actually occurred?
>>
>> Ying did some testing. mce-test has test cases for kdump.
>>
> 
> We'd be glad to hear about any successful testcases with recent kernels.
> My manual testing was quite similar to what the LTP kdump testcase would
> do i.e. configure kdump service, trigger crash through
> /proc/sysrq-trigger and watchout for kdump....but as you could see in
> the logs, that did not happen.
> 
>> My guess is you injected the error into some area used by the kexec
>> code or boot up path of the kexec kernel.
>>
>> -Andi
> 
> The logs did not suggest that the second kernel was booted into. The
> "Rebooting in ... seconds" message appeared from the first kernel. I
> tried the kdump testcase in atleast two dissimilar machines but with
> the same results, so it is not clear if the kexec code was affected by
> the MCE injection in both the cases.

>From your panic logs, it seems that panic is triggered for MCE on one
CPU,  when crash_kexec is executing, another panic is triggered on
another CPU for timeout mechanism in MCE.  We have seen something like
that in mce-test developing.  Please try following command line for mce
injecting.

mce-inject --no-random
/home/prasadkr/mce/mce-test/cases/soft-inj/panic_ucr/data/srar_over

Which is used by kdump test driver of mce-test too.

Best Regards,
Huang Ying
