Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780Ab2LMDnT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 22:43:19 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43930 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab2LMDnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 22:43:18 -0500
Message-ID: <50C94ECD.6020504@gmail.com>
Date: Wed, 12 Dec 2012 20:43:09 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] perf changes for v3.8
References: <20121211090910.GA22985@gmail.com> <CA+55aFw=sifEKVJwDvmfV317+RNrf9Z88xZ5pu0SwggrQrubTw@mail.gmail.com> <50C94A9C.2050900@gmail.com> <CA+55aFxpLJ=gVUSiu04sTzDDrR75B89pzE35MyEyj3pVi5UbiQ@mail.gmail.com>
In-Reply-To: <CA+55aFxpLJ=gVUSiu04sTzDDrR75B89pzE35MyEyj3pVi5UbiQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/12 8:34 PM, Linus Torvalds wrote:
> On Wed, Dec 12, 2012 at 7:25 PM, David Ahern <dsahern@gmail.com> wrote:
>>
>> Are you running an older perf binary on the 3.8 kernel?
>
> I am.. I don't tend to rebuild 'perf'..
>
>> Does this work: perf record -e cycles:ppH  ...
>
> Yes it does. What is 'H' and why should anybody care? Especially since
> I'm not running virtualized.
>
> That whole "exclude_guest" test is insane when there isn't any
> virtualization going on. Very annoying.

you know what's worse? All of your VMs blowing up because anyone runs 
perf with precise attribute. Virtualization and and performance 
monitoring collide. From the log message for commit 1342798.

"Intel PEBS in VT-x context uses the DS address as a guest linear 
address, even though its programmed by the host as a host linear 
address. This either results in guest memory corruption and or the 
hardware faulting and 'crashing' the virtual machine.  Therefore we have 
to disable PEBS on VT-x enter and re-enable on VT-x exit, enforcing a 
strict exclude_guest."

David

