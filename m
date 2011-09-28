Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973Ab1I1Se1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 14:34:27 -0400
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:21187
	"EHLO AM1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753420Ab1I1Se0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 14:34:26 -0400
X-SpamScore: -15
X-BigFish: VPS-15(zzbb2dK936eK1432N98dKzz1202hzzz2fh668h839h93fh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPVD:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4E83687D.1070507@am.sony.com>
Date: Wed, 28 Sep 2011 11:33:33 -0700
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "Rowand, Frank" <Frank_Rowand@sonyusa.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PREEMPT_RT_FULL: arm coredump fails for cpu >= 4
References: <4E828E35.6070801@am.sony.com> <1317214993.24040.16.camel@twins>
In-Reply-To: <1317214993.24040.16.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/11 06:03, Peter Zijlstra wrote:
> On Tue, 2011-09-27 at 20:02 -0700, Frank Rowand wrote:
>>
>> ARM can not use SPLIT_PTLOCK_CPUS if PREEMPT_RT_FULL because
>> vectors_user_mapping() creates a VM_ALWAYSDUMP mapping of the vector page,
>> but no ptl->lock has been allocated for the page.  An attempt to coredump
>> that page will result in a kernel NULL pointer dereference when
>> follow_page() attempts to lock the page.
> 
> 
>>
>> This patch is needed only if mm-shrink-the-page-frame-to-rt-size.patch is
>> applied. 
> 
> Yeah, vile hackery that is.. why isn't pgtable_page_ctor() called on
> those pages?

Yep, that is the question.  I started fixing that yesterday, but realized
I was going about it the wrong way, so I sent a first version of the
patch that simply avoids the problem.

I'll be looking at whether I can fix it cleanly.

> 
> Not that I care too much about split_pte_lock on ARM, they're mostly all
> tiny machines anyway so the gain is marginal, but it would be good to
> find out why the pgtable constructor isn't called properly.
> 


