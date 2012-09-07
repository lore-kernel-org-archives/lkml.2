Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663Ab2IGRMA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 13:12:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48573 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab2IGRL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 13:11:59 -0400
Message-ID: <504A2ADC.4050703@gmail.com>
Date: Fri, 07 Sep 2012 11:11:56 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Robert Richter <robert.richter@amd.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf, ibs: Check syscall attribute flags
References: <1342826756-64663-1-git-send-email-dsahern@gmail.com> <1342826756-64663-9-git-send-email-dsahern@gmail.com> <20120906190238.GA29278@erda.amd.com> <5048F6BF.70106@gmail.com> <20120906195645.GD8285@erda.amd.com> <20120907164114.GJ8285@erda.amd.com> <504A25DB.2030100@gmail.com> <20120907170700.GK8285@erda.amd.com>
In-Reply-To: <20120907170700.GK8285@erda.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/7/12 11:07 AM, Robert Richter wrote:
>> Am I reading this right - if exclude_guest is set then perf_ibs_init
>> returns -EINVAL?
>
> Yes, the hardware does not support this. I will look for a solution
> which emulates this is software.

ugh, that's exactly we need for Intel: if precise is set, exclude_guest 
must be set.

In perf I would like to set exclude_guest if precise is set -- what I 
mentioned yesterday for the patch https://lkml.org/lkml/2012/7/20/437. 
With my patch -e cycles:p on AMD will then fail EINVAL.

David


