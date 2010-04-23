Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883Ab0DWJk4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 05:40:56 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:57548 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756805Ab0DWJky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 05:40:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=dL2SRonT6uSW5orP58HEeX9IcBpxIVoDnc8wuJhb3wjtyBxb7bn8ii8o0mtyzqLG9z
         m3Ba9jruN8nx+gJdAL+EZlriTygMkmllgRdM00dEGlZiLit1I1QUE2DAEX4WP7VeCCO5
         mjSfetP0So3FNq0onhEJLRoUqV01H9bXSUQD0=
MIME-Version: 1.0
In-Reply-To: <20100423084926.GE21328@windriver.com>
References: <alpine.LFD.2.00.1004222208310.3155@localhost>
	 <20100423025850.GA21328@windriver.com>
	 <alpine.LFD.2.00.1004230907050.4151@localhost>
	 <1272009915.1646.25.camel@laptop>
	 <w2v520f0cf11004230131i743c596emfd0e5b8870330a8b@mail.gmail.com>
	 <20100423084926.GE21328@windriver.com>
Date: Fri, 23 Apr 2010 11:40:52 +0200
X-Google-Sender-Auth: 5fc5a0381fbfe690
Message-ID: <o2v520f0cf11004230240ubcdabe13ufba29de626d6b40b@mail.gmail.com>
Subject: Re: [PATCH] lockdep: Add nr_save_trace_invocations counter
From: John Kacur <jkacur@redhat.com>
To: Yong Zhang <yong.zhang@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>,
       Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
       Clark Williams <williams@redhat.com>,
       "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 23, 2010 at 10:49 AM, Yong Zhang <yong.zhang@windriver.com> wrote:
> On Fri, Apr 23, 2010 at 10:31:16AM +0200, John Kacur wrote:
>> > 8752+871+8+95+5+28+543+28+543+15=10888
>> >
>> > So you get a stack-trace for each direct-dependency, and you get a
>> > stack-trace for each LOCK_state, the sum seems to match the total
>> > invocations.
>> >
>> > Non of these numbers look strange..
>> >
>>
>> As I told Peter privately the laptop that triggered the
>> MAX_STACK_TRACE_ENTRIES every time, has met an
>> unfortunate early demise. However, I think it was the config - not the
>> hardware. On this machine where the above
>> numbers come from, I believe I have less debug options configured -
>> but it is running the exact same kernel as
>> the laptop was. (2.6.33.2-rt13)
>
> Through a rough computation:
> MAX_STACK_TRACE_ENTRIES/10888 = 24
> That means the average stack deepth is about 24.
> So I'm thinking if we can take a check on the biggest deepth?
> Could this make sense?
>

Hi Yong, yes that makes sense, I'll see if I can provide a patch for that too.

Thanks
