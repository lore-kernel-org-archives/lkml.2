Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab1JLPoE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 11:44:04 -0400
Received: from claw.goop.org ([74.207.240.146]:45895 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392Ab1JLPoB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 11:44:01 -0400
Message-ID: <4E95B5C0.10606@goop.org>
Date: Wed, 12 Oct 2011 08:44:00 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>,
        Steven Rostedt <rostedt@goodmis.org>,
        "David S. Miller" <davem@davemloft.net>,
        David Daney <david.daney@cavium.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Jan Glauber <jang@linux.vnet.ibm.com>, Jason Baron <jbaron@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH RFC V3 2/8] stop_machine: make stop_machine safe and efficient
 to call early
References: <cover.1317755691.git.jeremy.fitzhardinge@citrix.com> <619c66d6da63aa086e2eac017e7aed216cc8ddc3.1317755691.git.jeremy.fitzhardinge@citrix.com> <8762k4grwy.fsf@rustcorp.com.au> <20111010073405.GC29035@elte.hu> <4E934F37.2020300@goop.org> <20111012073402.GJ18618@elte.hu>
In-Reply-To: <20111012073402.GJ18618@elte.hu>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2011 12:34 AM, Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>> On 10/10/2011 12:34 AM, Ingo Molnar wrote:
>>> * Rusty Russell <rusty@rustcorp.com.au> wrote:
>>>
>>>> On Tue,  4 Oct 2011 12:18:03 -0700, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>>>>> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>>>>>
>>>>> Make stop_machine() safe to call early in boot, before stop_machine()
>>>>> has been set up, by simply calling the callback function directly if
>>>>> there's only one CPU online.
>>>> Not that you need this, since it's >90% Tejun's code now, but:
>>>>
>>>> Acked-by: Rusty Russell <rusty@rustcorp.com.au>
>>> hey, extra review is always useful.
>>>
>>> Jeremy, Tejun, what's the expected merge path of these changes?
>> Andrew has already picked up the stop_machine patch, I think.  But it's
>> pretty settled now, so it shouldn't cause any problem if it gets via
>> multiple paths.
>>
>> What about the jump-label stuff?  Has that been going via tip.git in the
>> past, or by some other path?
> If it has Jason's and PeterZ's ack then it can go via any other tree 
> in this cycle - we are not carrying jump label patches right now.
>
> But those acks are very much desired.

Jason has already Acked it, but then pointed out a couple of problems to
address.

I'll add PeterZ to the next repost.

    J
