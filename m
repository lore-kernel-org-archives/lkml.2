Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222Ab2FMPrS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 11:47:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53872 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754107Ab2FMPrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 11:47:16 -0400
Message-ID: <4FD8B5DB.9080209@zytor.com>
Date: Wed, 13 Jun 2012 08:46:35 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Borislav Petkov <bp@amd64.org>, Stephane Eranian <eranian@google.com>,
        linux-kernel@vger.kernel.org, andi@firstfloor.org, mingo@elte.hu,
        ming.m.lin@intel.com, "Yu, Fenghua" <fenghua.yu@intel.com>
Subject: Re: [PATCH] perf/x86: check ucode before disabling PEBS on SandyBridge
References: <20120607071531.GA4849@quad> <4FD78BE6.4060207@zytor.com>   <20120612190720.GA11137@aftab.osrc.amd.com>   <1339529614.31548.104.camel@twins>   <20120612194900.GC11137@aftab.osrc.amd.com> <4FD7A687.3040500@zytor.com>   <20120612203730.GE11137@aftab.osrc.amd.com> <4FD7A99F.8030007@zytor.com>   <20120612205609.GF11137@aftab.osrc.amd.com> <4FD7AD6F.6010008@zytor.com>  <1339576681.31548.116.camel@twins> <4FD89D09.6010800@zytor.com> <1339601872.8980.52.camel@twins>
In-Reply-To: <1339601872.8980.52.camel@twins>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2012 08:37 AM, Peter Zijlstra wrote:
>>
>> perf might, but I have seen such frankensystems in the field and they
>> work (although I haven't seen that particular combo, I have to admit.)
> 
> Thing is, if we boot on the wsm, perf could fault the system with
> nonexistent MSR accesses, if we boot on the nhm worst is wrong numbers I
> think.
> 
> I'm not really inclined to 'fix' this.. the best I'm willing to accept
> is a patch that would detect this situation and simply disable all
> hardware perf support for the platform.
> 

BIOS is *supposed* to pick the least capable CPU as the BSP.  BIOS
being, well, BIOS is known to not always do that, but on the other hand
it is apparently common enough that at least *some* BIOSes are known to
pay attention and do so.

Anyway, I'm not suggesting we should go out of our way to make perf work
on these systems.  Most likely, as you point out, it is either "just
going to work" or totally fail.

What I don't want to see is creating a new facility and encouraging
people to use it, when it is known to be in error.  I'm trying to find
out at the moment just where the practical cutoff is.

	-hpa
