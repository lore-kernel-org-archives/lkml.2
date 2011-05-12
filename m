Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757009Ab1ELJyP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 05:54:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755580Ab1ELJyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 05:54:13 -0400
Message-ID: <4DCBAE34.2000203@redhat.com>
Date: Thu, 12 May 2011 12:53:56 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH v1 0/5] KVM in-guest performance monitoring
References: <1305129333-7456-1-git-send-email-avi@redhat.com> <20110512093309.GD8707@8bytes.org> <4DCBACC7.8080000@siemens.com>
In-Reply-To: <4DCBACC7.8080000@siemens.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2011 12:47 PM, Jan Kiszka wrote:
> >
> >  Anyway, I thought about a paravirt-approach instead of implementing a
> >  real PMU... But there are certainly good reasons for both.
>
> Paravirt is taking away the pressure from CPU vendors to do their virt
> extensions properly - and doesn't help with unmodifiable OSes.

Yes.  In the case of the PMU things are less clear, since they are very 
model specific.  In the case of Linux, you have to lie to the guest and 
present a model number that it doesn't recognize, otherwise it prefers 
the model-specific PMU to the architectural PMU.

I though of adding a kvm cpuid bit that says "prefer the architectural 
pmu" to work around this issue.

-- 
error compiling committee.c: too many arguments to function

