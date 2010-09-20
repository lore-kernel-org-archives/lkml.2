Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757140Ab0ITSW1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 14:22:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37364 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756794Ab0ITSWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 14:22:25 -0400
Message-ID: <4C97A5EF.4070100@zytor.com>
Date: Mon, 20 Sep 2010 11:20:31 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Thunderbird/3.1.3
MIME-Version: 1.0
To: Venkatesh Pallipadi <venki@google.com>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org, asit.k.mallick@intel.com,
        arjan@linux.kernel.org, a.p.zijlstra@chello.hl, lenb@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/idle] x86, hotplug: Move WBINVD back outside the play_dead
 loop
References: <tip-ea53069231f9317062910d6e772cca4ce93de8c8@git.kernel.org>	<tip-a68e5c94f7d3dd64fef34dd5d97e365cae4bb42a@git.kernel.org> <AANLkTimCXZWVb7ajANPg15Zuo22nst=d5p-MjXhzu1NX@mail.gmail.com>
In-Reply-To: <AANLkTimCXZWVb7ajANPg15Zuo22nst=d5p-MjXhzu1NX@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2010 05:48 PM, Venkatesh Pallipadi wrote:
>>
>> +       wbinvd();
>> +
>>        while (1) {
>> -               mb();
>> -               wbinvd();
>>                __monitor(&current_thread_info()->flags, 0, 0);
>>                mb();
> 
> 
> Just one observation. There are some CPUs with errata that need
> clflush before monitor. So, if that CPU wakesup spuriously it may have
> problem reentering idle. Not sure whether that will be a problem as
> that errata also depended on read happening on the flag. May be its
> better to do monitor (0, 0, 0).
> 

It seems the easy way to deal with that would be to just add clflush
before monitor... it is *probably* redundant, but it should be safe to
do. It means depending on X86_FEATURE_CLFLUSH as well as
X86_FEATURE_MWAIT, but I don't think there is any x86 processor which
has MWAIT and not CLFLUSH, and I highly doubt there ever will be.

Does anyone see any downside?

	-hpa
