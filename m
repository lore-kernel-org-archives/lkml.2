Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932813Ab1LFA2m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 19:28:42 -0500
Received: from mga11.intel.com ([192.55.52.93]:24244 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932706Ab1LFA2l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 19:28:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,302,1320652800"; 
   d="scan'208";a="92634971"
Subject: Re: [tip:x86/mm] x86/mm: Avoid superflous leave_mm() in the TLB
 flush path
From: Shaohua Li <shaohua.li@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
In-Reply-To: <CA+55aFwMfUduX_5kNKjo=S8ShEBb_OE_D6o-jSMy53Sa0iZHAw@mail.gmail.com>
References: <tip-287de5b2cb365b98190b5de8ace1c5a31768a5ae@git.kernel.org>
	 <CA+55aFwMfUduX_5kNKjo=S8ShEBb_OE_D6o-jSMy53Sa0iZHAw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Dec 2011 08:40:20 +0800
Message-ID: <1323132020.22361.364.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-12-06 at 07:26 +0800, Linus Torvalds wrote:
> On Mon, Dec 5, 2011 at 9:56 AM, tip-bot for Shaohua Li
> <shaohua.li@intel.com> wrote:
> >
> > x86/mm: Avoid superflous leave_mm() in the TLB flush path
> >
> > If just one page VA tlb is required to be flushed and current
> > task is in lazy TLB state, doing leave_mm() is superfluous
> > because it flushes the whole TLB.  This can reduce some TLB
> > miss.
> 
> Are you sure this is a good idea?
> 
> We may be *much* better off leaving the VM and avoiding future IPI's
> than trying to flush pages one by one over and over again.
> 
> IPI's are expensive.
> 
> I don't think you thought this through, and if you *did* think it
> through and actually have numbers that it's cheaper to stay with the
> MM, I think you need to show those numbers.
good point, I didn't think of it. It's unlikely we just flush one tlb
page. please drop the patch.

Thanks,
Shaohua

