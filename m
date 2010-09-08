Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788Ab0IHN7P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 09:59:15 -0400
Received: from smtp-out.google.com ([216.239.44.51]:25247 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580Ab0IHN7O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 09:59:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tD5KL/myi2G7vRBbDSXaf+VjQBXA1nUuntDswGJC2fVdyesQSgiwz01tyRPrzY3XyI
         vhbdycqV/zGBGRgyOXVA==
MIME-Version: 1.0
In-Reply-To: <1283954221.23762.25.camel@laptop>
References: <4c8793a9.cde7d80a.3bb6.0290@mx.google.com>
	<1283953967.23762.22.camel@laptop>
	<AANLkTikcJ3X0q8SXb55NbrFRd5GUVEXGzbePGUtxF+Wf@mail.gmail.com>
	<1283954221.23762.25.camel@laptop>
Date: Wed, 8 Sep 2010 15:59:11 +0200
Message-ID: <AANLkTimZYnfHUHoXC6ncCVDaugHZZ0YNQdjvsOpOwxiY@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] perf_events: add support for per-cpu per-cgroup
 monitoring (v2)
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: eranian@gmail.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
        paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
        perfmon2-devel@lists.sf.net, robert.richter@amd.com, acme@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 8, 2010 at 3:57 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2010-09-08 at 15:56 +0200, stephane eranian wrote:
>> On Wed, Sep 8, 2010 at 3:52 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Wed, 2010-09-08 at 15:30 +0200, Stephane Eranian wrote:
>> >> +       } times[NR_CPUS] ____cacheline_aligned_in_smp;
>> >
>> > That's fail! NR_CPUS can be like 4k for distro configs.
>> >
>> How do you do this on struct that are dynamically allocated?
>> The number of css is dynamic.
>
> alloc_percpu()?
>
Ok, I will look into this. Thanks.
Clearly we can kmalloc() the array. But it would be nicer to have one
struct allocated per-cpu (avoid the cacheline_aligned_in_smp stuff).
