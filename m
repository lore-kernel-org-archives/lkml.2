Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab0KOLBz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 06:01:55 -0500
Received: from smtp-out.google.com ([74.125.121.35]:30703 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456Ab0KOLBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 06:01:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=hfek7cSkz+tNSWprKGPkWWuogeVky5g5bvPRYVytTxHD+tfQ1uljcyk2+y6Hl9pIT8
         eGcPnBT7SL8Gw25MqQJw==
MIME-Version: 1.0
In-Reply-To: <1289644367.2084.526.camel@laptop>
References: <1289580941-29744-1-git-send-email-andi@firstfloor.org>
	<1289582630.2084.331.camel@laptop>
	<20101113101148.GB6418@gargoyle.fritz.box>
	<1289644367.2084.526.camel@laptop>
Date: Mon, 15 Nov 2010 12:01:51 +0100
Message-ID: <AANLkTin6rOx_gPkNET3arpx8LFJt_9sZUOBXna=WuFKq@mail.gmail.com>
Subject: Re: [PATCH 1/2] perf-events: Add support for supplementary event
 registers v2
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu, fweisbec@gmail.com,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 13, 2010 at 11:32 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Sat, 2010-11-13 at 11:13 +0100, Andi Kleen wrote:
>> > Hrmm,. this doesn't really scale right wrt multiple extra_regs.
>> >
>> > You made the extra_regs thing fairly extensible, but the above doesn't
>> > really work well if there's multiple extra regs (say OFFCORE and
>> > LBR_CONFIG -- possibly even the two OFFCORE regs present on westmere).
>> >
>> > It basically needs a per-core state for each extra_reg possible.
>>
>> It shouldn't be too hard to extend it to use a table. I didn't want
>> to do that for the first iteration. I guess it could be done as followons
>> once LBR is implemented.
>
> Isn't it also relevant for the two offcore regs for wsm?
>
But that's two distinct events (0xbb and 0xb7), though they behave
exactly the same and have the same set of umasks and extra MSR
values.
