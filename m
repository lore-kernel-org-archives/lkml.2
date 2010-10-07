Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab0JGSAt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 14:00:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34348 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309Ab0JGSAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 14:00:47 -0400
Date: Thu, 7 Oct 2010 19:59:43 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        hpa@zytor.com, riel@redhat.com, cl@linux-foundation.org,
        mtosatti@redhat.com
Subject: Re: [PATCH v6 06/12] Add PV MSR to enable asynchronous page faults
 delivery.
Message-ID: <20101007175943.GH2397@redhat.com>
References: <1286207794-16120-1-git-send-email-gleb@redhat.com>
 <1286207794-16120-7-git-send-email-gleb@redhat.com>
 <4CADC3F2.2050506@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CADC3F2.2050506@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 07, 2010 at 02:58:26PM +0200, Avi Kivity wrote:
>  On 10/04/2010 05:56 PM, Gleb Natapov wrote:
> >+
> >+	Physical address points to 32 bit memory location that will be written
> >+	to by the hypervisor at the time of asynchronous page fault injection to
> >+	indicate type of asynchronous page fault. Value of 1 means that the page
> >+	referred to by the page fault is not present. Value 2 means that the
> >+	page is now available.
> 
> "The must not enable interrupts before the reason is read, or it may
> be overwritten by another apf".
> 
> Document the fact that disabling interrupts disables APFs.
> 
> How does the guest distinguish betweem APFs and ordinary page faults?
> 
> What's the role of cr2?
> 
> When disabling APF, all pending APFs are flushed and may or may not
> get a completion.
> 
> Is a "page available" notification guaranteed to arrive on the same
> vcpu that took the "page not present" fault?
> 
You mean documentation is lacking? :)

--
			Gleb.
