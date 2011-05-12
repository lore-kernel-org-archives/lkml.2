Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391Ab1ELPnE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 11:43:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53587 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756768Ab1ELPnC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 11:43:02 -0400
Message-ID: <4DCBFFF2.3030804@redhat.com>
Date: Thu, 12 May 2011 18:42:42 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Dhaval Giani <dhaval.giani@gmail.com>
CC: kvm@vger.kernel.org, joro@8bytes.org, agraf@suse.de, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Fabio Checconi <fchecconi@gmail.com>,
        Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
Subject: Re: [PATCH] kvm: log directly from the guest to the host kvm buffer
References: <1305207413.18715.3.camel@gondor.retis>	<4DCBF904.6040104@redhat.com> <BANLkTi=BnRCJ4S32S=+zNNOSTxmZsR6Jrg@mail.gmail.com>
In-Reply-To: <BANLkTi=BnRCJ4S32S=+zNNOSTxmZsR6Jrg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2011 06:39 PM, Dhaval Giani wrote:
> >
> >  I think that one hypercall per trace is too expensive.  Tracing is meant to
> >  be lightweight!  I think the guest can log to a buffer, which is flushed on
> >  overflow or when a vmexit occurs.  That gives us automatic serialization
> >  between a vcpu and the cpu it runs on, but not between a vcpu and a
> >  different host cpu.
> >
>
> hmm. So, basically, log all of these events, and then send them to the
> host either on an exit, or when your buffer fills up. There is one
> problem with approach though. One of the reasons I wanted this
> approach was beacuse i wanted to co-relate the guest and the host
> times. (which is why I kept is synchronous). I lose out that
> information with what you say. However I see your point about the
> overhead. I will think about this a bit more.

You might use kvmclock to get a zero-exit (but not zero-cost) time which 
can be correlated.

Another option is to use xadd on a shared memory area to have a global 
counter incremented.  However that can be slow on large machines, and is 
hard to do securely with multiple guests.


-- 
error compiling committee.c: too many arguments to function

