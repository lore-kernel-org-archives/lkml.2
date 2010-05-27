Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159Ab0E0NPf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 09:15:35 -0400
Received: from mga06.intel.com ([134.134.136.21]:21727 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753345Ab0E0NPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 09:15:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,311,1272870000"; 
   d="scan'208";a="625333695"
Message-ID: <4BFE706D.2070909@linux.intel.com>
Date: Thu, 27 May 2010 15:15:25 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Huang Ying <ying.huang@intel.com>,
       Jin Dongming <jin.dongming@np.css.fujitsu.com>,
       LKLM <linux-kernel@vger.kernel.org>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [Patch-next] Remove notify_die in do_machine_check functioin
References: <4BFDDBA9.4010702@np.css.fujitsu.com>	<1274930481.3444.258.camel@yhuang-dev.sh.intel.com>	<4BFE1735.9080806@linux.intel.com> <20100527120410.43a0e04c@lxorguk.ukuu.org.uk>
In-Reply-To: <20100527120410.43a0e04c@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

> That would be because you don't do driver work I suspect. If you are
> doing driver work then its extremely useful ending up in the debugger
> when you get an MCE because some random bit of hardware on the bus
> decided to throw a tantrum.
>
> This is particularly the case with AMD/ATI and AMD/Nvidia chipset systems
> which tend to throw this kind of error if you prod some of the chipset
> controllers (eg the Nvidia SATA) in them in just the wrong way.
>
> So NAK simply removing it. As a driver writer I want to end up in the
> debugger when this happens so I can work out what led up to the MCE.

Have you ever tried that? It does not sound like it to be honest :)

You have no chance to figure out why the MCE happened
either, unless you run through the handler first.

Unless you want to do all the work the MCE handler does manually
somehow in the debugger (reading all banks on all CPUs, parsing
all the bits, doing all the other work). I wrote the code
to do that and even I am a bit scared of doing all the manually.

Also if the MCE is recoverable you'll just get a log entry
with all the information and if it's not recoverable you
get a panic which ends up entering the debugger anyways.

In addition you won't get a single debugger entry, but a parallel
entry on all CPUs because a MCE is broadcast.

So overall I still think handling MCEs in debuggers does not
make sense.

-Andi
