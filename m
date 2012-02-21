Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998Ab2BUCOr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 21:14:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39633 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752292Ab2BUCOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 21:14:46 -0500
Message-ID: <4F42FE08.5020309@zytor.com>
Date: Mon, 20 Feb 2012 18:14:32 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Josh Boyer <jwboyer@gmail.com>, Jongman Heo <jongman.heo@samsung.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] i387: support lazy restore of FPU state
References: <alpine.LFD.2.02.1202191412060.3898@i5.linux-foundation.org> <alpine.LFD.2.02.1202201145130.4237@i5.linux-foundation.org> <alpine.LFD.2.02.1202201146450.4237@i5.linux-foundation.org> <alpine.LFD.2.02.1202201147350.4237@i5.linux-foundation.org> <alpine.LFD.2.02.1202201148100.4237@i5.linux-foundation.org> <CA+5PVA5Zkka6Q2kcvWbvA3xr9=5TZ+VWWsWzYcRQ1GpccpJHew@mail.gmail.com> <CA+55aFyqz-2ejsRpbRdYx7UHDBg3q=9nvmtrj2nLeuZonrkz1A@mail.gmail.com>
In-Reply-To: <CA+55aFyqz-2ejsRpbRdYx7UHDBg3q=9nvmtrj2nLeuZonrkz1A@mail.gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2012 06:10 PM, Linus Torvalds wrote:
> On Mon, Feb 20, 2012 at 5:50 PM, Josh Boyer <jwboyer@gmail.com> wrote:
>>
>> I haven't tried really figuring this out yet, but building the Fedora kernel
>> on x86_64 with your latest tree results in:
>>
>> ERROR: "fpu_owner_task" [lib/raid6/raid6_pq.ko] undefined!
> 
> Ugh. My dislike of modules on my machines strikes again, and
> apparently nobody else tested the patches I sent out.
> 
> The attached trivial patch fixes it, I bet.
> 
> Although I do wonder if we should just make kernel_fpu_begin() be a
> real function instead of inlining it. I'm not sure it makes sense to
> inline that thing, and it might be better to export that one instead.
> Comments?
> 

I would agree with that.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

