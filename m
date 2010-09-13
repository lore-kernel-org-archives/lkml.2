Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045Ab0IMPUT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 11:20:19 -0400
Received: from smtp-out.google.com ([74.125.121.35]:59325 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107Ab0IMPUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 11:20:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=nGns9A7DoiG4N+dwW1BbtVuAgq8ihLiaK9SSJk6Td01HklIH4bHV6uIjk3IWoSg95X
         TVvTDFFthlB05iY0Yfvg==
MIME-Version: 1.0
In-Reply-To: <1284391000.2275.338.camel@laptop>
References: <4c8e3c0c.12d1d80a.73d9.ffffcf21@mx.google.com>
	<20100913150914.GA6155@nowhere>
	<AANLkTi=OR69sDbUMkSnx_-bpF=yHF_xNY1v=-BJgLpp5@mail.gmail.com>
	<1284391000.2275.338.camel@laptop>
Date: Mon, 13 Sep 2010 17:20:12 +0200
Message-ID: <AANLkTin35TXPcs9u3pLfo8QRUmGnftT1DPfswRUVEvJW@mail.gmail.com>
Subject: Re: [PATCH] perf_events: improve DS/BTS/PEBS buffer allocation
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
        davem@davemloft.net, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        robert.richter@amd.com, markus.t.metzger@intel.com
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 5:16 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2010-09-13 at 17:13 +0200, Stephane Eranian wrote:
>> > For now I think you can not do this. vmalloc'ed memory can't be safely
>> > accessed from NMIs in x86 because that might fault. And faults from NMIs
>> > are not supported. They cause very bad things: return from fault calls
>> > iret which reenables NMI, so NMI can nest but in the meantime there is
>> > only one NMI stack, so that gets quickly messed up.
>> >
>> What kind of faults are you talking about here? TLB faults?
>
> Page faults. vmalloc pte setup is lazy.
>
Is there a way to not do lazy?

I guess we could do alloc_pages_nodes() if we make sure the
buffer size can be expressed as a page order and not just a page size,
or we are willing to waste memory.

That is the case we the sizes you have chosen today. For DS, we
could round up to one page for now.
