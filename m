Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312Ab1FEINO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 04:13:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49972 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752927Ab1FEINN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 04:13:13 -0400
Message-ID: <4DEB3A8A.9060401@redhat.com>
Date: Sun, 05 Jun 2011 11:12:58 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH v1 5/5] KVM: Expose a version 1 architectural PMU to guests
References: <1305129333-7456-1-git-send-email-avi@redhat.com>	 <1305129333-7456-6-git-send-email-avi@redhat.com> <1307112113.2353.3391.camel@twins>
In-Reply-To: <1307112113.2353.3391.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2011 05:41 PM, Peter Zijlstra wrote:
> On Wed, 2011-05-11 at 11:55 -0400, Avi Kivity wrote:
> >  +static u64 read_gp_pmc(struct kvm_pmu *pmu, struct kvm_pmc *pmc)
> >  +{
> >  +       u64 counter, enabled, running;
> >  +
> >  +       counter = pmc->counter;
> >  +
> >  +       if (pmc->perf_event)
> >  +               counter += perf_event_read_value(pmc->perf_event,
> >  +&enabled,&running);
> >  +
> >  +       /* FIXME: Scaling needed? */
>
> Yeah, either that or use attr.pinned = 1, doing the latter will result
> in an error when the PMU is overloaded though.

So what's the scale factor? enabled / running?

-- 
error compiling committee.c: too many arguments to function

