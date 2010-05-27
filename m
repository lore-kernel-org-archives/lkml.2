Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695Ab0E0G55 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 02:57:57 -0400
Received: from mga10.intel.com ([192.55.52.92]:17480 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754854Ab0E0G5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 02:57:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,310,1272870000"; 
   d="scan'208";a="802305797"
Message-ID: <4BFE17E1.7020103@linux.intel.com>
Date: Thu, 27 May 2010 08:57:37 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
CC: Huang Ying <ying.huang@intel.com>,
       Jin Dongming <jin.dongming@np.css.fujitsu.com>,
       LKLM <linux-kernel@vger.kernel.org>
Subject: Re: [Patch-next] Remove notify_die in do_machine_check functioin
References: <4BFDDBA9.4010702@np.css.fujitsu.com> <1274930481.3444.258.camel@yhuang-dev.sh.intel.com> <4BFE0BE1.4040408@jp.fujitsu.com>
In-Reply-To: <4BFE0BE1.4040408@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

, Hidetoshi Seto wrote:
> (2010/05/27 12:21), Huang Ying wrote:
>> I have heard about that on some machine, some hardware error output pin
>> of chipset may be linked with some input pin of CPU which can cause MCE.
>> That is, MCE is used to report some chipset errors too. I think that is
>> why notify_die is called in do_machine_check. Simply removing notify_die
>> is not good for these machines.
>
> Hum, it sounds like "notify_die here is hook for proprietary chipset
> driver".  Anyone who have such machine and driver in real?

No, the die hook was to be compatible with the old KDB patchkit
which hooked into MCE too.

> Problems are (1) many callbacks will behave wrongly since they don't
> aware that DIE_NMI event can be posted from Machine Check, and (2)
> if the machine is not such special hardware it is just waste of time
> in critical context where quick page-poisoning might be required.

Yes the best action is probably to just remove it right now.

> One quick alternative is define "DIE_MCE" and use it instead, but
> if special hook like this is really required, I suppose we should
> invent some special interface for external plug-in like a chipset's
> LLHEH (low-level hardware error handler) etc., to allow additional
> platform-specific error handling in critical context.

I don't think we need or want that.

-Andi


