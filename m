Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783Ab0HQF6W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 01:58:22 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63196 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750976Ab0HQF6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 01:58:21 -0400
Message-ID: <4C6A2618.2050403@cn.fujitsu.com>
Date: Tue, 17 Aug 2010 14:03:04 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Don Zickus <dzickus@redhat.com>
Subject: Re: [PATCH] lockup_detector: Make DETECT_HUNT_TASK default depend
 on LOCKUP_DETECTOR
References: <4C58C7FF.5060906@cn.fujitsu.com> <20100806005801.GB5436@nowhere> <20100807070135.GC23108@elte.hu> <20100808195839.GA5387@nowhere>
In-Reply-To: <20100808195839.GA5387@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Just came back from vacation)

>> Maybe a better change would be to make it more generally available - right now 
>> it's:
>>
>>  config LOCKUP_DETECTOR
>>          bool "Detect Hard and Soft Lockups"
>>          depends on DEBUG_KERNEL && !S390
>>
>> which means that it cannot be enabled when DEBUG_KERNEL is off.
>>
>> So i think we should:
>>
>>  - Remove the s390 hack and add an ARCH_HAS_LOCKUP_DETECTOR flag
> 
> If we do this, we'll need to add this config on every archs but s390.
> We should better have ARCH_WANT_NO_LOCKUP_DETECTOR. I know that
> "negative" meaning configs suck, but otherwise we would lose this
> support on many archs.
> 
> Why s390 doesn't want the softlockup detector to begin with?
> 
>>  - Remove the DEBUG_KERNEL dependency
> 
> Yeah.
> 

Seems we haven't come to an agreement yet? I don't know much about the
lockup detector code, so please take care of this. :)

