Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab2BUCMI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 21:12:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39621 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752292Ab2BUCMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 21:12:06 -0500
Message-ID: <4F42FD69.2090800@zytor.com>
Date: Mon, 20 Feb 2012 18:11:53 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Josh Boyer <jwboyer@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] i387: support lazy restore of FPU state
References: <alpine.LFD.2.02.1202191412060.3898@i5.linux-foundation.org> <alpine.LFD.2.02.1202201145130.4237@i5.linux-foundation.org> <alpine.LFD.2.02.1202201146450.4237@i5.linux-foundation.org> <alpine.LFD.2.02.1202201147350.4237@i5.linux-foundation.org> <alpine.LFD.2.02.1202201148100.4237@i5.linux-foundation.org> <CA+5PVA5Zkka6Q2kcvWbvA3xr9=5TZ+VWWsWzYcRQ1GpccpJHew@mail.gmail.com>
In-Reply-To: <CA+5PVA5Zkka6Q2kcvWbvA3xr9=5TZ+VWWsWzYcRQ1GpccpJHew@mail.gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2012 05:50 PM, Josh Boyer wrote:
> 
> I haven't tried really figuring this out yet, but building the Fedora kernel
> on x86_64 with your latest tree results in:
> 
> ERROR: "fpu_owner_task" [lib/raid6/raid6_pq.ko] undefined!
> ERROR: "fpu_owner_task" [arch/x86/kvm/kvm.ko] undefined!
> ERROR: "fpu_owner_task" [arch/x86/crypto/sha1-ssse3.ko] undefined!
> ERROR: "fpu_owner_task" [arch/x86/crypto/serpent-sse2-x86_64.ko] undefined!
> ERROR: "fpu_owner_task" [arch/x86/crypto/ghash-clmulni-intel.ko] undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2
> + exit 1
> 
> Since this patch went in as 7e16838d94b566a1, I'm guessing it's at least
> related.
> 
> I'm building again with more verbose output but I thought I'd send this out
> quickly.
> 

fpu_owner_task needs an EXPORT_SYMBOL_GPL().

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

