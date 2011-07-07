Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798Ab1GGABT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 20:01:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54822 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754139Ab1GGABS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 20:01:18 -0400
Message-ID: <4E14F73A.30408@zytor.com>
Date: Wed, 06 Jul 2011 17:00:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: Pekka Enberg <penberg@kernel.org>, Ian Campbell <ian.campbell@citrix.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Brian Gerst <brgerst@gmail.com>, Jan Beulich <JBeulich@novell.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/3] x86: drop unnecessary kernel_eflags variable from
 64 bit.
References: <20110705111525.GR17941@sun> <1309870814-14181-1-git-send-email-ian.campbell@citrix.com> <CAOJsxLFjdrrnx4gZjDJQuf3GBHeKvKb91TajYBkMu+PgSWtM5A@mail.gmail.com> <20110706231711.GA11595@tassilo.jf.intel.com>
In-Reply-To: <20110706231711.GA11595@tassilo.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/2011 04:17 PM, Andi Kleen wrote:
>> Well lets ask Linus and Andi?
> 
> The original idea was that if someone extends EFLAGS with new bits
> the BIOS could set them.  Strictly said the Intel Manual 
> specifies that ("reserved bits -- always set to values previously read")
>  
> But that never really worked out and I don't think anyone
> would dare extending it now.  So hardcoding is fine I guess.
> 

We already clear any undefined flags almost as soon as we enter the
kernel... and quite rightly so, because there are BIOSes which leave
random crap in the flags.

It is very different from what an *application* should do in this case,
however.

	-hpa
