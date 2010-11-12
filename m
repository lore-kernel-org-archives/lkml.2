Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919Ab0KLKlb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 05:41:31 -0500
Received: from smtp-out.google.com ([216.239.44.51]:60749 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756525Ab0KLKl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 05:41:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=fYgIkhvEwFyzaVaQgFBN1+MvDwgcCrV3CLW+6LBOcmLLBsYs6leLeqYHgxPcbl6DCv
         2i42BWu5tczPr/HvEX2g==
MIME-Version: 1.0
In-Reply-To: <1289507858.2084.195.camel@laptop>
References: <1289492117-18066-1-git-send-email-andi@firstfloor.org>
	<1289492117-18066-2-git-send-email-andi@firstfloor.org>
	<4CDC2DDD.50508@linux.vnet.ibm.com>
	<4CDC3845.4030104@linux.intel.com>
	<4CDC4628.8020109@linux.vnet.ibm.com>
	<20101111194936.GJ18718@basil.fritz.box>
	<1289505587.2084.193.camel@laptop>
	<20101111201259.GL18718@basil.fritz.box>
	<1289507858.2084.195.camel@laptop>
Date: Fri, 12 Nov 2010 11:41:27 +0100
Message-ID: <AANLkTimag1+h4ujWYmWXXBspizL1+j2JtJDf+=AmWpPa@mail.gmail.com>
Subject: Re: [PATCH 2/3] perf: Add support for extra parameters for raw events
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, mingo@elte.hu, acme@redhat.com
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 9:37 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Thu, 2010-11-11 at 21:12 +0100, Andi Kleen wrote:
>> > Also, I think we can use the same mechanism to program the
>> > PEBS-load-latency MSR, right?
>>
>> I haven't looked at that, but if it's a per core resource
>> the infrastructure can be reused at least.
>
> Can't remember if the load-latency msr is per-core, but its an extra reg
> that needs to be set.

Load latency is luckily per thread. Nothing special to do to handle this one.
We can restore its value from attr->config.

>
> The nhm/wsm LBR config msr is per-core though, so that could use your
> infrastructure too.
>
Exactly.
