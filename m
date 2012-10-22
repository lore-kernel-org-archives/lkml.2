Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932434Ab2JVGdE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 02:33:04 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34238 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862Ab2JVGdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 02:33:03 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Date: Mon, 22 Oct 2012 15:32:19 +0900 (JST)
Message-Id: <20121022.153219.30891002.d.hatayama@jp.fujitsu.com>
To: vgoyal@redhat.com
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, x86@kernel.org,
        mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, len.brown@intel.com,
        fenghua.yu@intel.com, ebiederm@xmission.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, holzheu@linux.vnet.ibm.com
Subject: Re: [PATCH v1 0/2] x86, apic: Disable BSP if boot cpu is AP
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
In-Reply-To: <20121019151753.GF27052@redhat.com>
References: <20121018141449.GB18147@redhat.com>
	<20121019.122054.476812873.d.hatayama@jp.fujitsu.com>
	<20121019151753.GF27052@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v1 0/2] x86, apic: Disable BSP if boot cpu is AP
Date: Fri, 19 Oct 2012 11:17:53 -0400

> On Fri, Oct 19, 2012 at 12:20:54PM +0900, HATAYAMA Daisuke wrote:
> 
> [..]
>> > Instead of capturing the dump of whole memory, isn't it more efficient
>> > to capture the crash dump of VM in question and then if need be just
>> > take filtered crash dump of host kernel. 
>> > 
>> > I think that trying to take unfiltered crash dumps of tera bytes of memory
>> > is not practical or woth it for most of the use cases.
>> > 
>> 
>> If there's a lag between VM dump and host dump, situation on the host
>> can change, and VM dump itself changes the situation. Then, we cannot
>> know what kind of bug resides in now, so we want to do as few things
>> as possible between detecting the bug reproduced and taking host
>> dump. So I expressed ``capturing the situation''.
> 
> I would rather first detect the problem on guest and figure out what's
> happening. Once it has been determined that something is wrong from
> host side then debug what's wrong with host by using regular kernel
> debugging techiniques. 
> 
> Even if you are interested in capturing crash dump, after you have
> decided that it is a host problem, then you can write some scripts which
> trigger host crash dump when relevant event happens.
> 
> Seriously, this argument could be extended to regular processes also.
> Something is wrong with my application, so lets dump the whole system,
> provide a facility to extract each process's code dump from that huge
> dump and then examine if it was an application issue or kernel issue.
> 
> I am skeptical that this approach is going to fly in practice. Dumping
> huge images, processing and transferring these is not very practical.
> So I would rather narrow down the problem on a running system and take
> filtered dump of appropriate component where I suspect the problem is.
> 
> [..]

Such bug is often complicated and it often takes some time to
reproduce it. Once it is reproduced, we cannot use system where the
bug has been reproduced, long time since it's mainly managed by
another teams under some project and there are many tasks that must be
done on the system. It would be best to proceed the debug little by
little as you suggest, but it's difficult to do that from practiacl
reason.

Crash dump of tera bytes cannot support our method perfectly, I can
understand this. The reason why we have done these ways with no
problem is that memory size was not so large that it never made crash
dump long to complete. But doing filtering means that the data
necessary for debug might be excluded. This is the worst case we must
avoid. Consdering trade-off between recent large memory size and
filtering, I think filtering with more granurality is needed. I want
to consider this in the future work.

BTW, I feel you basically shows positive attitude to this patch set
itself. I believe that kdump has merits only. Could you tell me what
is needed for this patch set to be acked by you?

>> > capability was the primary reason that s390 also wants to support
>> > kdump otherwise there firmware dumping mechanism was working just
>> > fine.
>> > 
>> 
>> I don't know s390 firmware dumping mechanism at all, but is it possble
>> for s390 to filter crash dump even on firmware dumping mechanism?
> 
> AFAIK, s390 dump mechanism could not filter dump and tha's the reason
> they wanted to support kdump and /proc/vmcore so that makedumpfile 
> could filter it. I am CCing Michael Holzheu, who did the s390 kdump work.
> He can tell it better.
> 

Hmm, we Fujitsu also have firmware dump mechanism and it cannot filter
memory too. I think it would be a similar situation.

Thanks.
HATAYAMA, Daisuke

