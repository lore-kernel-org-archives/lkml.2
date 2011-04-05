Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568Ab1DEJuq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 05:50:46 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:36859 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab1DEJuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 05:50:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:reply-to:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=jq1PFDQRhk4rBpCmN85dzr6Punixohx5RY76WynI6+DTYeQ67rRZg2mv6u0+WglrXs
         k790feLnpSPjLbt/gvS76yrinM4DV8X45S3OpijFvSfnvu3aPqAPUVQuul0l0iNyW8pB
         RhkYGMgrj5CRGPvGAB0llmNdELC1nYva7nXs4=
MIME-Version: 1.0
Reply-To: ben@iagu.net
In-Reply-To: <1301994229.2225.30.camel@twins>
References: <AANLkTikZZ4MXZjx_+6u-vKVSgxULQo2BkQKRO6K_vzFy@mail.gmail.com>
	<20110318123031.GB6066@8bytes.org>
	<AANLkTin2k1ZSLa0NG6pKBvHYnKEV21t8pEqzeJWNn_rR@mail.gmail.com>
	<4D871F6C.40207@redhat.com>
	<AANLkTintxnKRQ4rD4Wo8_MHU4yJVzYaRhR=GjnDMGwNj@mail.gmail.com>
	<AANLkTin8ZoUAVR2ajoV6cBFiUSe_Dof0_k60dcAGW3r-@mail.gmail.com>
	<4D875842.9050308@redhat.com>
	<AANLkTikWQS281kTtJ32-qo5U+w_BAak7qUwVhUQgOxxv@mail.gmail.com>
	<4D8773AA.8030408@redhat.com>
	<AANLkTin3Si1EAa=Va6f45vW-tYQ1Yk8dETXpHJHHHkxe@mail.gmail.com>
	<1300726498.2884.493.camel@edumazet-laptop>
	<4D8784A9.8040303@redhat.com>
	<1300727545.2884.513.camel@edumazet-laptop>
	<AANLkTinn7OKKKvBYe7KWsrReuYDdma5+8gHJHXdCacDY@mail.gmail.com>
	<1300746429.2837.20.camel@edumazet-laptop>
	<1300777760.2837.38.camel@edumazet-laptop>
	<AANLkTik-Rt-Fy-2fKQTr2JBB9f7U2cbc0FmTZOoXc1+5@mail.gmail.com>
	<4D887B6A.2020102@redhat.com>
	<1301993300.2225.26.camel@twins>
	<4D9AD92D.401@redhat.com>
	<1301994229.2225.30.camel@twins>
Date: Tue, 5 Apr 2011 15:35:40 +0545
X-Google-Sender-Auth: -i2dpFyhVm5fvFfC-MXvIWNMUoI
Message-ID: <BANLkTi=npNjb06_yaYezUb28pKC7dnmGjA@mail.gmail.com>
Subject: Re: [PATCH] posix-timers: RCU conversion
From: Ben Nagy <ben@iagu.net>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Avi Kivity <avi@redhat.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, KVM list <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        John Stultz <johnstul@us.ibm.com>,
        Richard Cochran <richard.cochran@omicron.at>,
        Mike Galbraith <efault@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 5, 2011 at 2:48 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Tue, 2011-04-05 at 11:56 +0300, Avi Kivity wrote:
>>
>> Could be waking up due to guest wakeups, or qemu internal wakeups
>> (display refresh) or due to guest timer sources which are masked away in
>> the guest (if that's the case we should optimize it away).
>
> Right, so I guess we're all clutching at straws here :-)
>
> Ben how usable is that system when its in that state? Could you run a
> function trace or a trace with all kvm and sched trace-events enabled?

I'm just rebuilding the storage on the network to work around an ocfs2
kernel oops (trying nfs/rdma) so I can't test anything just at the
moment.

I ran some tests under load with the local ext4 ssd, and, weirdly,
everything looked to be just fine - the huge bulk of the system time
was in svm_vcpu_run, which is as it should be I guess, but that was
with only 60 loaded guests.

I'll be able to repeat the same workload test tomorrow, and I'll see
how the perf top stuff looks. I should also be able to repeat the '96
idle guests' test and see if it's the same - if so we'll do that
tracing. My kernel's a moving target at the moment, sorry, we're
tracking the natty git (with Eric's rcu patch merged in).

Thanks, all,

ben
