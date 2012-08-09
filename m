Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031103Ab2HIP3D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 11:29:03 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:40372 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030945Ab2HIP3A convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:16:1>);
	Thu, 9 Aug 2012 11:29:00 -0400
Message-Id: <5023F3580200007800093F2C@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Thu, 09 Aug 2012 16:28:56 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Andi Kleen" <ak@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: "Andy Lutomirski" <luto@amacapital.net>,
        "Robert Richter" <robert.richter@amd.com>,
        "Johannes Weiner" <hannes@cmpxchg.org>,
        "Hugh Dickins" <hughd@google.com>, "Alex Shi" <alex.shu@intel.com>,
        "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>, <x86@kernel.org>,
        <linux-mm@kvack.org>, "Thomas Gleixner" <tglx@linutronix.de>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        <linux-mips@linux-mips.org>, "Tim Chen" <tim.c.chen@linux.intel.com>,
        <linuxppc-dev@lists.ozlabs.org>,
        "Andrea Arcangeli" <aarcange@redhat.com>,
        "Ingo Molnar" <mingo@redhat.com>, "Mel Gorman" <mgorman@suse.de>,
        <linux-kernel@vger.kernel.org>, <linux-sh@vger.kernel.org>,
        <sparclinux@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v2 6/6] x86: switch the 64bit uncached page clear
 to SSE/AVX v2
References: <1344524583-1096-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1344524583-1096-7-git-send-email-kirill.shutemov@linux.intel.com>
In-Reply-To: <1344524583-1096-7-git-send-email-kirill.shutemov@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 09.08.12 at 17:03, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com> wrote:
>  ENTRY(clear_page_nocache)
>  	CFI_STARTPROC
> -	xorl   %eax,%eax
> -	movl   $4096/64,%ecx
> +	push   %rdi
> +	call   kernel_fpu_begin
> +	pop    %rdi

You use CFI annotations elsewhere, so why don't you use
pushq_cfi/popq_cfi here?

Jan

