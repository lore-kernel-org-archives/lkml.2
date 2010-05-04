Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758923Ab0EDMuu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 08:50:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:54130 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753233Ab0EDMus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 08:50:48 -0400
Message-ID: <4BE017D3.2010203@kernel.org>
Date: Tue, 04 May 2010 14:49:23 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org, x86@kernel.org,
       oleg@redhat.com, rusty@rustcorp.com.au, sivanich@sgi.com,
       heiko.carstens@de.ibm.com, dipankar@in.ibm.com, josh@freedesktop.org,
       paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
       arjan@linux.intel.com, torvalds@linux-foundation.org
Subject: Re: [PATCH 3/4] scheduler: replace migration_thread with cpu_stop
References: <1271952554-22368-1-git-send-email-tj@kernel.org>	 <1271952554-22368-4-git-send-email-tj@kernel.org>	 <1272893192.5605.122.camel@twins>  <4BDFC9FB.4020607@kernel.org> <1272977159.5605.171.camel@twins>
In-Reply-To: <1272977159.5605.171.camel@twins>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 04 May 2010 12:49:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2010 02:45 PM, Peter Zijlstra wrote:
>> Hmmm... maybe I'm mistaken but isn't that guaranteed by
>> busiest->active_balance which is protected by the rq lock?
>> active_load_balance_cpu_stop is scheduled iff busiest->active_balance
>> was changed from zero and only active_load_balance_cpu_stop() can
>> clear it at the end of its execution at which point the
>> active_balance_work is safe to reuse.
> 
> Ah, indeed. It wasn't obvious from looking at the patch, but when
> looking at the full code it fairly easy to see.

Hmmm... it's probably worthwhile to note tho.  I'll add a comment and
send out the updated patches soon.

Thanks.

-- 
tejun
