Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728Ab0I3QhW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 12:37:22 -0400
Received: from smtp-out.google.com ([216.239.44.51]:3362 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755675Ab0I3QhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 12:37:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Fl8qxHFnFcSEZzv2I+ORlS1OsFSfujFfvEf580njCP09yvDFiaHHLp0dGk+lTYq6AJ
         bL6HwSXYNiZzFJjH3aHg==
MIME-Version: 1.0
In-Reply-To: <8762xnwtjn.fsf@basil.nowhere.org>
References: <1285788096-29471-1-git-send-email-venki@google.com>
	<8762xnwtjn.fsf@basil.nowhere.org>
Date: Thu, 30 Sep 2010 09:37:17 -0700
Message-ID: <AANLkTimd0Acz3kcNswBoDS2XytfUgbE+ZyTxHUAcNspa@mail.gmail.com>
Subject: Re: Proper kernel irq time accounting -v3
From: Venkatesh Pallipadi <venki@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        Paul Turner <pjt@google.com>, Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 30, 2010 at 12:59 AM, Andi Kleen <andi@firstfloor.org> wrote:
> Venkatesh Pallipadi <venki@google.com> writes:
>>
>> Solution to (1) involves adding extra timing on irq entry/exit to
>> get the fine granularity info and then exporting it to user.
>
> This means RDTSC right?
>
> I am a bit concerned about overhead on systems with high TSC overhead.
> Is there a way to turn this off at runtime for those?
>

Yes. Overhead will be RDTSC.
notsc is a boot option that will disable this. I didn't want to have a
specific run time option to disable this as we would already have
other RDTSC users like native_sched_clock. Do you think we need a
specific option to disable this feature? I don't like adding a runtime
option because it complicates the code a bit (to handle things like
someone turning it off and turning it on later, etc).

Thanks,
Venki
