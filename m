Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758068Ab1I2Xds (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 19:33:48 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:57210 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755614Ab1I2Xdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 19:33:47 -0400
Message-ID: <4E850056.1090101@gmail.com>
Date: Thu, 29 Sep 2011 17:33:42 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Jiri Olsa <jolsa@redhat.com>, a.p.zijlstra@chello.nl, mingo@elte.hu,
        paulus@samba.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: Exit recording if events have non matching
 sample type
References: <20110929230613.GA20083@ghostprotocols.net>
In-Reply-To: <20110929230613.GA20083@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 09/29/2011 05:06 PM, Arnaldo Carvalho de Melo wrote:
>> >From what I can see sample_type has to be the same for all samples:
>> https://lkml.org/lkml/2011/8/15/6
> 
> We could add a PERF_SAMPLE_ID2 that if present would be guaranteed to be
> the last, or we can, as PeterZ prefers/suggests, to use one mmap per
> sample id, then we know that if we're getting it on that mmap, it has
> that sample_type.
> 
> For record that means we need to dump each per-sample_id mmap onto a
> separate file, i.e. use a directory, etc.

That seems like a major re-write of perf. Why not keep the existing
restriction and have users who want different sample_types run multiple
perf commands?

What's to be gained by refactoring the code to support multiple
sample_types in a single command invocation?

David
