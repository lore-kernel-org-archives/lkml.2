Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980Ab0KUVdx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 16:33:53 -0500
Received: from smtp-out.google.com ([216.239.44.51]:47127 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755657Ab0KUVdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 16:33:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=klp1wYBY5SFA5kPxSGmDZbSFjLIVXqjPG6vS/GWhjnmC7rmjjyNum/UVqHDEd2rPUQ
         GSjWJ6wbMuHk1pRNBT/w==
Date: Sun, 21 Nov 2010 13:33:40 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
cc: Shaohui Zheng <shaohui.zheng@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
        lethal@linux-sh.org, Andi Kleen <ak@linux.intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Haicheng Li <haicheng.li@intel.com>
Subject: Re: [1/8,v3] NUMA Hotplug Emulator: add function to hide memory
 region via e820 table.
In-Reply-To: <20101121140057.GH9099@hack>
Message-ID: <alpine.DEB.2.00.1011211331220.26304@chino.kir.corp.google.com>
References: <20101117020759.016741414@intel.com> <20101117021000.479272928@intel.com> <alpine.DEB.2.00.1011162354390.16875@chino.kir.corp.google.com> <20101118092052.GE2408@shaohui> <alpine.DEB.2.00.1011181313140.26680@chino.kir.corp.google.com>
 <20101119001218.GA3327@shaohui> <alpine.DEB.2.00.1011201642200.10618@chino.kir.corp.google.com> <20101121140057.GH9099@hack>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="531368966-2015248532-1290375225=:26304"
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--531368966-2015248532-1290375225=:26304
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Sun, 21 Nov 2010, Américo Wang wrote:

> >> > > > > Index: linux-hpe4/arch/x86/kernel/e820.c
> >> > > > > ===================================================================
> >> > > > > --- linux-hpe4.orig/arch/x86/kernel/e820.c	2010-11-15 17:13:02.483461667 +0800
> >> > > > > +++ linux-hpe4/arch/x86/kernel/e820.c	2010-11-15 17:13:07.083461581 +0800
> >> > > > > @@ -971,6 +971,7 @@
> >> > > > >  }
> >> > > > >  
> >> > > > >  static int userdef __initdata;
> >> > > > > +static u64 max_mem_size __initdata = ULLONG_MAX;
> >> > > > >  
> >> > > > >  /* "mem=nopentium" disables the 4MB page tables. */
> >> > > > >  static int __init parse_memopt(char *p)
> >> > > > > @@ -989,12 +990,28 @@
> >> > > > >  
> >> > > > >  	userdef = 1;
> >> > > > >  	mem_size = memparse(p, &p);
> >> > > > > -	e820_remove_range(mem_size, ULLONG_MAX - mem_size, E820_RAM, 1);
> >> > > > > +	e820_remove_range(mem_size, max_mem_size - mem_size, E820_RAM, 1);
> >> > > > > +	max_mem_size = mem_size;
> >> > > > >  
> >> > > > >  	return 0;
> >> > > > >  }
> >> > > > 
> >> > > > This needs memmap= support as well, right?
> >> > > we did not do the testing after combine both memmap and numa=hide paramter, 
> >> > > I think that the result should similar with mem=XX, they both remove a memory
> >> > > region from the e820 table.
> >> > > 
> >> > 
> >> > You've modified the parser for mem= but not memmap= so the change needs 
> >> > additional support for the latter.
> >> > 
> >> 
> >> the parser for mem= is not modified, the changed parser is numa=, I add a addtional
> >> option numa=hide=.
> >> 
> >
> >The above hunk is modifying the x86 parser for the mem= parameter.
> >
> 
> That is fine as long as "mem=" is parsed before "numa=".
> 

If you'll read the discussion, I had no problem with modifying the mem 
parser.  I merely suggested that Shaohui modify the memmap parser in the 
same way to save max_mem_size so users can use it as well for the hidden 
nodes, that are now obsolete.  Apparently that was misunderstood by both 
of you although it looks pretty clear above, I dunno.
--531368966-2015248532-1290375225=:26304--
