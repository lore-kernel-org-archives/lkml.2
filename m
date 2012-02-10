Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850Ab2BJPVV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 10:21:21 -0500
Received: from 2605ds1-ynoe.0.fullrate.dk ([90.184.12.24]:33992 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904Ab2BJPVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 10:21:20 -0500
Message-ID: <4F3535E7.4000007@krogh.cc>
Date: Fri, 10 Feb 2012 16:21:11 +0100
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, jk@novozymes.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
        herrmann.der.user@googlemail.com
Subject: Re: Memory issues with Opteron 6220
References: <20120208143741.GB28486@otto.nzcorp.net> <20120209083315.GA19380@elte.hu> <4F343582.7080007@krogh.cc>
In-Reply-To: <4F343582.7080007@krogh.cc>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Long story short, this is a red herring.

The system we migrated the configuration from had
vm.overcommit_memory => 2, so then the new
one got that too. (50% actual memory + swap)

That worked fine.. We set it back in 2008 due to the
heuristic version not doing the correct thing. What
has happened over the years is that the memory grow
and swap/memory ration has gone smaller, both due
to memory growth and swap being more and more irellevant.

So the new system was set up with reduced swap 8GB vs. 100GB
which mean that the algorithm used by overcommit_memory
ended up not allowing more than: 64GB+8GB of memory being
used (less than physical memory).. The system migrated from would
by this rule allow 64+100GB, this fitting quite ok.

I guess it took so long to realize, since something with "overcommit"
isn't what springs into mind when you dont think you're even
close to be there, combined with the mis-leading power-saving issue
that just confused the problem.

I would admit that we could have saved a significant of time/fustration
if dmesg had revealed a message that it was the overcommit limits being
hit and thus knocking off the processes.

Another change to suggest would be to not kill off processes due
to overcommit at least before actual memory size had been reached.

But, long story short, system misconfiguration..

-- 
Jesper
