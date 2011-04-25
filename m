Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758834Ab1DYSjb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 14:39:31 -0400
Received: from smtp-out.google.com ([74.125.121.67]:26447 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758696Ab1DYSj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 14:39:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=QI1buhxwew3j3dDTPFihJUZ0YqWgdELsjaU9QbbEUe92TH3igJ1mwoSHJFH/+96Qdx
         Jv4Ok8i4IN1M2ZmpucjQ==
MIME-Version: 1.0
In-Reply-To: <20110425180528.GA30724@elte.hu>
References: <BANLkTi=G7-v3ysxK2wY_3f8TecbD6ZjKog@mail.gmail.com>
	<20110422105211.GB1948@elte.hu>
	<20110422165007.GA18401@vps.sharma-home.net>
	<20110422203022.GA20573@elte.hu>
	<20110422203222.GA21219@elte.hu>
	<20110423000347.GC9328@tassilo.jf.intel.com>
	<1303545012.2298.44.camel@twins>
	<20110424021907.GB3019@alboin.amr.corp.intel.com>
	<20110425174110.GB28239@elte.hu>
	<BANLkTiks31-pMJe4zCKrppsrA1d6KanJFA@mail.gmail.com>
	<20110425180528.GA30724@elte.hu>
Date: Mon, 25 Apr 2011 20:39:25 +0200
Message-ID: <BANLkTimUFP68L2CwEwoLDPMwJSO_aK_Qvg@mail.gmail.com>
Subject: Re: [generalized cache events] Re: [PATCH 1/1] perf tools: Add
 missing user space support for config1/config2
From: Stephane Eranian <eranian@google.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dehao Chen <danielcdh@gmail.com>, Andi Kleen <ak@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, arun@sharma-home.net,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, eranian@gmail.com,
        Arun Sharma <asharma@fb.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 25, 2011 at 8:05 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Dehao Chen <danielcdh@gmail.com> wrote:
>
>> > ... and the resulting low level of noise in the average period length is
>> > what matters. The instruction itself will still be one of the hotspot
>> > instructions, statistically.
>>
>> Not true. This skid will lead to some aggregation and shadow effects on some
>> certain instructions. To make things worse, these effects are deterministic
>> and cannot be removed by either sampling for multiple times or by averaging
>> among instructions within a basic block. As a result, some actual "hot spot"
>> are not sampled at all. You can simply try to collect a basic block level
>> CPI, and you'll get a very misleading profile.
>
> This certainly does not match the results i'm seeing on real applications,
> using "-e instructions:pp" PEBS+LBR profiling. How do you explain that? Also,
> can you demonstrate your claim with a real example?
>

LBR removes the off-by-1 IP problem, it does not remove the shadow effect, i.e.,
that blind spot of N cycles caused by the PEBS arming mechanism.
