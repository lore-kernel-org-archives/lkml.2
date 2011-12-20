Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242Ab1LTKUp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 05:20:45 -0500
Received: from mx2.parallels.com ([64.131.90.16]:34791 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752053Ab1LTKUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 05:20:38 -0500
Message-ID: <4EF0614A.9020402@parallels.com>
Date: Tue, 20 Dec 2011 14:19:54 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Martin Schwidefsky <schwidefsky@de.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: manual merge of the tip tree with the cputime tree
References: <20111219154010.c2044c038a6174dd8fb6f477@canb.auug.org.au>  <20111219080813.GB30432@elte.hu> <20111219101134.3c2c0db5@de.ibm.com>  <20111219103513.GA17928@elte.hu> <20111219133151.4d14af80@de.ibm.com> <1324303723.24621.1.camel@twins>
In-Reply-To: <1324303723.24621.1.camel@twins>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2011 06:08 PM, Peter Zijlstra wrote:
> On Mon, 2011-12-19 at 13:31 +0100, Martin Schwidefsky wrote:
>> Just one question: are you sure that you want the cpustat array
>> to be u64 instead of cputime64_t? The content of the cpustat array is defined
>> by the architecture semantics of cputime64_t, for CONFIG_VIRT_CPU_ACCOUNTING=y
>> this is not a jiffy counter. If the array is u64 we won't get the sparse
>> checking when reading from cpustat.
>
> So as Glauber said the reason was that we wanted to use simply
> operators, and IIRC he wanted to add a few fields that had to be u64.
>
> I'm not sure what the current plans are wrt adding more fields, but with
> your work cputime_t should again be a simple type and thus regular math
> operators should work again, right?
>
> Glauber, do you still need to add fields?

Due to the current state of discussions of cpu vs cpuacct, I think the 
final state of this is quite unclear. However, I think Martin's work is
a quite worthwhile piece for us to have. So last case we can add extra 
fields in a different array and tell them apart by the index, etc. It 
shouldn't be expensive at all.


