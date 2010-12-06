Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658Ab0LFQKw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 11:10:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12554 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120Ab0LFQKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 11:10:51 -0500
Message-ID: <4CFD0B06.9010308@redhat.com>
Date: Mon, 06 Dec 2010 18:10:46 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: SVM: Add xsetbv intercept
References: <1291394523-7689-1-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1291394523-7689-1-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2010 06:42 PM, Joerg Roedel wrote:
> This patch implements the xsetbv intercept to the AMD part
> of KVM. This makes AVX usable in a save way for the guest on
> AVX capable AMD hardware.
> The patch is tested by using AVX in the guest and host in
> parallel and checking for data corruption. I also used the
> KVM xsave unit-tests and they all pass.
>

That is really strange.  You didn't need to do anything to get cpuid.avx 
recognized.  So running an older kvm on newer hardware will happily 
expose avx even though it's not supported.

We screwed up - we should have made cpuid.avx dependent on vendor support.

The patch itself looks fine, I just want to understand this point first.

-- 
error compiling committee.c: too many arguments to function

