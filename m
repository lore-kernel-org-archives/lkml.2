Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758051Ab2IUVDk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 17:03:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:46111 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752407Ab2IUVDi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 17:03:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,464,1344236400"; 
   d="scan'208";a="225231078"
Message-ID: <505CD629.1070402@linux.intel.com>
Date: Fri, 21 Sep 2012 14:03:37 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Kees Cook <keescook@chromium.org>, Linda Wang <lwang@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH 00/11] x86: Supervisor Mode Access Prevention
References: <1348256595-29119-1-git-send-email-hpa@linux.intel.com> <CA+55aFwaZdMxLA1VCfOy9BDQHPp6CTwRFHYGUCXdJ4+KkQoN+g@mail.gmail.com> <20120921200846.GA25679@gmail.com>
In-Reply-To: <20120921200846.GA25679@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2012 01:08 PM, Ingo Molnar wrote:
> 
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
>> On Fri, Sep 21, 2012 at 12:43 PM, H. Peter Anvin <hpa@linux.intel.com> wrote:
>>
>>> Supervisor Mode Access Prevention (SMAP) is a new security 
>>> feature disclosed by Intel in revision 014 of the Intel® 
>>> Architecture Instruction Set Extensions Programming 
>>> Reference:
>>
>> Looks good.
>>
>> Did this find any bugs, btw? We've had a few cases where we 
>> forgot to use the proper user access function, and code just 
>> happened to work because it all boils down to the same thing 
>> and never got any page faults in practice anyway..
> 
> The 4g:4g patch sweeped out most of the historic ones - so what 
> we have are perhaps newer bugs (but those should be pretty rare, 
> most new features are cross-arch).
> 

A while ago I also did a mockup patch which switched %cr3 to
swapper_pg_dir while entering the kernel (basically where the CLAC
instructions go, plus the SYSCALL path; a restore was obviously needed,
too.)  The performance was atrocious, but I didn't remember running into
any problems.

	-hpa

