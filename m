Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760403Ab0JISmw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 14:42:52 -0400
Received: from rt-pi1-ru-sssup.pi1.garr.net ([193.206.136.46]:6442 "EHLO
	sssup.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756925Ab0JISmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 14:42:51 -0400
X-Greylist: delayed 3601 seconds by postgrey-1.27 at vger.kernel.org; Sat, 09 Oct 2010 14:42:51 EDT
Message-ID: <4CB0A998.3020407@sssup.it>
Date: Sat, 09 Oct 2010 19:42:48 +0200
From: Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100915 Thunderbird/3.0.8
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: 1 RT task blocks 4-core machine ?
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter wrote:
>  On Tue, 2010-10-05 at 00:26 +0200, Tommaso Cucinotta wrote:
>  >  A possible explanation might be that the CFS load balancing logic sees
>  >  my only active task (e.g., the ssh server or shell etc.) as running
>  >  alone on its core, and does not detect that it is inhibited to actually
>  >  run due to RT tasks on the same core. Therefore, it will not migrate
>  >  the task to the free cores. Does this explanation make sense
>  >  or is it completely wrong ?
>
>  Possibly, its got some logic to detect this but maybe it gets confused
>  still, in particular look at the adaptive cpu_power in
>  update_cpu_power() and calling functions.

Ok, I'll have a look (when I have some time :-( ), thanks.

>  >  Also, I'd like to hear whether this is considered the "normal/desired"
>  >  behavior of intermixing RT and non-RT tasks.
>
>  Pegging a cpu using sched_fifo/rr pretty much means you get to keep the
>  pieces, if it works nice, if you can make it work better kudos, but no
>  polling from sched_fifo/rr is not something that is considered sane for
>  the general health of your system.

Sure, I was not thinking to push/pull across heterogeneous scheduling
classes, but rather to simply account for the proper per-CPU tasks count
and load (including all the tasks comprising RT ones) when load-balancing
in CFS. Perhaps, you mean, e.g., if a RT task ends, the CPU would go idle
and it would be supposed to pull ? Just we don't do that, and at the next
load-balancing decision things would be fixed up (please, consider I don't
know the CFS load balancer so well).

So, for example, in addition to fix the reported issue, we'd get also that,
when pinning a heavy RT workload on a CPU, CFS tasks would migrate to other
CPUs, if available. Again, that doesn't need to be instantaneous (push), but
it could happen later when the CFS load-balancer is invoked (is it invoked
periodically, as of now ?).

Thanks,

	T.

-- 
Tommaso Cucinotta, Computer Engineering PhD, Researcher
ReTiS Lab, Scuola Superiore Sant'Anna, Pisa, Italy
Tel +39 050 882 024, Fax +39 050 882 003
http://retis.sssup.it/people/tommaso

