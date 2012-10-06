Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550Ab2JFS4V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 14:56:21 -0400
Received: from mga02.intel.com ([134.134.136.20]:2962 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699Ab2JFS4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 14:56:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,545,1344236400"; 
   d="scan'208";a="202476995"
Message-ID: <50707ECD.2070300@zytor.com>
Date: Sat, 06 Oct 2012 11:56:13 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Alexander Duyck <alexander.h.duyck@intel.com>, konrad.wilk@oracle.com,
        tglx@linutronix.de, mingo@redhat.com, rob@landley.net,
        akpm@linux-foundation.org, joerg.roedel@amd.com, bhelgaas@google.com,
        shuahkhan@gmail.com, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, x86@kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [RFC PATCH 0/7] Improve swiotlb performance by using physical
 addresses
References: <20121004002113.5016.66913.stgit@gitlad.jf.intel.com> <m28vbkx3hw.fsf@firstfloor.org> <506F3670.4020202@intel.com> <20121005200245.GQ16230@one.firstfloor.org> <506F6BF2.8030500@intel.com> <20121006175751.GS16230@one.firstfloor.org>
In-Reply-To: <20121006175751.GS16230@one.firstfloor.org>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2012 10:57 AM, Andi Kleen wrote:
> 
> Maybe it's just me, but that's somehow sad for one if() and a su
> btraction
> 
> BTW __pa used to be a simple subtraction, the if () was just added to
> handle the few call sites for x86-64 that do __pa(&text_symbol).
> Maybe we should just go back to the old __pa_symbol() for those cases,
> then __pa could be the simple subtraction it used to was again
> and it could be inlined and everyone would be happy.
> 

I wonder how much the double-mapping actually buys us, if we could get a
PIE-type memory model that doesn't try to create GOT references.

We would unambiguously lose out the cases where we currently can do
symbol(index) but I wonder how much the impact actually is.

The advantage would be that it would give us way more room to do kernel
space ASR.

	-hpa


