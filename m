Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759166Ab0GPTwf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 15:52:35 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:35589 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759075Ab0GPTwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 15:52:34 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6045"; a="47722396"
From: "Ai Li" <aili@codeaurora.org>
To: "'Arjan van de Ven'" <arjan@linux.intel.com>
Cc: <akpm@linux-foundation.org>, <dwalker@codeaurora.org>, <mingo@elte.hu>,
        <shemminger@vyatta.com>, <czoccolo@gmail.com>, <len.brown@intel.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        <linux-pm@lists.linux-foundation.org>
References: <1279225825-31069-1-git-send-email-aili@codeaurora.org> <4C3FDAF1.7030107@linux.intel.com> <000001cb250b$e2813e60$a783bb20$@org> <4C4096A8.8060306@linux.intel.com> <000301cb251b$d8cb7bf0$8a6273d0$@org> <4C40B3F6.5010106@linux.intel.com>
In-Reply-To: <4C40B3F6.5010106@linux.intel.com>
Subject: RE: [PATCH] cpuidle: extend cpuidle and menu governor to handle dynamic states
Date: Fri, 16 Jul 2010 13:52:32 -0600
Message-ID: <000601cb2520$6ecc1200$4c643600$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcslHbkauh8Tp9gYQ9WkoTPpsA5uAAAAbZvw
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> that's nice in theory.
> in practice though, this is all noise compared to some of the
> accuracy in the predictions.
> 
> break even generally is done against C1 only (since C1 is assumed
> to always be there)....
> yes it'd be nice to also have it against Cx in a matrix form, but
> that is a level of complexity that
> hasn't been worth it.
> 
> Note that the prediction is.... a prediction. I can show you data
> on how well it does (now that it's
> much better in 2.6.35-rc), but it's still "50% of the time we're
> within a factor of two of actual".
> not "we're 90% of the time within 10%".

OK.  I guess we can always add something like predicted_us later,
especially when the predication is more accurate.  For this patch, I
will change to
int (*prepare) (struct cpuidle_device *dev), and call it in cpuidle
instead of the govenor.

~Ai

Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum


> -----Original Message-----
> From: Arjan van de Ven [mailto:arjan@linux.intel.com]
> Sent: Friday, July 16, 2010 1:33 PM
> To: Ai Li
> Cc: akpm@linux-foundation.org; dwalker@codeaurora.org;
> mingo@elte.hu; shemminger@vyatta.com; czoccolo@gmail.com;
> len.brown@intel.com; linux-kernel@vger.kernel.org; linux-arm-
> msm@vger.kernel.org; linux-pm@lists.linux-foundation.org
> Subject: Re: [PATCH] cpuidle: extend cpuidle and menu governor to
> handle dynamic states
> 
> On 7/16/2010 12:19 PM, Ai Li wrote:
> >> the power value in the structure should represent ONLY the power
> >> level during the low power stage.
> >> And this should be independent of total duration.
> >> all other power is taken into account in terms of break even
> >> point/etc...
> >>
> > With static cstates, determining the break even point is
> > straitforward, compare the power numbers of state Cn and Cn-1,
> since
> > the states are ordered in increasing order of latency and power.
> > With dynamic cstates, Cn-1 may not be a valid state to compare
> any
> > more, for example, because Cn-1's latency may have become too
> high.
> > It seems the driver would need to know which cstate the govenor
> would
> > compare Cn to, and that would break the design philosophy of
> driver +
> > govenor.  The break even point does not seem to have a
> transistive
> > property, where the govenor can calculat Cn vs Cn-2 from some
> > arithmatic combination of Cn vs Cn-1 and Cn-1 vs Cn-2 values.  On
> the
> > other hand, if the power_usage field also includes the entry and
> exit
> > stages, then the driver does not need to know whether it should
> > calculate break even point for Cn vs Cn-1, or Cn vs Cn-2, etc.
> >
> 
> that's nice in theory.
> in practice though, this is all noise compared to some of the
> accuracy
> in the predictions.
> 
> break even generally is done against C1 only (since C1 is assumed
> to
> always be there)....
> yes it'd be nice to also have it against Cx in a matrix form, but
> that
> is a level of complexity that
> hasn't been worth it.
> 
> Note that the prediction is.... a prediction. I can show you data
> on how
> well it does (now that it's
> much better in 2.6.35-rc), but it's still "50% of the time we're
> within
> a factor of two of actual".
> not "we're 90% of the time within 10%".


