Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874Ab2IKB2F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 21:28:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:23498 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754374Ab2IKB2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 21:28:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,400,1344236400"; 
   d="scan'208";a="220505179"
Message-ID: <504E937C.4020903@intel.com>
Date: Tue, 11 Sep 2012 09:27:24 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        Venkatesh Pallipadi <venki@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH 1/2] nohz: clean up select_nohz_load_balancer()
References: <1347261059-24747-1-git-send-email-alex.shi@intel.com> <1347290774.2124.16.camel@twins>
In-Reply-To: <1347290774.2124.16.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2012 11:26 PM, Peter Zijlstra wrote:

> On Mon, 2012-09-10 at 15:10 +0800, Alex Shi wrote:
>> There is no load_balancer to be selected now. It just set state of
>> nohz tick stopping.
>>
>> So rename the function, pass the 'cpu' from parameter and then
>> remove the useless calling from tick_nohz_restart_sched_tick().
> 
> Please check who wrote the code you're patching and attempt to CC them
> as well, in this case Venki and Suresh.


Thanks! will care about this from now on.

> 
> I think the patch is fine, although I think we could have picked a
> better name, how about nohz_balance_enter_idle() ?


nohz_balance_enter_idle is good a name too. but I name it as
set_nohz_tick_stopped, since there is a clear_nohz_tick_stopped(), that
just do the opposed action of this function. According to this, is it
better to another function to nohz_balance_leave_idle()?
Or keep their current name?

Thanks
