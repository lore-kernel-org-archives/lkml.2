Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966160Ab0GPTdO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 15:33:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:18524 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966095Ab0GPTdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 15:33:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,215,1278313200"; 
   d="scan'208";a="639172477"
Message-ID: <4C40B3F6.5010106@linux.intel.com>
Date: Fri, 16 Jul 2010 12:33:10 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Ai Li <aili@codeaurora.org>
CC: akpm@linux-foundation.org, dwalker@codeaurora.org, mingo@elte.hu,
        shemminger@vyatta.com, czoccolo@gmail.com, len.brown@intel.com,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH] cpuidle: extend cpuidle and menu governor to handle dynamic
 states
References: <1279225825-31069-1-git-send-email-aili@codeaurora.org> <4C3FDAF1.7030107@linux.intel.com> <000001cb250b$e2813e60$a783bb20$@org> <4C4096A8.8060306@linux.intel.com> <000301cb251b$d8cb7bf0$8a6273d0$@org>
In-Reply-To: <000301cb251b$d8cb7bf0$8a6273d0$@org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/16/2010 12:19 PM, Ai Li wrote:
>> the power value in the structure should represent ONLY the power
>> level during the low power stage.
>> And this should be independent of total duration.
>> all other power is taken into account in terms of break even
>> point/etc...
>>      
> With static cstates, determining the break even point is
> straitforward, compare the power numbers of state Cn and Cn-1, since
> the states are ordered in increasing order of latency and power.
> With dynamic cstates, Cn-1 may not be a valid state to compare any
> more, for example, because Cn-1's latency may have become too high.
> It seems the driver would need to know which cstate the govenor would
> compare Cn to, and that would break the design philosophy of driver +
> govenor.  The break even point does not seem to have a transistive
> property, where the govenor can calculat Cn vs Cn-2 from some
> arithmatic combination of Cn vs Cn-1 and Cn-1 vs Cn-2 values.  On the
> other hand, if the power_usage field also includes the entry and exit
> stages, then the driver does not need to know whether it should
> calculate break even point for Cn vs Cn-1, or Cn vs Cn-2, etc.
>    

that's nice in theory.
in practice though, this is all noise compared to some of the accuracy 
in the predictions.

break even generally is done against C1 only (since C1 is assumed to 
always be there)....
yes it'd be nice to also have it against Cx in a matrix form, but that 
is a level of complexity that
hasn't been worth it.

Note that the prediction is.... a prediction. I can show you data on how 
well it does (now that it's
much better in 2.6.35-rc), but it's still "50% of the time we're within 
a factor of two of actual".
not "we're 90% of the time within 10%".

