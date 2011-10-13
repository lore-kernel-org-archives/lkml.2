Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab1JMKyt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 06:54:49 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:40423 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134Ab1JMKyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 06:54:47 -0400
X-AuditID: b753bd60-a0885ba000000655-f9-4e96c3741ffe
X-AuditID: b753bd60-a0885ba000000655-f9-4e96c3741ffe
Message-ID: <4E96C36F.6060708@hitachi.com>
Date: Thu, 13 Oct 2011 19:54:39 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        acme@redhat.com, ming.m.lin@intel.com, robert.richter@amd.com,
        ravitillo@lbl.gov
Subject: Re: [PATCH 07/12] perf_events: add LBR software filter support for
 Intel X86
References: <CABPqkBSNejhZ_ciyLTUFAybBqqGB-8QzVrPj8OTbAhQ_+mj4aw@mail.gmail.com> <CABPqkBReqBhFFKsLPfbzFHL7hs2hXSJ8tTZuP9D-2N2MGiB9Mw@mail.gmail.com> <1317984122.31132.6.camel@twins> <CABPqkBTxxS-vuAycDJO-aJNE4EpCLF8xyPtJ1Jzv26f15HJC8A@mail.gmail.com> <1317986519.31132.13.camel@twins> <4E8EE885.9040703@hitachi.com> <20111010060927.GG32173@elte.hu> <4E92FBAD.3000108@hitachi.com> <20111010144538.GZ14482@one.firstfloor.org> <4E943DB4.1070400@hitachi.com> <20111012070601.GC18618@elte.hu>
In-Reply-To: <20111012070601.GC18618@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/10/12 16:06), Ingo Molnar wrote:
> 
> * Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
>> (2011/10/10 23:45), Andi Kleen wrote:
>>>> Ah, nice. Maybe we need another test binary, since current one is
>>>> just ensuring the output of objdump and decoder is same.
>>>> anyway it's not so difficult if it feeds random binaries to
>>>> ensure the decoder doesn't access bad address.
>>>
>>> Pure /dev/urandom is not good because it cannot be ever reproduced.
>>> Better use a PRNG with random seed from urandom, but print the seed.
>>
>> Sure,
> 
> Obviously the urandom data should be kbuild generated and only 
> cleared on 'make clean' - not regenerated on every run. So if there's 
> a failure the failing urandom data stays around readily.

I've added options for passing a combination of seed and seqno
or instruction sequence directly. So if someone find an error
message, they can easily reproduce it or report it.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
