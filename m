Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932746Ab1C3QTL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 12:19:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33606 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755049Ab1C3QTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 12:19:07 -0400
Message-ID: <4D935774.302@kernel.org>
Date: Wed, 30 Mar 2011 09:16:52 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH tip:x86/mm 1/3] x86: A fast way to check capabilities
 of the current cpu
References: <20110312115010.GC2005@htj.dyndns.org> <m2k4g1zdmt.fsf@firstfloor.org> <4D93531F.5080403@zytor.com>
In-Reply-To: <4D93531F.5080403@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2011 08:58 AM, H. Peter Anvin wrote:
> On 03/14/2011 12:49 PM, Andi Kleen wrote:
>> Tejun Heo <tj@kernel.org> writes:
>>
>>> Add this_cpu_has() which determines if the current cpu has a certain
>>> ability using a segment prefix and a bit test operation.
>>
>>
>> Hmm: if the CPU capability is really tested in a performance critical
>> path, wouldn't it even be better to just use static_branch() now? 
>>
> 
> We have static_cpu_has() for this specific purpose (it actually predates
> static_branch()).
> 

Note that static_cpu_has() has two caveats:

1. Before alternatives patching, it will always be false.
2. It is the equivalent of boot_cpu_has(), i.e. the intersection of all
the CPU feature sets (available at boot time, obviously.)

	-hpa
