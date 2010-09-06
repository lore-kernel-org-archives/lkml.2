Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874Ab0IFMO2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 08:14:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55825 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817Ab0IFMO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 08:14:27 -0400
Message-ID: <4C84DB1E.1040503@redhat.com>
Date: Mon, 06 Sep 2010 15:14:22 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Andre Przywara <andre.przywara@amd.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] x86: Fix allowed CPUID bits for KVM guests
References: <1283506069-1096-1-git-send-email-andre.przywara@amd.com> <1283506069-1096-4-git-send-email-andre.przywara@amd.com> <4C8350C5.7050302@redhat.com> <4C84D903.6010104@amd.com>
In-Reply-To: <4C84D903.6010104@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/06/2010 03:05 PM, Andre Przywara wrote:
>
>>
>> Did we really enable "sse5" before xsave?  That looks broken, but I 
>> guess no real harm if xsave itself is not enabled.
> Yes. It somehow slipped through when you introduced the other feature 
> flags to KVM. I also think this is not a serious problem.
> BTW: I realized that AES is currently denied. Reading the manual I see 
> that it operates on SSE registers, so it should be safe to be passed 
> through. The only drawback is that it would change the visible CPUID 
> on CPUs that already have AES, whereas earlier KVM versions did hide it.

This code doesn't directly affect a guest's cpuid, it merely tells host 
userspace which cpuid bits are supported by kvm.  It's perfectly fine to 
add bits as we add support, in fact this interface is what makes 
migration work across cpus with different capabilities.

> This could become a problem with migration. But if you agree, I'd 
> integrate this flag in the v2 series.

Shouldn't be a problem - please do.

-- 
error compiling committee.c: too many arguments to function

