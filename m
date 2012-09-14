Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190Ab2INC4W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 22:56:22 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:42141 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754838Ab2INC4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 22:56:20 -0400
Message-ID: <50529CCB.1040708@linux.vnet.ibm.com>
Date: Fri, 14 Sep 2012 10:56:11 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: Dong Hao <haodong@linux.vnet.ibm.com>, acme@infradead.org, avi@redhat.com,
        mtosatti@redhat.com, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v7 3/3] KVM: perf: kvm events analysis tool
References: <1346061106-5364-1-git-send-email-haodong@linux.vnet.ibm.com> <1346061106-5364-4-git-send-email-haodong@linux.vnet.ibm.com> <503FB105.9000205@gmail.com> <5051678C.1070209@gmail.com>
In-Reply-To: <5051678C.1070209@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12091402-1396-0000-0000-000001DEFA18
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2012 12:56 PM, David Ahern wrote:

> 
> That suggests what is really needed is a 'live' mode - a continual updating of the output like perf top, not a record and analyze later mode. Which does come back to why I responded to this email -- the syntax is klunky and awkward.
> 
> So, I spent a fair amount of time today implementing a live mode. And after a lot of swearing at the tracepoint processing code I finally have it working. And the format extends easily (meaning < day and the next step) to a perf-based kvm_stat replacement. Example syntax is:
> 
>    perf kvm stat [-p <pid>|-a|...]
> 
> which defaults to an update delay of 1 second, and vmexit analysis.

Hi David,

I am very glad to see the live mode, it is very similar with kvm_stat(*). I think
kvm guys will like it.

> 
> The guts of the processing logic come from the existing kvm-events code. The changes focus on combining the record and report paths into one. The display needs some help (Arnaldo?), but it seems to work well.
> 
> I'd like to get opinions on what next? IMO, the record/report path should not get a foot hold from a backward compatibility perspective and having to maintain those options. I am willing to take the existing patches into git to maintain authorship and from there apply patches to make the live mode work - which includes a bit of refactoring of perf code (like the stats changes).

We'd better keep the record/report function, sometimes, we can only get perf.data
from the customers whose machine can not be reached for us.

Especially, other tracepoints are also interesting for us when the customers encounter
the performance issue, we always ask costumes to use "perf kvm stat -e xxx" to append
other events, like lock:*. Then, we can get not only the information of kvm events
by using 'perf kvm stat' but also other informations like 'perf lock' or 'perf script'
to get the whole sequences.

> 
> Before I march down this path, any objections, opinions, etc?

And, i think "live mode" is also useful for 'perf lock/sched', could you implement it
in perf core?

By the way, the new version of our patchset is ready, do you want to add your implement
after it is accepted by Arnaldo? Or are you going to post it with our patchset together?

Thanks!

* kvm_stat can be found at scripts/kvm/kvm_stat in the code of Qemu which locate at
  https://git.kernel.org/pub/scm/virt/kvm/qemu-kvm.git.

