Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991Ab2F2J0d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 05:26:33 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:40214 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186Ab2F2J03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 05:26:29 -0400
X-AuditID: b753bd60-982efba000000f6c-8b-4fed74c36b0b
X-AuditID: b753bd60-982efba000000f6c-8b-4fed74c36b0b
Message-ID: <4FED74C9.7020906@hitachi.com>
Date: Fri, 29 Jun 2012 18:26:33 +0900
From: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: avi@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        yrl.pp-manager.tt@hitachi.com, mtosatti@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH 18/18] x86: request TLB flush to slave CPU using NMI
References: <20120628060719.19298.43879.stgit@localhost.localdomain> <20120628060853.19298.32233.stgit@localhost.localdomain> <4FEC88A2.5040103@redhat.com>
In-Reply-To: <4FEC88A2.5040103@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/06/29 1:38, Avi Kivity wrote:
> On 06/28/2012 09:08 AM, Tomoki Sekiyama wrote:
>> For slave CPUs, it is inapropriate to request TLB flush using IPI.
>> because the IPI may be sent to a KVM guest when the slave CPU is running
>> the guest with direct interrupt routing.
>>
>> Instead, it registers a TLB flush request in per-cpu bitmask and send a NMI
>> to interrupt execution of the guest. Then, NMI handler will check the
>> requests and handles the requests.
> 
> 
> Currently x86's get_user_pages_fast() depends on TLB flushes being held
> up by local_irq_disable().  With this patch, this is no longer true and
> get_user_pages_fast() can race with page table freeing. There are
> patches from Peter Zijlstra to remove this dependency though. 

Thank you for the information. I will check his patches.

> NMIs are
> still slow and fragile when compared to normal interrupts, so this patch
> is somewhat problematic.

OK, always sending NMIs is actually problematic. I should check the
slave core state and send NMIs only when slave guest is
running and NMI is really needed.

Thanks,
-- 
Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory

