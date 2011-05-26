Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757780Ab1EZPI2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 11:08:28 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64738 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766Ab1EZPI1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 11:08:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=l9z3jypokasSzihFStKvv3/7cF6Z+Lcpht8VuaVeqmclZtNmKyX8J8/UuEWVT040D3
         PrPmY71NENqUfN81X0M32TiFMPfRgvWTdAs5QlEXlvvedaxjS3POJ4Tw1K56CzpUEvUz
         RILcAOa2hQF5qt/HCLst99k89F/zRjZ+KDjKg=
MIME-Version: 1.0
In-Reply-To: <20110526013029.GA28103@linux.vnet.ibm.com>
References: <20110524011824.GL7428@linux.vnet.ibm.com>
	<4DDB093F.2060601@kernel.org>
	<20110524013523.GO7428@linux.vnet.ibm.com>
	<4DDC21E1.1070502@kernel.org>
	<4DDC48E3.1060108@kernel.org>
	<20110525045253.GB2262@linux.vnet.ibm.com>
	<4DDD7F96.3090408@kernel.org>
	<20110525223437.GO2341@linux.vnet.ibm.com>
	<4DDD8775.1000501@kernel.org>
	<20110526011310.GP2341@linux.vnet.ibm.com>
	<20110526013029.GA28103@linux.vnet.ibm.com>
Date: Thu, 26 May 2011 08:08:26 -0700
X-Google-Sender-Auth: clv8QFtWa3ckCXiV8ovQqtksxx4
Message-ID: <BANLkTinC2q6Fjf7=2GZoJ=+c+fzpdwAvuQ@mail.gmail.com>
Subject: Re: [tip:core/rcu] Revert "rcu: Decrease memory-barrier usage based
 on semi-formal proof"
From: Yinghai Lu <yinghai@kernel.org>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        tglx@linutronix.de, mingo@elte.hu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 6:30 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Wed, May 25, 2011 at 06:13:10PM -0700, Paul E. McKenney wrote:
>> On Wed, May 25, 2011 at 03:49:25PM -0700, Yinghai Lu wrote:
>> > On 05/25/2011 03:34 PM, Paul E. McKenney wrote:
>> > > On Wed, May 25, 2011 at 03:15:50PM -0700, Yinghai Lu wrote:
>> > >>> There is a new branch yinghai.2011.05.24a on:
>> > >>>
>> > >>> git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git
>> > >>>
>> > >>> Or will be as soon as kernel.org updates its mirrors.
>> > >>>
>> > >>> I am not sure I could call this "clean", but it does revert that commit
>> > >>> and 11 of the subsequent commits that depend on it.  It does build,
>> > >>> and I will test it once my currently running tests complete.
>> > >>
>> > >> yes, with those revert, there is no delay in 10 times booting.
>> > >
>> > > Unfortunately, there are rcutorture test failures with the revert...
>> >
>> > confused.
>>
>> Given what I had to do to generate the revert, not exactly a surprise,
>> I am afraid.  Just means that the resulting RCU sometimes fails to
>> wait for all pre-existing readers, and rcutorture catches it.
>>
>> > what is the next?
>>
>> 1.    I send you a patch that I hope will fix the softlockup
>>       you saw.  I am testing this.
>>
>> 2.    I am working on more detailed instrumentation, and will
>>       send a patch on that.
>>
>> 3.    If time allows, break down the operations RCU is doing
>>       and test them in isolation.
>>
>> Other thoughts?
>
> And here is patch #1.  Could you please try applying this on top of
> Peter Zijlstra's patch to see if it gets rid of the softlockups you saw?
>
>                                                        Thanx, Paul
>
> ------------------------------------------------------------------------
>
> rcu: Start RCU kthreads in TASK_INTERRUPTIBLE state
>
> Upon creation, kthreads are in TASK_UNINTERRUPTIBLE state, which can
> result in softlockup warnings.  Because some of RCU's kthreads can
> legitimately be idle indefinitely, start them in TASK_INTERRUPTIBLE
> state in order to avoid those warnings.
>

Yes, it fixes the lock up warning.

Thanks

Yinghai
