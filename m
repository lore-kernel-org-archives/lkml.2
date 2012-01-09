Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab2AIONO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 09:13:14 -0500
Received: from mga02.intel.com ([134.134.136.20]:45259 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755116Ab2AIONL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 09:13:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="96084105"
Message-ID: <4F0AF5F5.9080403@linux.intel.com>
Date: Mon, 09 Jan 2012 06:13:09 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Youquan Song <youquan.song@intel.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        suresh.b.siddha@intel.com, len.brown@intel.com, anhua.xu@intel.com,
        chaohong.guo@intel.com, Youquan Song <youquan.song@linux.intel.com>,
        Paul Turner <pjt@google.com>
Subject: Re: [PATCH] x86,sched: Fix sched_smt_power_savings totally broken
References: <1326099367-4166-1-git-send-email-youquan.song@intel.com>  <1326103578.2442.50.camel@twins> <1326104915.2442.53.camel@twins>
In-Reply-To: <1326104915.2442.53.camel@twins>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/9/2012 2:28 AM, Peter Zijlstra wrote:
> On Mon, 2012-01-09 at 11:06 +0100, Peter Zijlstra wrote:
>> I'm >< close to committing a patch removing all the power_saving
>> magic from the scheduler. 
> 
> Unless someone steps up that says they care about this crap and are
> willing to clean it up this goes in...
> 

there is one legitimate choice to make in the scheduler, which is a real
honest preference:
the spread out versus "sort left" preference.

that doesn't need 15 knobs, that needs one.
I can totally buy that this might be easiest done by ripping out all
existing stuff, and then doing something relatively simple
(say, in the, "which CPU to run at" logic, a minor bias)


