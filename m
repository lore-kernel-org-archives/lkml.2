Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513Ab1JJOFx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 10:05:53 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:59461 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319Ab1JJOFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 10:05:52 -0400
X-AuditID: b753bd60-9e4a1ba000005c89-5d-4e92fbbd4fab
X-AuditID: b753bd60-9e4a1ba000005c89-5d-4e92fbbd4fab
Message-ID: <4E92FBAD.3000108@hitachi.com>
Date: Mon, 10 Oct 2011 23:05:33 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        acme@redhat.com, ming.m.lin@intel.com, robert.richter@amd.com,
        ravitillo@lbl.gov
Subject: Re: [PATCH 07/12] perf_events: add LBR software filter support for
 Intel X86
References: <1317912555-9559-1-git-send-email-eranian@google.com> <1317912555-9559-8-git-send-email-eranian@google.com> <20111006153229.GJ14482@one.firstfloor.org> <CABPqkBSNejhZ_ciyLTUFAybBqqGB-8QzVrPj8OTbAhQ_+mj4aw@mail.gmail.com> <CABPqkBReqBhFFKsLPfbzFHL7hs2hXSJ8tTZuP9D-2N2MGiB9Mw@mail.gmail.com> <1317984122.31132.6.camel@twins> <CABPqkBTxxS-vuAycDJO-aJNE4EpCLF8xyPtJ1Jzv26f15HJC8A@mail.gmail.com> <1317986519.31132.13.camel@twins> <4E8EE885.9040703@hitachi.com> <20111010060927.GG32173@elte.hu>
In-Reply-To: <20111010060927.GG32173@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/10/10 15:09), Ingo Molnar wrote:
> 
> * Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
>> (2011/10/07 20:21), Peter Zijlstra wrote:
>>> On Fri, 2011-10-07 at 13:18 +0200, Peter Zijlstra wrote:
>>>>> Yeah, depending on the depth of the LBR. But then what happens, you
>>>>> decode an instruction that is not what was executed. 
>>>>
>>>> Right, and Andi's concern is that this might cause our instruction
>>>> decoder to blow up, or worse. 
>>>
>>> That is, we have a fair confidence that its capable of correctly
>>> decoding correct streams, but I understood from Masami that they haven't
>>> actually tried feeding it crap.
>>
>> OK, I'll do hardening it.
> 
> Yes, that's a good idea. Could you perhaps add it to the existing 
> build time sanity test we do for the instruction decoder, to feed it 
> a sequence of /dev/urandom input or such?

Ah, nice. Maybe we need another test binary, since current one is
just ensuring the output of objdump and decoder is same.
anyway it's not so difficult if it feeds random binaries to
ensure the decoder doesn't access bad address.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
