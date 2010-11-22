Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743Ab0KVLI6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 06:08:58 -0500
Received: from smtp-out.google.com ([216.239.44.51]:37688 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366Ab0KVLI5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 06:08:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Gkc9foS9usfWFddMNK7mmqMm8GZfksY3blQPcdOKmSCl7kJkIx57vtxP3F3LTqrLCe
         ZpsiYepVniSZj7n2sKdw==
MIME-Version: 1.0
In-Reply-To: <1288696085.2720.11.camel@localhost>
References: <1288620663.2712.84.camel@localhost>
	<AANLkTimdp1teeaZkn2h32TQjaWxqegp27TNq+rvQcxAF@mail.gmail.com>
	<1288696085.2720.11.camel@localhost>
Date: Mon, 22 Nov 2010 12:08:52 +0100
Message-ID: <AANLkTim_B=srEjwaj_EHgu08GGvgD1CfL0iOj+CAG_=k@mail.gmail.com>
Subject: Re: [PATCH] wrong PERF_COUNT_HW_CACHE_REFERENCES and
 PERF_COUNT_HW_CACHE_MISSES for AMD
From: Stephane Eranian <eranian@google.com>
To: =?UTF-8?Q?Robert_Sch=C3=B6ne?= <robert.schoene@tu-dresden.de>
Cc: Vince Weaver <vweaver1@eecs.utk.edu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
        x86 <x86@kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert,

Has there been any progress on this issue?

On Tue, Nov 2, 2010 at 12:08 PM, Robert Schöne
<robert.schoene@tu-dresden.de> wrote:
>
> >
> Yes, we could use event 4E1 (L3 Cache Misses), but we would need
> different event IDs for the different AMD Families. Not all of them have
> an L3-Cache and even some implementations of Family 10h don't have L3
> either.

I think you could introduce several generic event mapping tables, like what is
done for the various Intel processors, i.e., have variations of the
amd_perfmon_event_map[] table. Then, the kernel would auto-detect the
host CPU and pick the correct table. Same thing would have to be done
for the LL generic cache events if some mappings use Northbridge events.

In general, however, I would recommend not using those generic cache
events to begin with. I think you understand why now. When dealing with
PMU events, you should read the documentation first. Micro-architectures
vary greatly even within the same processor family.
