Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703Ab1GLI1Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 04:27:25 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49990 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab1GLI1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 04:27:23 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4E1C055C.1030103@jp.fujitsu.com>
Date: Tue, 12 Jul 2011 17:27:08 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.18) Gecko/20110616 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: tony.luck@intel.com
CC: fenghua.yu@intel.com, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: ia64: replace old cpumask functions with new one
References: <4E031B97.2010609@jp.fujitsu.com> <CA+8MBbLg4jBmaYkVW13WReNm8nyP1p0k3CPN=pQmvwPfRKyeQA@mail.gmail.com>
In-Reply-To: <CA+8MBbLg4jBmaYkVW13WReNm8nyP1p0k3CPN=pQmvwPfRKyeQA@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/07/07 6:14), Tony Luck wrote:
> 2011/6/23 KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>:
>> We plan to remove old obsolete cpumask functions and plan to
>> change task->cpus_allowed implementation in future.
> ...
>>  arch/ia64/kernel/smpboot.c              |   56 +++++++++++++++---------------
> 
> I get some new warnings in this file with your patch:
> 
> 
> arch/ia64/kernel/smpboot.c:454: warning: passing argument 2 of
> ‘cpumask_set_cpu’ discards qualifiers from pointer target type
> arch/ia64/kernel/smpboot.c:581: warning: passing argument 1 of
> ‘cpumask_clear’ discards qualifiers from pointer target type
> arch/ia64/kernel/smpboot.c:613: warning: passing argument 2 of
> ‘cpumask_set_cpu’ discards qualifiers from pointer target type
> arch/ia64/kernel/smpboot.c:637: warning: passing argument 2 of
> ‘cpumask_set_cpu’ discards qualifiers from pointer target type
> arch/ia64/kernel/smpboot.c:745: warning: passing argument 2 of
> ‘cpumask_clear_cpu’ discards qualifiers from pointer target type
> 
> Four of the five involve "cpu_callin_mask" which is "volatile", the other is for
> "cpu_present_mask" - not sure what the problem is for this one.

Sorry for the delay. I'm sorry for the annoying you.
But ummm.. I can't understand the author expect which effect by this volatile.
If I am correct, its volatile has no effect. we can simply remove it.

So, I'll respin this.

Thanks.


