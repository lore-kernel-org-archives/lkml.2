Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750874Ab0FKEBb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 00:01:31 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:42714 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699Ab0FKEBa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 00:01:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qeHYNEfAP4Sozh8VXsX3dd4RUt9ErDsc0RSz9U9N4Y3Zqrt1XCiZBOOrk68YCwMOnN
         ejmW5tmKLFbhm/trdvUR1UJB91JPYDrmX39vWzq1eXkvE0GNDk/+dfFpH5Pd+j/SM2q0
         xoEoZ87siacraf7qLcrx7O0SGD/uzM+cWG6Ok=
MIME-Version: 1.0
In-Reply-To: <20100610.173716.35035195.davem@davemloft.net>
References: <AANLkTimw2Hzv1WIJXehqMo4450ftRJWwefQipDM9Zxb4@mail.gmail.com>
	<20100610.173716.35035195.davem@davemloft.net>
Date: Thu, 10 Jun 2010 21:01:28 -0700
Message-ID: <AANLkTimrIOLiX3m3rFsdakHn8PRhkfSHCCmYUlw6rkFz@mail.gmail.com>
Subject: Re: PROBLEM: Off-by-one bug on sun4u SMP
From: Ryan Davis <iconoclasmandheresy@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 10, 2010 at 5:37 PM, David Miller <davem@davemloft.net> wrote:
> From: Ryan Davis <iconoclasmandheresy@gmail.com>
> Date: Thu, 10 Jun 2010 11:05:09 -0700
>
>> On at least some sun4u machines, the CPU numbering starts at one not 0.
>> This causes an off-by-one bug as other parts of the code assume
>> zero-based numbering.
>>
>> If you set max-cpus in the kernel config to the actual number of CPUs,
>> the last CPU will be ignored and unused.
>> This is because the CPU numbering starts at 1 but the code to check
>> against max-cpus assumes a zero-based numbering.
>>
>> On my computer: Sun Ultra 60 2x450mhz Ultrasparc.
>> Building with max-cpus of 2 ignores the second cpu because 2 (one
>> based cpu number) >= 2 (zero based max cpus)
>> Rebuilding with a larger max-cpus is a workaround but non optimal.
>
> max-cpus means "one larger than the maximum PHYSICAL cpu number", not
> the number of cpus.  That's what this setting means, at least on
> sparc64.
>

OK... so there are no kernel data structures allocated for CPU #0
which is not present? It is my understanding that this is not the case
but I could be wrong. If this is true, then a chunk of kernel memory
is wasted tor the phantom CPU #0.

If this is the desired behavior then the semantics of the setting are
questionable, since a kernel compiled for 2 cpus will only run on 1...

A quick search was unable to find documentation on this quirk. Perhaps
you could point me at some?


---
Those who will not reason, are bigots, those who cannot, are fools,
and those who dare not, are slaves.
  -- Lord Byron
