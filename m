Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193Ab0LIUPX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 15:15:23 -0500
Received: from smtp-out.google.com ([216.239.44.51]:26635 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239Ab0LIUPW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 15:15:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jBREcG8kwJ9FhE5jWCVSWqeZADOD+6AXRAmxrfdBGC0mAHbILRF3V9b4C0kCzElvg9
         xorBeh6cyZ8E23IQChNw==
MIME-Version: 1.0
In-Reply-To: <1291922467.6803.44.camel@twins>
References: <1291267223.2405.314.camel@minggr.sh.intel.com>
	<1291922467.6803.44.camel@twins>
Date: Thu, 9 Dec 2010 21:15:19 +0100
Message-ID: <AANLkTi=GeCHZ23J5UDoUfbWnLHfVWCeA7f9Gh_sKYSqa@mail.gmail.com>
Subject: Re: [RFC PATCH 2/3 v3] perf: Implement Nehalem uncore pmu
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Lin Ming <ming.m.lin@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 9, 2010 at 8:21 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Thu, 2010-12-02 at 13:20 +0800, Lin Ming wrote:
>> +       /* Check CPUID signatures: 06_1AH, 06_1EH, 06_1FH */
>> +       family = boot_cpu_data.x86;
>> +       model = boot_cpu_data.x86_model;
>> +       if (family != 6 || (model != 0x1A && model != 0x1E && model != 0x1F))
>> +               return;
>
> So that's 26, 30 and 31? Curiously
> arch/x86/kernel/cpu/perf_event_intel.c does have 31.
>
It is also missing model 44 (0x2c).
