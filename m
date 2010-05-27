Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654Ab0E0Gyy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 02:54:54 -0400
Received: from mga05.intel.com ([192.55.52.89]:51024 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754089Ab0E0Gyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 02:54:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,310,1272870000"; 
   d="scan'208";a="802305318"
Message-ID: <4BFE1735.9080806@linux.intel.com>
Date: Thu, 27 May 2010 08:54:45 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Jin Dongming <jin.dongming@np.css.fujitsu.com>,
       LKLM <linux-kernel@vger.kernel.org>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [Patch-next] Remove notify_die in do_machine_check functioin
References: <4BFDDBA9.4010702@np.css.fujitsu.com> <1274930481.3444.258.camel@yhuang-dev.sh.intel.com>
In-Reply-To: <1274930481.3444.258.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I have heard about that on some machine, some hardware error output pin
> of chipset may be linked with some input pin of CPU which can cause MCE.

Yes that happens.

> That is, MCE is used to report some chipset errors too. I think that is
> why notify_die is called in do_machine_check. Simply removing notify_die
> is not good for these machines.

In general deciding what to do on a MCE is rather complicated
and probably too much for any die handler.

> Maybe we should fix the notifier user instead. Which notifier user
> consumes the DIE_NMI notification?

Yes. It would be good to find out which user it is. Perhaps gdb?

One approach would be to give it a different type (DIE_MCE)

But today we don't really need it. notify_die() is primarily for debuggers
of all kinds, and I never liked the idea to call a debugger on a machine
check.

So I would be ok with just removing the call.

-Andi

