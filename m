Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757963Ab1EMKOO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 06:14:14 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34033 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756161Ab1EMKON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 06:14:13 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DCD04D5.80500@jp.fujitsu.com>
Date: Fri, 13 May 2011 19:15:49 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: CAI Qian <caiqian@redhat.com>, avagin@gmail.com,
        Andrey Vagin <avagin@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Minchan Kim <minchan.kim@gmail.com>, Hugh Dickins <hughd@google.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 2/4] oom: kill younger process first
References: <20110509182110.167F.A69D9226@jp.fujitsu.com> <20110510171335.16A7.A69D9226@jp.fujitsu.com> <20110510171641.16AF.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1105101629590.12477@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1105101629590.12477@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/05/11 8:31), David Rientjes wrote:
> On Tue, 10 May 2011, KOSAKI Motohiro wrote:
>
>> This patch introduces do_each_thread_reverse() and
>> select_bad_process() uses it. The benefits are two,
>> 1) oom-killer can kill younger process than older if
>> they have a same oom score. Usually younger process
>> is less important. 2) younger task often have PF_EXITING
>> because shell script makes a lot of short lived processes.
>> Reverse order search can detect it faster.
>>
>
> I like this change, thanks!  I'm suprised we haven't needed a
> do_each_thread_reverse() in the past somewhere else in the kernel.
>
> Could you update the comment about do_each_thread() not being break-safe
> in the second version, though?

ok.

