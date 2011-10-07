Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965244Ab1JGKey (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 06:34:54 -0400
Received: from smtp-out.google.com ([216.239.44.51]:5386 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759786Ab1JGKew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 06:34:52 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:x-system-of-record;
	b=YvLF0Tfjyp+HQAxLEfyDi17dzbk/7FJV39LwrQpiTd10jCF2VSj5EghxMZz6t352W
	YISf85pK3XZdqYXvn9MJw==
MIME-Version: 1.0
In-Reply-To: <1317921909.29658.16.camel@twins>
References: <1317912555-9559-1-git-send-email-eranian@google.com>
	<1317912555-9559-5-git-send-email-eranian@google.com>
	<1317921909.29658.16.camel@twins>
Date: Fri, 7 Oct 2011 12:34:50 +0200
Message-ID: <CABPqkBTWU8AO_t4CNRbQVdGU3OnkAT9W=Ngj+x4dL5hpAHz=2g@mail.gmail.com>
Subject: Re: [PATCH 04/12] perf_events: sync branch stack sampling with X86 precise_sampling
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, acme@redhat.com,
        ming.m.lin@intel.com, andi@firstfloor.org, robert.richter@amd.com,
        ravitillo@lbl.gov
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 6, 2011 at 7:25 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2011-10-06 at 16:49 +0200, Stephane Eranian wrote:
>>
>> On Intel X86 PERF_SAMPLE_BRANCH_STACK is implemented using LBR,
>> therefore both features must be coordinated as they may not
>> configure LBR the same way.
>
> Differently, you mean? Both wanting the same configuration seems fine.
>
No, I meant you can allow LBR + precise_sampling>1 ONLY when
users set LBR to record ALL branches and at the same priv levels. In
other words,
you're exposing the LBR content used by the fixup code.

One could argue, that if LBR is set to filter certain branches, it may
also be okay,
it's just that you won't necessarily get the same number of successful
fixups. The
samples are tagged when fixups were successful, so that may also be an viable
option. Best effort given the content of the LBR. Depending on the
code, that might
be slightly better than dropping to precise_sampling=1 (no fixups).
