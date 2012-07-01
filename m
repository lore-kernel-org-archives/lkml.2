Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932600Ab2GATgr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 15:36:47 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:48470 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756167Ab2GATgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 15:36:40 -0400
Message-ID: <4FF0A6C5.5080509@linaro.org>
Date: Sun, 01 Jul 2012 21:36:37 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: lenb@kernel.org, trenn@suse.de, srivatsa.bhat@linux.vnet.ibm.com,
        deepthi@linux.vnet.ibm.com, linux-acpi@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, linux-pm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, Colin Cross <ccross@android.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] acpi: intel_idle : break dependency between modules
References: <201206271506.29034.trenn@suse.de> <201206282124.09857.rjw@sisk.pl> <4FED69BE.20707@linaro.org> <201206300027.05175.rjw@sisk.pl>
In-Reply-To: <201206300027.05175.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2012 12:27 AM, Rafael J. Wysocki wrote:
> On Friday, June 29, 2012, Daniel Lezcano wrote:
>> On 06/28/2012 09:24 PM, Rafael J. Wysocki wrote:
>>> On Thursday, June 28, 2012, Daniel Lezcano wrote:
>>>> When the system is booted with some cpus offline, the idle
>>>> driver is not initialized. When a cpu is set online, the
>>>> acpi code call the intel idle init function. Unfortunately
>>>> this code introduce a dependency between intel_idle and acpi.
>>>>
>>>> This patch is intended to remove this dependency by using the
>>>> notifier of intel_idle. This patch has the benefit of
>>>> encapsulating the intel_idle driver and remove some exported
>>>> functions.
>>>>
>>>> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
>>>
>>> This one looks good to me too.
>>>
>>> Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
>>
>> Thanks for the review Rafael.
>>
>>> Len, are you going to take it?
>>
>> Rafael, Len,
>>
>> After the discussion [1], I put in place a tree at:
>>
>> ssh://git.linaro.org/srv/git.linaro.org/git/people/dlezcano/cpuidle-next.git
>> #cpuidle-next
>>
>> I proposed this tree to group the cpuidle modifications and prevent the
>> last minutes conflict when Len will apply them.
>>
>> I also included the tree into linux-next for wider testing.
> 
> I can't speak for Len, but I'm not sure he'll like this.

I sent the proposition a week ago and Len was Cc'ed. I guess he is very
busy but the problem we are facing is there are a lot of pending
modifications for cpuidle because of some new architecture (like the
big.LITTLE and tegra3). Colin's patchset is one of them.

> Anyway, you seem to have the same material as Len in that tree, won't there
> be any conflicts in linux-next?

At the first glance no, until he merge the patches we sent. As I already
said the purpose is to help to consolidate the patches sent for cpuidle
by acting as a proxy.

I hope that helps.

Thanks
  -- Daniel



-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

