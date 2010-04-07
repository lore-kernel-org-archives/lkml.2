Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932928Ab0DGQsZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 12:48:25 -0400
Received: from smtp-out.google.com ([216.239.44.51]:34691 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756387Ab0DGQsY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 12:48:24 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=bC3ipEnQknwFKpxqIp9ez2y6zy6DciqDKrXiF4Zvh0WrJ6+fIGpeWyGFeZwvYZVBS
	ZPfSO4h2FWKuCZOG7iTRg==
MIME-Version: 1.0
In-Reply-To: <1270646127.20295.976.camel@laptop>
References: <4bbc7fcf.100db80a.6b9f.fffffb14@mx.google.com>
	 <1270646127.20295.976.camel@laptop>
Date: Wed, 7 Apr 2010 18:48:19 +0200
Message-ID: <l2kbd4cb8901004070948zcc0fd6dcv8eb2431edd271c4e@mail.gmail.com>
Subject: Re: [PATCH] perf_events: add PERF_SAMPLE_BRANCH_STACK
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       davem@davemloft.net, fweisbec@gmail.com, robert.richter@amd.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 7, 2010 at 3:15 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2010-04-07 at 14:45 +0200, Stephane Eranian wrote:
>>         LBR is configured by default to record ALL taken branches.  On some
>>         processors, it is possible to filter the type of branches. This will
>>         be supported in a subsequent patch.
>>
>>         On other processors, the sample type is allowed but will generate a
>>         sample where nr=0 as is the case with other sampling types.
>
> Right, so I already posted a patch like that:
>  http://lkml.org/lkml/2010/3/4/160
>
> and the reason its not merged is because there is no perf use-case for
> it. Ingo wants to avoid merging ABI bits for which there is no userspace
> around. We already have a few such things and we find that its too easy
> to regress on those part.
>
Then, why didn't you extend perf to leverage your patch?

I think that forcing all features to be included in perf in not a very
attractive approach. It can't be the only approach. There are many usage
models of PMU data. You want to encourage the development of as
many tools and libraries as possible. It helps with validation too. There are
bugs in your implementation which are not exposed simply because perf
does not need the features. But that does not mean those features are
not useful.

To encourage developers, you need to build simple examples of how
each feature can be used. You don't necessarily need a fully featured
tool. This is what I am doing with libpfm4. People can learn from the
examples and built their own custom tools and libraries.

If I post a patch to enable LBR sampling, it is because I have a user level
test program to validate it and demonstrate what you can get out.

LBR data typically has lots of post-processing. It is best suited for offline
processing. You could use perf to collect the data and dump a binary
output file. I can take a look at that.

I also assume that the same reason is holding up my randomization
patch. yet I think this is an important feature.
