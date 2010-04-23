Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758594Ab0DWSGr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 14:06:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44428 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758468Ab0DWSGp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 14:06:45 -0400
Message-ID: <4BD1E197.6000508@zytor.com>
Date: Fri, 23 Apr 2010 11:06:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: mingo@elte.hu, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, Frank Arnold <frank.arnold@amd.com>
Subject: Re: [PATCH -v2 0/5] AMD L3 cache index disable fixes for .35
References: <1271945222-5283-1-git-send-email-bp@amd64.org> <4BD0E869.10402@zytor.com> <20100423065016.GA11748@aftab> <20100423140927.GA13750@aftab>
In-Reply-To: <20100423140927.GA13750@aftab>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2010 07:09 AM, Borislav Petkov wrote:
> 
> Ok, looking at the k8.o object it is 507 bytes so I don't think
> compiling it in would hurt embedded people too much:
> 
>    text    data     bss     dec     hex filename
>     379     104      24     507     1fb arch/x86/kernel/k8.o
> 
> So how about the following? It should apply cleanly on top and it
> survived a bunch of randconfigs here so far.
> 

I have to say I think that's pretty ridiculous for someone who cares so
much about size that they have disabled CONFIG_PCI that they can just
add another half-kilobyte of code that is going to do absolutely
nothing.  Think about the kind of x86 CPUs that could even consider
disabling CONFIG_PCI -- we're talking pretty deep embedded by now.

So, no, I don't think this is an option.  Force-enabling CONFIG_PCI on
x86 would be a more realistic option, and I honestly don't know how many
people would object to that, but not right now.

The obvious answer instead is to augment the list of stubs in
<asm/k8.h>.  In particular, move num_k8_northbridges into the #ifdef and
just #define num_k8_northbridges 0 in the other clause.

	-hpa


