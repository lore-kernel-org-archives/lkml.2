Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085Ab0CWVjk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 17:39:40 -0400
Received: from smtp-out.google.com ([74.125.121.35]:49686 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466Ab0CWVjj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 17:39:39 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=NmA6S2hQGPLHNEy/lf3NoRwbuSrvjwhjPCBKKzLZOmC1Do0UQvGTxh+sInrvB/p9O
	ARXfD0Y7YSjhsqIZGHjwQ==
MIME-Version: 1.0
In-Reply-To: <1269366087.5109.143.camel@twins>
References: <4ba8f988.9804cc0a.4b1f.5d77@mx.google.com>
	 <1269366087.5109.143.camel@twins>
Date: Tue, 23 Mar 2010 22:39:34 +0100
Message-ID: <bd4cb8901003231439k117271d4v89ef2e1139307437@mail.gmail.com>
Subject: Re: [PATCH] perf_events: fix remapped count support
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

On Tue, Mar 23, 2010 at 6:41 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2010-03-23 at 18:25 +0200, Stephane Eranian wrote:
>>         This patch fixes the remapped counter support such that it now works
>>         on X86 processors.
>
> (could you please not add all this whitespace in front? and make sure
>  it's no wider than 70 chars)
>
I will fix that.

> Also, I wouldn't say it fixes it, it's currently not broken, its plain
> not implemented. So this patch adds support for rdpmc.
>
There you go, then.

>>         For other architectures, e.g., PPC, SPARC, assuming they do offer the ability
>>         to read counts directly from user space, all that is needed is a couple of new
>>         arch specific functions:
>
> Power already supports this, so if you just broke this Paul is going to
> be unhappy.
>
I certainly changed the content of hdr->offset. But I don't see how
PPC could have this working otherwise in the presence of multiplex
and thus when you need the timing information to scale.

I'll wait for Paul's comments, then.
