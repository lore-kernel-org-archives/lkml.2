Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390Ab0ETAmi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 20:42:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40644 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854Ab0ETAmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 20:42:37 -0400
Message-ID: <4BF48569.7080203@zytor.com>
Date: Wed, 19 May 2010 17:42:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Eric Dumazet <eric.dumazet@gmail.com>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com,
       tglx@linutronix.de, avi@redhat.com, linux-tip-commits@vger.kernel.org
Subject: Re: Does anyone care about gcc 3.x support for x86 anymore?
References: <1273135546-29690-2-git-send-email-avi@redhat.com>	 <tip-a3c8acd04376d604370dcb6cd2143c9c14078a50@git.kernel.org>	 <1274213443.2485.3.camel@edumazet-laptop>  <4BF2FF26.9050701@zytor.com> <1274217067.2485.9.camel@edumazet-laptop> <4BF308E9.4040809@zytor.com> <4BF46FFE.1080903@redhat.com>
In-Reply-To: <4BF46FFE.1080903@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2010 04:10 PM, Mauro Carvalho Chehab wrote:
> 
> However, if the problems are just performance/dead code removal, I would 
> just add a big warning if someone tries to compile x86 with it. I don't 
> like very much the idea of having different minimum gcc requirements 
> for each architecture, except if gcc is producing a broken code. 
> 

I should clarify the problem.  The problems we have seen are related to
constant propagation, which causes gcc3 to die when there is an assembly
constraint like:

	asm("..." : : "i" (foo));

... since "foo" isn't constant as far as it is concerned.  We can put in
workarounds, but it's real effort to keep it alive that probably isn't
well spent.

Similarly, lack of constant propagation can cause code that should have
been compile-time removed to still be there, causing link failures.

	-hpa
