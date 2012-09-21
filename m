Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757985Ab2IUT6G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 15:58:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50807 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757660Ab2IUT6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 15:58:04 -0400
Message-ID: <505CC6B8.5000605@zytor.com>
Date: Fri, 21 Sep 2012 12:57:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "H. Peter Anvin" <hpa@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Kees Cook <keescook@chromium.org>, Linda Wang <lwang@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH 00/11] x86: Supervisor Mode Access Prevention
References: <1348256595-29119-1-git-send-email-hpa@linux.intel.com> <CA+55aFwaZdMxLA1VCfOy9BDQHPp6CTwRFHYGUCXdJ4+KkQoN+g@mail.gmail.com>
In-Reply-To: <CA+55aFwaZdMxLA1VCfOy9BDQHPp6CTwRFHYGUCXdJ4+KkQoN+g@mail.gmail.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2012 12:54 PM, Linus Torvalds wrote:
> On Fri, Sep 21, 2012 at 12:43 PM, H. Peter Anvin <hpa@linux.intel.com> wrote:
>> Supervisor Mode Access Prevention (SMAP) is a new security feature
>> disclosed by Intel in revision 014 of the Intel® Architecture
>> Instruction Set Extensions Programming Reference:
> 
> Looks good.
> 
> Did this find any bugs, btw? We've had a few cases where we forgot to
> use the proper user access function, and code just happened to work
> because it all boils down to the same thing and never got any page
> faults in practice anyway..
> 
> I'd obviously hope that we have caught all of them, but.. IOW, has
> SMAP actually triggered for anybody in testing inside Intel?
> 

So far, it caught the use of PAGE_READONLY instead of PAGE_KERNEL_RO for
the WP test on 32 bits (patch 02/11).

It has not had very high testing bandwidth yet, and especially the
exposure of driver code has been very limited, so I would not be at all
surprised if more crop up.

	-hpa
