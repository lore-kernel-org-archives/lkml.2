Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab1DNWNw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 18:13:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:59571 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753885Ab1DNWNv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 18:13:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,213,1301900400"; 
   d="scan'208";a="733528573"
Message-ID: <4DA7719F.4060905@linux.intel.com>
Date: Thu, 14 Apr 2011 15:13:51 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Stable <stable@kernel.org>, John Kacur <jkacur@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [stable] [PATCH V4] futex: set FLAGS_HAS_TIMEOUT during demux
 for FUTEX_WAIT
References: <ef361f98ac0e0771c14ec7facb5b41086eb4ba50.1302817381.git.dvhart@linux.intel.com> <20110414215656.GB14169@kroah.com>
In-Reply-To: <20110414215656.GB14169@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2011 02:56 PM, Greg KH wrote:
> On Thu, Apr 14, 2011 at 02:43:01PM -0700, Darren Hart wrote:
>> The FLAGS_HAS_TIMEOUT flag was not getting set, causing the restart_block to
>> restart futex_wait() without a timeout after a signal.
>>
>> Commit b41277dc7a18ee332d in 2.6.38 introduced the regression by accidentally
>> removing the the FLAGS_HAS_TIMEOUT assignment from futex_wait() during the setup
>> of the restart block. Restore the originaly behavior.
>>
>> Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=32922
>>
>> V2: Added references to commit message.
>> V3: Set flag during restart block instead of do_futex()
>> V4: Correct stupid order of assignment mistake pointed out by Eric
>>
>> Signed-off-by: Darren Hart <dvhart@linux.intel.com>
>> Reported-by: Tim Smith <tsmith201104@yahoo.com>
>> Reported-by: Torsten Hilbrich <torsten.hilbrich@secunet.com>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Cc: Ingo Molnar <mingo@elte.hu>
>> CC: Eric Dumazet <eric.dumazet@gmail.com>
>> CC: John Kacur <jkacur@redhat.com>
>> ---
> 
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
> for how to do this properly.

Sigh, apologies. Fixing, will add stable to CC: in changelog. Gives me a
chance to improve the subject anyway.

Ingo, Greg, please ignore this and the previous V[123] patches.

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
