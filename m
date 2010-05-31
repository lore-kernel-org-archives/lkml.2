Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756399Ab0EaKTX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 06:19:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:55349 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049Ab0EaKTW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 06:19:22 -0400
Message-ID: <4C038D18.9010006@kernel.org>
Date: Mon, 31 May 2010 12:19:04 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>, Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 2/4] sched: implement __set_cpus_allowed()
References: <1273747705-7829-1-git-send-email-tj@kernel.org>	 <1273747705-7829-3-git-send-email-tj@kernel.org>	 <1275292866.27810.21441.camel@twins>  <4C03879A.8030505@kernel.org>	 <1275300084.27810.21850.camel@twins> <1275300165.27810.21858.camel@twins>	 <4C038A08.8090209@kernel.org> <1275300904.27810.21907.camel@twins>
In-Reply-To: <1275300904.27810.21907.camel@twins>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 31 May 2010 10:19:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 05/31/2010 12:15 PM, Peter Zijlstra wrote:
> On Mon, 2010-05-31 at 12:06 +0200, Tejun Heo wrote:
>>  I meant CPU_ONLINE not CPU_UP_PREPARE.  So,
>> we can mark a cpu active before other CPU_ONLINE callbacks are run.
> 
> OK, that should work.

The only remaining problemw is PF_THREAD_BOUND.  It needs to be set
for wq workers (including rescuers).  Would it be okay to add an
interface which only ignores PF_THREAD_BOUND?

Thanks.

-- 
tejun
