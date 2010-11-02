Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197Ab0KBOIX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 10:08:23 -0400
Received: from smtp-out.google.com ([74.125.121.35]:32566 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055Ab0KBOIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 10:08:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=COkON9GU7hGkHGUGJoNLKtOwUsRtrKkUCaplvnl/0ZiCqnJPMJ6D8NoY7lXSVp57XS
         TXjW/VuSZfIMPuYrX4BA==
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1011011857220.9616@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1010302101240.1572@swampdragon.chaosbits.net>
	<1288634113.2039.20.camel@laptop>
	<alpine.LNX.2.00.1011011857220.9616@swampdragon.chaosbits.net>
Date: Tue, 2 Nov 2010 15:08:13 +0100
Message-ID: <AANLkTinvNSBP+tx3eCW3Xsq1Y_PwndrK5J4xHwWsUtBb@mail.gmail.com>
Subject: Re: [PATCH] Perf, AMD: Prefer kzalloc() over kmalloc()+memset() in amd_alloc_nb()
From: Stephane Eranian <eranian@google.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "robert.richter" <robert.richter@amd.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <bp@amd64.org>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 1, 2010 at 6:57 PM, Jesper Juhl <jj@chaosbits.net> wrote:
> On Mon, 1 Nov 2010, Peter Zijlstra wrote:
>
>> On Sat, 2010-10-30 at 21:06 +0200, Jesper Juhl wrote:
>> > Hi,
>> >
>> > I believe this would be an improvement?
>> >
>> > Prefer kzalloc() over kmalloc()+memset() in amd_alloc_nb().
>> >
>> >
>> > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
>> > ---
>>
>>
>> I've changed it to..
>>
>> ---
>> Subject: perf, amd: Use kmalloc_node(,__GFP_ZERO) for northbridge structure allocation
>> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
>> Date: Mon Nov 01 18:52:05 CET 2010
>>
>> Jasper suggested we use the zeroing capability of the allocators
>> instead of calling memset ourselves. Add node affinity while we're at
>> it.
>>
>> Reported-by: Jesper Juhl <jj@chaosbits.net>
>> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>
> Fine by me.
>
Works for me.

Acked-by: Stephane Eranian <eranian@google.com>
