Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167Ab2AJMnY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 07:43:24 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:62899 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754377Ab2AJMnW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 07:43:22 -0500
MIME-Version: 1.0
X-Originating-IP: [212.179.42.66]
In-Reply-To: <op.v7tsxgu33l0zgt@mpn-glaptop>
References: <1326040026-7285-8-git-send-email-gilad@benyossef.com>
	<alpine.DEB.2.00.1201091034390.31395@router.home>
	<op.v7tsxgu33l0zgt@mpn-glaptop>
Date: Tue, 10 Jan 2012 14:43:21 +0200
Message-ID: <CAOtvUMcJgnGf+RbF6J5zPxi3x4sCt7qoWe+Xd6C8GOhJV=xhqQ@mail.gmail.com>
Subject: Re: [PATCH v6 7/8] mm: only IPI CPUs to drain local pages if they exist
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org,
        Chris Metcalf <cmetcalf@tilera.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Avi Kivity <avi@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/9 Michal Nazarewicz <mina86@mina86.com>:
> On Mon, 09 Jan 2012 17:35:26 +0100, Christoph Lameter <cl@linux.com> wrote:
>
>> On Sun, 8 Jan 2012, Gilad Ben-Yossef wrote:
>>
>>> @@ -67,6 +67,14 @@ DEFINE_PER_CPU(int, numa_node);
>>>  EXPORT_PER_CPU_SYMBOL(numa_node);
>>>  #endif
>>>
>>> +/*
>>> + * A global cpumask of CPUs with per-cpu pages that gets
>>> + * recomputed on each drain. We use a global cpumask
>>> + * here to avoid allocation on direct reclaim code path
>>> + * for CONFIG_CPUMASK_OFFSTACK=y
>>> + */
>>> +static cpumask_var_t cpus_with_pcps;
>>
>>
>> Move the static definition into drain_all_pages()?
>
>
> This is initialised in setup_per_cpu_pageset() so it needs to be file
> scoped.

Yes. The cpumask_var_t abstraction is convenient and all but it does
make the allocation
very non obvious when it does not happen in proximity to the variable
use - it doesn't *look* like
a pointer. "syntactic sugar causes cancer of the semicolon" and all that.

Gilad



-- 
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"Unfortunately, cache misses are an equal opportunity pain provider."
-- Mike Galbraith, LKML
