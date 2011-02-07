Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372Ab1BGRW1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 12:22:27 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:32907 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587Ab1BGRW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 12:22:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=GBQXQZsyYzfBtVHpN6NSug46KRttNVvsMVlpIaggICCkgaeyFySFN/P2P8q/B81Xnp
         bxaafj4bIEx2eeBG/Qu/stkshpXlIM46ywbNOlE3cUYZC1NPO4eEnIlgIITLqbMuTWAA
         qtg90hf8HYy/PYFpSCUrGWwrLRyk1zues0cDk=
Message-ID: <4D502A4D.1040301@gmail.com>
Date: Mon, 07 Feb 2011 20:22:21 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, George Spelvin <linux@horizon.com>,
        Meelis Roos <mroos@linux.ee>, Lin Ming <ming.m.lin@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        lkml <linux-kernel@vger.kernel.org>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [PATCH] perf, x86: P4 PMU -- Fix unflagged overflows test
References: <AANLkTin5gCnhVos3Lu_0GZSxFQmvsNEYTO=Jq7UdmYb1@mail.gmail.com> <20110204165944.GB21209@redhat.com> <4D4EF4BC.6040206@gmail.com>
In-Reply-To: <4D4EF4BC.6040206@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2011 10:21 PM, Cyrill Gorcunov wrote:
> On 02/04/2011 07:59 PM, Don Zickus wrote:
>> On Fri, Feb 04, 2011 at 03:17:28PM +0300, Cyrill Gorcunov wrote:
>>> Please apply it, sorry for non-inlined patch (have a web access only at moment).
>>>
>>> Note that I've tested the patch on non-HT machine so if someone have HT'ed one
>>> -- it would be great to test the patch there.
>>
>> Hmm. For some reason, when I enable the kgdb testsuite, the box fails to
>> boot with hardlockup issues.  It seems like the code is swallowing the
>> NMIs? I basically applied this patch on top of 2.6.38-rc3 and ran it on my
>> Xeon box (p4 w/HT).
>>
>> Cheers,
>> Don
> 
>   Don, I hope to get access to p4 machine tomorrow and investigate this issue
> (didn't manage to read kgdb code this weekend). Sorry for delay.
> 

  Just for info -- I've tested the patch on p4 machine with kgdb bootup tests
and results are somehow strange. If I disable nmi-watchdog the tests passes
fine and i'm able to run perf top (or anything related). Same time if I leave
nmi-watchdog enabled by default the borrowed event reported, kgdb tests passes
but nmi-watchdog never fires (ie I see nmi irq counter remains zero). So I've added
debug prints and found that counter reaches positive values and didn't issues
nmi at all. All in one -- i'm still investigating this issue unfortunatelly
the kernel build procedure sometime takes hours on this machine (even with
ccache enabled) so it goes a way slower then I expected :(
-- 
    Cyrill
