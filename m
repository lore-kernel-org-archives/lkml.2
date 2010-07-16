Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759121Ab0GPTTr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 15:19:47 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:7442 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759104Ab0GPTTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 15:19:45 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6045"; a="47567162"
From: "Ai Li" <aili@codeaurora.org>
To: "'Arjan van de Ven'" <arjan@linux.intel.com>
Cc: <akpm@linux-foundation.org>, <dwalker@codeaurora.org>, <mingo@elte.hu>,
        <shemminger@vyatta.com>, <czoccolo@gmail.com>, <len.brown@intel.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        <linux-pm@lists.linux-foundation.org>
References: <1279225825-31069-1-git-send-email-aili@codeaurora.org> <4C3FDAF1.7030107@linux.intel.com> <000001cb250b$e2813e60$a783bb20$@org> <4C4096A8.8060306@linux.intel.com>
In-Reply-To: <4C4096A8.8060306@linux.intel.com>
Subject: RE: [PATCH] cpuidle: extend cpuidle and menu governor to handle dynamic states
Date: Fri, 16 Jul 2010 13:19:43 -0600
Message-ID: <000301cb251b$d8cb7bf0$8a6273d0$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcslDEIoS2qUdLofRXerJZtVlutl3wACz87Q
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> the power value in the structure should represent ONLY the power
> level during the low power stage.
> And this should be independent of total duration.
> all other power is taken into account in terms of break even
> point/etc...

With static cstates, determining the break even point is
straitforward, compare the power numbers of state Cn and Cn-1, since
the states are ordered in increasing order of latency and power.
With dynamic cstates, Cn-1 may not be a valid state to compare any
more, for example, because Cn-1's latency may have become too high.
It seems the driver would need to know which cstate the govenor would
compare Cn to, and that would break the design philosophy of driver +
govenor.  The break even point does not seem to have a transistive
property, where the govenor can calculat Cn vs Cn-2 from some
arithmatic combination of Cn vs Cn-1 and Cn-1 vs Cn-2 values.  On the
other hand, if the power_usage field also includes the entry and exit
stages, then the driver does not need to know whether it should
calculate break even point for Cn vs Cn-1, or Cn vs Cn-2, etc.


> > One of the concerns I have is backwards compatibility.  As far as
> I
> > know, none of the current cpuidle drivers use the power_usage
> field.
> > If we always do compare_power, those drivers would break until
> > someone with technical device knowledge update the drivers to
> specify
> > power...  I could derive fake power_usage numbers by default,
> using
> > the cstate index position.  That seems kind of hacky but it would
> > remove the need for the compare_power flag and retain the current
> > behavior when cpuidle drivers do not provide their own power
> numbers.
> >
> 
> I'm fine with this approach actually; if someone does not fill it
> in, we fake data that makes it
> valid... better than getting complex code.

OK.

~Ai

Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum


