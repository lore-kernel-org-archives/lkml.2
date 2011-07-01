Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756273Ab1GAM2Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 08:28:25 -0400
Received: from smtp-out.google.com ([74.125.121.67]:32471 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755199Ab1GAM2Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 08:28:24 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=j5o+Y1NeVgV0jnfpitJiyTrosrF1GowkwasqE674xLj3ACGrxiO5aQQBhz8PX4d5A
	efH9uN+CwlLRcvDmg+Mww==
MIME-Version: 1.0
In-Reply-To: <CABPqkBQcC4nviYA9UjCKngvnNKXhfWTjV18ArD9J2j3hbEnQGw@mail.gmail.com>
References: <1309421396-17438-1-git-send-email-ming.m.lin@intel.com>
	<CABPqkBRs1nd7KptkVCg5QeG0AJJck=VHAgCpSOJKpOgdDuN-6A@mail.gmail.com>
	<CABPqkBRZf41wbJKq2PCdMzDhgNMn0VYkVsaZToS34AXpRzTGLw@mail.gmail.com>
	<1309490230.24590.93.camel@minggr.sh.intel.com>
	<CABPqkBSy4BxZRnWP2CUPRaazaEukJSaWe0USRt9XBBTePaJS7g@mail.gmail.com>
	<CABPqkBQcC4nviYA9UjCKngvnNKXhfWTjV18ArD9J2j3hbEnQGw@mail.gmail.com>
Date: Fri, 1 Jul 2011 14:28:20 +0200
Message-ID: <CABPqkBR0PXX7G5o-dhV=dBB_tYRt_ft6LCkqP_0hKCcxiz8o6Q@mail.gmail.com>
Subject: Re: [PATCH 0/4] perf: Intel uncore pmu counting support
From: Stephane Eranian <eranian@google.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 1, 2011 at 2:23 PM, Stephane Eranian <eranian@google.com> wrote:
> Lin,
>
> Ok, false alarm. Vol3b is correct. I missed the fact that if you want
> wrmsrl() to write full width generic counters, you have to use the
> alternate MSR alias. I guess that's for backward compatibility.
> So for full width wrmsrl on PERFCTR0 -> use 0x41c
>
> uncore counter value: 0x678ffffeeee
> core fixed counter value: 0x678ffffeeee
>       core generic counter value: 0xffffffffeeee
> wide core generic counter value: 0x678ffffeeee
>
> I think full width write to fixed counters has been there
> for a long time. Looks like the problem was only present
> for core generic counters until SNB.
>
Forgot to say, that we could adapt the code to use the alternate
registers if full width wrmsrl() is supported. That would mitigate
a bit the overhead of sampling and counting by simply not interrupting
that often to accumulate counts in the SW counter.
