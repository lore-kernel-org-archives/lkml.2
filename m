Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161502Ab2JXWxB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 18:53:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34895 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161238Ab2JXWxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 18:53:00 -0400
Message-ID: <508870D4.6010104@zytor.com>
Date: Wed, 24 Oct 2012 15:51:00 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Juri Lelli <juri.lelli@gmail.com>
CC: peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
        rostedt@goodmis.org, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@ericsson.com,
        liming.wang@windriver.com, jkacur@redhat.com,
        harald.gustafsson@ericsson.com, vincent.guittot@linaro.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 02/16] math128, x86_64: Implement {mul,add}_u128 in 64bit
 asm
References: <1351115634-8420-1-git-send-email-juri.lelli@gmail.com> <1351115634-8420-3-git-send-email-juri.lelli@gmail.com> <50886B43.3080001@zytor.com> <50886FFB.8070802@gmail.com>
In-Reply-To: <50886FFB.8070802@gmail.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2012 03:47 PM, Juri Lelli wrote:
>>
>> How could this work since u128 presumably has not yet been defined as a
>> structure?  After all, isn't it the absence of ARCH_HAS_INT128 which
>> makes that happen?
> 
> Sorry, you were not in the Cc list of the previous patch in the patchset,
> so you probably missed that. I should have triple checked git send-email
> Cc list. Sorry about that.
> 
> I'll add you there.
> 

Hmm... you realize that at least on some platform the u128 as a union is
going to perform worse than the plain __int128, right?  As such IMO it
would be better if the union was only defined if needed.

	-hpa

