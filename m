Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758027Ab0CaCRF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 22:17:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:48241 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758002Ab0CaCRB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 22:17:01 -0400
Message-ID: <4BB2B055.1020807@kernel.org>
Date: Wed, 31 Mar 2010 11:15:49 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, stable <stable@kernel.org>
Subject: Re: [PATCH] modules fix incorrect percpu usage
References: <20100330135208.GC20673@Krystal>	 <20100330125304.53f079db.akpm@linux-foundation.org>	 <20100330202421.GA28800@Krystal> <1270001013.19685.6677.camel@gandalf.stny.rr.com>
In-Reply-To: <1270001013.19685.6677.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 31 Mar 2010 02:15:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2010 11:03 AM, Steven Rostedt wrote:
> I don't know. A possible "NULL pointer dereference" seems to me to be a
> pretty big user visible impact.
> 
> I guess the question is, what's the risk of adding this change?

AFAICS, the risk is fairly low.  per_cpu_ptr(pcpudest, cpu) is
SHIFT_PERCPU_PTR((ptr), per_cpu_offset((cpu))) which is just a fancy
way of saying "typeof(ptr)((unsigned long)(ptr) + per_cpu_offset(cpu))"
with enough obfuscation to prevent gcc from optimizing it incorrectly.

Thanks.

-- 
tejun
