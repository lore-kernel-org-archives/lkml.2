Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933192Ab2IUWML (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 18:12:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:62097 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757001Ab2IUWMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 18:12:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,464,1344236400"; 
   d="scan'208";a="225258478"
Message-ID: <505CE638.1030405@linux.intel.com>
Date: Fri, 21 Sep 2012 15:12:08 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Linda Wang <lwang@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH 00/11] x86: Supervisor Mode Access Prevention
References: <1348256595-29119-1-git-send-email-hpa@linux.intel.com> <877grnows4.fsf@xmission.com>
In-Reply-To: <877grnows4.fsf@xmission.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2012 03:07 PM, Eric W. Biederman wrote:
> 
> Have you tested kexec in this environment?
> 
> This is the kind of cpu feature that when we enable it, frequently we
> have to do something on the kexec path.
> 
> At a quick skim it looks like the kexec path is using kernel page table
> entries and clearing all bits from cr4 except X86_CR4_PAE so I don't
> actually expect this change will require anything on the kexec path.
> 

I have not, no, but as you quite correctly point out that shouldn't
affect things.

We should also change the kernel to start clean with CR4 -- the purpose
of CR4 is to indicate which CPU features the OS is opting into.

I think we do on x86-64 but not on x86-32 at the moment.

This is an unrelated problem, though, and can be addressed later.

	-hpa
