Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907Ab0EaLrc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 07:47:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:37162 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751762Ab0EaLrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 07:47:31 -0400
Message-ID: <4C03A1C0.4020104@kernel.org>
Date: Mon, 31 May 2010 13:47:12 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>, Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 2/4] sched: implement __set_cpus_allowed()
References: <1273747705-7829-1-git-send-email-tj@kernel.org>	 <1273747705-7829-3-git-send-email-tj@kernel.org>	 <1275292866.27810.21441.camel@twins>  <4C03879A.8030505@kernel.org>	 <1275300084.27810.21850.camel@twins> <1275300165.27810.21858.camel@twins>	 <4C038A08.8090209@kernel.org> <1275300904.27810.21907.camel@twins>	 <4C038D18.9010006@kernel.org> <1275302796.27810.22049.camel@twins>
In-Reply-To: <1275302796.27810.22049.camel@twins>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 31 May 2010 11:47:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 05/31/2010 12:46 PM, Peter Zijlstra wrote:
> So workers _are_ thread bound and don't migrate, so for those I don't
> see the problem, that is of course until we have to break affinity when
> their CPU goes down, at which point we should clear PF_THREAD_BOUND I
> think.
> 
> For the rescue thread, why not set PF_THREAD_BOUND when its running
> worklets and clear it when done? That way we get extra checking that
> people won't migrate it when its not allowed.
> 
> Does that work, or did I miss something?

The rescuers migrate themselves so should be okay.  I still think it
would be better to migrate back detached workers.  It's a slow path
for sure but there's a big gaping hole between machine-slow and
human-slow and works can be human-slow (ie. hotplug operation not
finished in several minutes).  I'll see if that's implementable w/o
adding an additional interface.

Thanks.

-- 
tejun
