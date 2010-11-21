Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab0KUN5u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 08:57:50 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55396 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200Ab0KUN5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 08:57:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Uw5SPZGuFZNjqUGvKgZoZO4JG8RWdFKbZU5gZUJtEb+gue1Hh2FMms5RVWVAnZYSqu
         9WRO0bqjWS9B80XT8tcwfSqEBn6+QKa5ZXb0HZFyL11/y4tgxquDLxlIj0xWliwmofkW
         hH7/z0Sf9H96iIBptech1yFV//eEdnxA7FjAE=
Date: Sun, 21 Nov 2010 22:00:57 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Shaohui Zheng <shaohui.zheng@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
        lethal@linux-sh.org, Andi Kleen <ak@linux.intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Haicheng Li <haicheng.li@intel.com>
Subject: Re: [1/8,v3] NUMA Hotplug Emulator: add function to hide memory
	region via e820 table.
Message-ID: <20101121140057.GH9099@hack>
References: <20101117020759.016741414@intel.com> <20101117021000.479272928@intel.com> <alpine.DEB.2.00.1011162354390.16875@chino.kir.corp.google.com> <20101118092052.GE2408@shaohui> <alpine.DEB.2.00.1011181313140.26680@chino.kir.corp.google.com> <20101119001218.GA3327@shaohui> <alpine.DEB.2.00.1011201642200.10618@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1011201642200.10618@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 20, 2010 at 04:45:06PM -0800, David Rientjes wrote:
>On Fri, 19 Nov 2010, Shaohui Zheng wrote:
>
>> > > > > Index: linux-hpe4/arch/x86/kernel/e820.c
>> > > > > ===================================================================
>> > > > > --- linux-hpe4.orig/arch/x86/kernel/e820.c	2010-11-15 17:13:02.483461667 +0800
>> > > > > +++ linux-hpe4/arch/x86/kernel/e820.c	2010-11-15 17:13:07.083461581 +0800
>> > > > > @@ -971,6 +971,7 @@
>> > > > >  }
>> > > > >  
>> > > > >  static int userdef __initdata;
>> > > > > +static u64 max_mem_size __initdata = ULLONG_MAX;
>> > > > >  
>> > > > >  /* "mem=nopentium" disables the 4MB page tables. */
>> > > > >  static int __init parse_memopt(char *p)
>> > > > > @@ -989,12 +990,28 @@
>> > > > >  
>> > > > >  	userdef = 1;
>> > > > >  	mem_size = memparse(p, &p);
>> > > > > -	e820_remove_range(mem_size, ULLONG_MAX - mem_size, E820_RAM, 1);
>> > > > > +	e820_remove_range(mem_size, max_mem_size - mem_size, E820_RAM, 1);
>> > > > > +	max_mem_size = mem_size;
>> > > > >  
>> > > > >  	return 0;
>> > > > >  }
>> > > > 
>> > > > This needs memmap= support as well, right?
>> > > we did not do the testing after combine both memmap and numa=hide paramter, 
>> > > I think that the result should similar with mem=XX, they both remove a memory
>> > > region from the e820 table.
>> > > 
>> > 
>> > You've modified the parser for mem= but not memmap= so the change needs 
>> > additional support for the latter.
>> > 
>> 
>> the parser for mem= is not modified, the changed parser is numa=, I add a addtional
>> option numa=hide=.
>> 
>
>The above hunk is modifying the x86 parser for the mem= parameter.
>

That is fine as long as "mem=" is parsed before "numa=".

I think "mem=" should always be parsed before "numa=" no matter what
order they are specified in cmdline, since we need know how much total
memory we have at first.

Thanks.
