Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757078Ab1ERMtT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 08:49:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60106 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756848Ab1ERMtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 08:49:18 -0400
Message-ID: <4DD3C03F.4070002@redhat.com>
Date: Wed, 18 May 2011 15:49:03 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH v1 5/5] KVM: Expose a version 1 architectural PMU to guests
References: <1305129333-7456-1-git-send-email-avi@redhat.com>	 <1305129333-7456-6-git-send-email-avi@redhat.com>	 <20110517194117.GA26184@elte.hu> <4DD38B57.2070904@redhat.com>	 <20110518110759.GB16556@elte.hu> <1305718350.2466.7110.camel@twins>	 <4DD3AF88.2040704@redhat.com> <1305722116.2466.7171.camel@twins>
In-Reply-To: <1305722116.2466.7171.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2011 03:35 PM, Peter Zijlstra wrote:
> On Wed, 2011-05-18 at 14:37 +0300, Avi Kivity wrote:
> >  On 05/18/2011 02:32 PM, Peter Zijlstra wrote:
> >  >  On Wed, 2011-05-18 at 13:07 +0200, Ingo Molnar wrote:
> >  >  >
> >  >  >   It does through raw events - which are indeed model specific.
> >  >
> >  >  Which is exactly what is needed anyway, he gets a raw msr value.
> >  >
> >  >  The only thing that is not exposed is the ANY bit, but since KVM doesn't
> >  >  expose HT anyway that doesn't matter.
> >
> >  If I were to use raw events, I'd need to program AMD and Intel hosts
> >  separately.  As it is, I just use the generic counters and the perf
> >  backend does its thing.
>
> But why exactly, from what I understood you emulate an actual hardware
> PMU, that means the guest will be writing proper content to the relevant
> MSRs, you can feed that directly into the raw config field (with
> exception of the USR/OS/INT bits).

I am emulating an architectural PMU on a machine that may not have one 
(Intel P4 or AMD), so I need translation between the different config 
formats and event codes.

> I'm fairly sure that emulating the intel arch bits on an cpu that
> otherwise identifies itself as AMD is going to confuse things.

First, we can cheat and identify as Intel.  Second, I'd like to change 
architectural PMU probing to ignore the vendor (pending confirmation 
from AMD that they won't implement cpuid leaf 0xa in a way that is 
incompatible with Intel).  That's what architectural means, no?

-- 
error compiling committee.c: too many arguments to function

