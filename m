Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107Ab2DBP2e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 11:28:34 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:21417
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751825Ab2DBP2d convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 11:28:33 -0400
X-SpamScore: -10
X-BigFish: VPS-10(zz9371I1432N98dKzz1202hzz8275bh8275dhz2dh668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M1UYZE-01-DGC-02
X-M-MSG: 
From: "Chen, Dennis (SRDC SW)" <Dennis1.Chen@amd.com>
To: Ingo Molnar <mingo@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>
Subject: RE: semaphore and mutex in current Linux kernel (3.2.2)
Thread-Topic: semaphore and mutex in current Linux kernel (3.2.2)
Thread-Index: Ac0P7b5dm37XnMCsR726LS+rxvQKd///odaA//25DYA=
Date: Mon, 2 Apr 2012 15:28:23 +0000
Message-ID: <491D6B4EAD0A714894D8AD22F4BDE0439F9560@SCYBEXDAG02.amd.com>
References: <491D6B4EAD0A714894D8AD22F4BDE0439F94AB@SCYBEXDAG02.amd.com>
 <20120401121943.GA11893@gmail.com>
In-Reply-To: <20120401121943.GA11893@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.74.102]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 1, 2012 at 8:19 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Chen, Dennis (SRDC SW) <Dennis1.Chen@amd.com> wrote:
>
>> Documentation/mutex-design.txt:
>>
>> "- 'struct mutex' is smaller on most architectures: E.g. on x86,
>>    'struct semaphore' is 20 bytes, 'struct mutex' is 16 bytes.
>>    A smaller structure size means less RAM footprint, and better
>>    CPU-cache utilization."
>> ================================================================
>>
>> Now in my x86-64 32-bit Linux environment, 'struct semaphone'
>> is 16 bytes, 'struct mutex' is 20 bytes. So seems the RAM
>> footprint advantages are not there...
>
> It got larger due to the adaptive spin-mutex performance
> optimization.
>

Thanks Ingo, so part of the document is obsolete and "less RAM footprint" and "tighter code"
is not advantage of mutex anymore, being the disadvantage factor. Spin-mutex performance optimization
is highly expected...   

>> For the performance advantages followed, I don't have the
>> ./test-mutex and maybe the testing environment, so haven't the
>> 1st hand data for this item...
>
> Well, a way to reproduce that would be to find a lock_mutex
> intense workload ('perf top -g', etc.), and then changing back
> the underlying mutex to a semaphore, and measure the performance
> of the two primitives.
>
Why not the 'test-mutex' tool in the document? 
I guess it should be the private tool from you, if you can share it to me then I can help to make
a new round performance check of the two primitives in the latest kernel... make a deal?  
 

