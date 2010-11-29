Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057Ab0K2Nir (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 08:38:47 -0500
Received: from hera.kernel.org ([140.211.167.34]:54899 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753474Ab0K2Niq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 08:38:46 -0500
Message-ID: <4CF3ACD6.7020109@kernel.org>
Date: Mon, 29 Nov 2010 14:38:30 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH UPDATED 06/14] signal: use GROUP_STOP_PENDING to avoid
 stopping multiple times for a single group stop
References: <1290768569-16224-1-git-send-email-tj@kernel.org> <1290768569-16224-7-git-send-email-tj@kernel.org> <4CF0EE11.6000206@kernel.org> <20101128190741.GA12896@redhat.com>
In-Reply-To: <20101128190741.GA12896@redhat.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 29 Nov 2010 13:38:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.

On 11/28/2010 08:07 PM, Oleg Nesterov wrote:
>> @@ -732,6 +732,9 @@ static int prepare_signal(int sig, struct task_struct *p, int from_ancestor_ns)
>>  		t = p;
>>  		do {
>>  			unsigned int state;
>> +
>> +			t->group_stop = 0;
>> +
> 
> Yes.
> 
> But, afaics, this is not enough. Say, what about zap_other_threads() ?
> We shouldn't allow sub-threads to stop in this case.
> 
> Basically, every time we clear ->group_stop_count we should also reset
> ->group_stop for every thread. Fortunately, every time we already do
> while_each_thread().

Yes, indeed.  Will update accordingly.

Thanks.

-- 
tejun
