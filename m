Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024Ab1G1Rjo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 13:39:44 -0400
Received: from smtp-out.google.com ([74.125.121.67]:61053 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755820Ab1G1Rjm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 13:39:42 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=RpK3mFOnRRDh3mJIOhB3QrsZyGagKN6X3WDnuqEkPVr2m0fihDPOiUPtSmYNc5/un
	txN9J9csqwFzM8JgLBulA==
MIME-Version: 1.0
In-Reply-To: <20110728140808.GG11820@somewhere.redhat.com>
References: <1310679495-29104-1-git-send-email-vnagarnaik@google.com>
 <1311793038-15155-1-git-send-email-vnagarnaik@google.com> <1311855169.2617.168.camel@laptop>
 <20110728123131.GA11820@somewhere.redhat.com> <1311862204.2617.179.camel@laptop>
 <20110728140808.GG11820@somewhere.redhat.com>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Thu, 28 Jul 2011 10:39:09 -0700
Message-ID: <CAL26m8K7uOBKpBH4DNHV=ZJUtf0Wh_Pz7ZyVA12bH=B35K7AXQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] Add tracepoints to trace all system IRQs
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 28, 2011 at 7:08 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Thu, Jul 28, 2011 at 04:10:04PM +0200, Peter Zijlstra wrote:
>> On Thu, 2011-07-28 at 14:31 +0200, Frederic Weisbecker wrote:
>> >
>> > Because that requires to put the tracepoints in every interrupt sources
>> > for every archs instead of putting one in the generic space.
>>
>> To sum up from IRC, yes that's exactly what you need to do, because this
>> patch set assumes two things:
>>
>>  1) that there is a 1:1 mapping between interrupt sources and generic
>> handlers, and
>>
>>  2) that there is a neglectable amount of arch specific code for each
>> generic handler.
>>
>> Both are false in generic. Therefore there is no option but to
>> instrument each and every arch specific interrupt handler.
>>
>> Also, please use a single tracepoint for all that instead of this horrid
>> forest of random crap. Use something like arch_interrupt_enter(line_nr),
>> arch_interrupt_exit(line_nr).
>
> Right, so I guess the first iteration of the patchset was good in fact.
>

Frederic and Peter

Thanks for reviewing the patch series. I will post the first iteration
of this patch rebased to the latest HEAD.


Vaibhav Nagarnaik
