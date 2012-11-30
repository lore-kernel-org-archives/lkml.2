Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932864Ab2K3TwR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 14:52:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36384 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932197Ab2K3TwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 14:52:16 -0500
Message-ID: <50B90E4D.8010604@zytor.com>
Date: Fri, 30 Nov 2012 11:51:41 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Vincent Palatin <vpalatin@chromium.org>, Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        the arch/x86 maintainers <x86@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        Duncan Laurie <dlaurie@chromium.org>,
        Olof Johansson <olofj@chromium.org>
Subject: Re: [PATCH] x86, fpu: avoid FPU lazy restore after suspend
References: <1354301523-5252-1-git-send-email-vpalatin@chromium.org> <1354301523-5252-2-git-send-email-vpalatin@chromium.org> <CA+55aFz4M4GmQbUkD1dhTkLTYka4H+T_phrsXgx+eGe8g9iLYA@mail.gmail.com> <50B90B31.3000907@zytor.com> <CA+55aFyoAq+w6eNAyOJ00cpFEaGE=eKzMMtr9kEtMuUU820oYg@mail.gmail.com>
In-Reply-To: <CA+55aFyoAq+w6eNAyOJ00cpFEaGE=eKzMMtr9kEtMuUU820oYg@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2012 11:41 AM, Linus Torvalds wrote:
>>
>> Hmm... from my point of view it would almost seem saner to do this on
>> the way *up*... as part of CPU (re-)initialization.  After all, the
>> "nothing is currently running on this CPU" is part of the initial state
>> of the CPU, regardless of if we have ever been online before or not.
> 
> That works for me too, and has the similar advantage of being easier
> to think about than "the cpu is actually still being used, and we're
> playing tricks with the FPU state cache" approach.
> 
> Regardless, much credit to Vincent (and presumably others on the
> chromium team) for finding and debugging this.
> 

OK, how do you want to handle this, given that 3.7 is presumably
imminent?  We can apply Vincent's patch now, and then restructure it
later, or we can go for the gold now, but replicating the testing
Vincent has done will probably take well into next week.

	-hpa


