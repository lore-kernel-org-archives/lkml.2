Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760528Ab0JGM7e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 08:59:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752861Ab0JGM7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 08:59:33 -0400
Message-ID: <4CADC3F2.2050506@redhat.com>
Date: Thu, 07 Oct 2010 14:58:26 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        hpa@zytor.com, riel@redhat.com, cl@linux-foundation.org,
        mtosatti@redhat.com
Subject: Re: [PATCH v6 06/12] Add PV MSR to enable asynchronous page faults
 delivery.
References: <1286207794-16120-1-git-send-email-gleb@redhat.com> <1286207794-16120-7-git-send-email-gleb@redhat.com>
In-Reply-To: <1286207794-16120-7-git-send-email-gleb@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 10/04/2010 05:56 PM, Gleb Natapov wrote:
> +
> +	Physical address points to 32 bit memory location that will be written
> +	to by the hypervisor at the time of asynchronous page fault injection to
> +	indicate type of asynchronous page fault. Value of 1 means that the page
> +	referred to by the page fault is not present. Value 2 means that the
> +	page is now available.

"The must not enable interrupts before the reason is read, or it may be 
overwritten by another apf".

Document the fact that disabling interrupts disables APFs.

How does the guest distinguish betweem APFs and ordinary page faults?

What's the role of cr2?

When disabling APF, all pending APFs are flushed and may or may not get 
a completion.

Is a "page available" notification guaranteed to arrive on the same vcpu 
that took the "page not present" fault?

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

