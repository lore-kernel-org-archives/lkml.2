Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634Ab2FFBhA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 21:37:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:49862 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750Ab2FFBg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 21:36:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="153451284"
Message-ID: <4FCEB434.9040006@linux.intel.com>
Date: Wed, 06 Jun 2012 09:36:52 +0800
From: Chen Gong <gong.chen@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        tony.luck@intel.com, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 2/2] x86: mce: Implement cmci poll mode for intel machines
References: <20120524174943.989990966@linutronix.de> <20120524175056.478167482@linutronix.de> <4FCC1F7C.5000008@linux.intel.com> <alpine.LFD.2.02.1206042158200.3086@ionos> <4FCDF1C8.9020007@linux.intel.com> <20120605125758.GD13495@aftab.osrc.amd.com>
In-Reply-To: <20120605125758.GD13495@aftab.osrc.amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012/6/5 20:57, Borislav Petkov 写道:
> On Tue, Jun 05, 2012 at 07:47:20PM +0800, Chen Gong wrote:
>>>  static void intel_threshold_interrupt(void)
>>>  {
>>> +	if (cmci_storm_detect())
>>> +		return;
>>>  	machine_check_poll(MCP_TIMESTAMP, &__get_cpu_var(mce_banks_owned));
>>>  	mce_notify_irq();
>>>  }
>> I think cmci_storm_detect should be placed in the machine_check_poll,
>> not out of it. Because machine_check_poll it the core execution logic
>> for CMCI handling, in the meanwhile, poll timer and mce-inject module
>> call machine_check_poll at any time.
> Are you saying you need CMCI throttling for when you inject MCEs?

Yes, I am just afraid similar situation happening when injecting MCEs or
poll timer
running too fast, which is like a pseduo CMCI storm. Maybe similar logic
behind
CMCI_STORM can be used there.


