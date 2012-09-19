Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116Ab2ISOEi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 10:04:38 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:48381 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755323Ab2ISOEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 10:04:37 -0400
Message-ID: <5059D015.2020104@linux.vnet.ibm.com>
Date: Wed, 19 Sep 2012 19:30:53 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Suzuki Poulose <suzuki@in.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: 3.6rc6 slab corruption.
References: <20120918143504.GA30585@redhat.com> <CA+55aFxd08idQXqm+JJ6xD+uzX_f7Qa25zFHb-eWBRQcEDPhkg@mail.gmail.com> <20120918185310.GA27689@redhat.com>
In-Reply-To: <20120918185310.GA27689@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12091914-0260-0000-0000-000001DEA39A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2012 12:23 AM, Dave Jones wrote:
> On Tue, Sep 18, 2012 at 11:38:44AM -0700, Linus Torvalds wrote:
>   >  Quoting the entire email, since I added Greg to the list of people (as
>   >  the documented maintainer of debugfs) along with what I think are the
>   >  guilty parties.
>   >
>   >  Dave, is trinity perhaps doing read calls on the same file in parallel?
>
> Yeah, entirely possible. It opens hundreds of fd's on startup, and then
> a bunch of threads do whatever operations are specified on those fds.
> (in this case, just read/setsockopt, but probably the read's are all that
>   is needed to trigger this)
>

Create a 350 processes reading /sys/kernel/debug/kvm/spinlocks/histo_blocked
file simultaneously in while loop for more than 3 hours on my box.
  Could not reproduce the problem. ( was it the right thing I did to 
reproduce.. not sure..). Wanted to check that because if it had hit the
problem I can verify fix with same stuff.

But in any case will try the fix what Konrad/Linus suggested, and come back.

