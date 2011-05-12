Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757Ab1ELJsQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 05:48:16 -0400
Received: from thoth.sbs.de ([192.35.17.2]:16338 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751567Ab1ELJsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 05:48:14 -0400
Message-ID: <4DCBACC7.8080000@siemens.com>
Date: Thu, 12 May 2011 11:47:51 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH v1 0/5] KVM in-guest performance monitoring
References: <1305129333-7456-1-git-send-email-avi@redhat.com> <20110512093309.GD8707@8bytes.org>
In-Reply-To: <20110512093309.GD8707@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-05-12 11:33, Joerg Roedel wrote:
> On Wed, May 11, 2011 at 11:55:28AM -0400, Avi Kivity wrote:
>> This not-for-merging patchset exposes an emulated version 1 architectural
>> performance monitoring unit to KVM guests.  The PMU is emulated using
>> perf_events, so the host kernel can multiplex host-wide, host-user, and the
>> guest on available resources.
>>
>> Caveats:
>> - counters that have PMI (interrupt) enabled stop counting after the
>>   interrupt is signalled.  This is because we need one-shot samples
>>   that keep counting, which perf doesn't support yet
>> - some combinations of INV and CMASK are not supported
>> - counters keep on counting in the host as well as the guest
>> - the RDPMC instruction and CR4.PCE bit are not yet emulated
>> - there is likely a bug in the implementation; running 'perf top' in
>>   a guest that spends 80% of its time in userspace shows perf itself
>>   as consuming almost all cpu
>>
>> perf maintainers: please consider the first three patches for merging (the
>> first two make sense even without the rest).  If you're familiar with the Intel
>> PMU, please review patch 5 as well - it effectively undoes all your work
>> of abstracting the PMU into perf_events by unabstracting perf_events into what
>> is hoped is a very similar PMU.
> 
> Gaah, I was just about to submit a talk about PMU virtualization for KVM
> Forum :)
> 
> Anyway, I thought about a paravirt-approach instead of implementing a
> real PMU... But there are certainly good reasons for both.

Paravirt is taking away the pressure from CPU vendors to do their virt
extensions properly - and doesn't help with unmodifiable OSes.

Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
