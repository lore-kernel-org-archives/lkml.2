Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554Ab0JGSye (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 14:54:34 -0400
Received: from mga03.intel.com ([143.182.124.21]:27638 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751207Ab0JGSyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 14:54:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,298,1283756400"; 
   d="scan'208";a="333446353"
Message-ID: <4CAE1767.5040409@intel.com>
Date: Thu, 07 Oct 2010 11:54:31 -0700
From: "H. Peter Anvin" <h.peter.anvin@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "caiqian@redhat.com" <caiqian@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [tip:core/memblock] x86, memblock: Fix crashkernel allocation
References: <4CABAF2A.5090501@kernel.org> <tip-9f4c13964b58608fbce05540743281ea3146c0e8@git.kernel.org> <20101006151449.GA7378@redhat.com> <4CACF531.2060407@intel.com> <20101006224704.GD7378@redhat.com> <4CAD01A9.9050907@intel.com> <20101007181804.GE23308@redhat.com>
In-Reply-To: <20101007181804.GE23308@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2010 11:18 AM, Vivek Goyal wrote:
> 
> Ok, I was browsing through kexec-tools, x86 bzImage code and trying to
> refresh my memory what segments were being loaded and what were memory
> address concerns.
> 
> - relocatable bzImage (max addr 0x37ffffff, 896MB). 
> 	Though I don't know/understand where that 896MB come from.
> 
> - initrd (max addr 0x37ffffff, 896MB)
> 	Don't know why 896MB as upper limit

896 MB is presumably the (default!!) LOWMEM limit on 32 bits.  This is
actually wrong if vmalloc= is also specified on command line, though, or
with nonstandard compile-time options.

> - Purgatory (max addr 2G)
> 
> - A segment to keep elf headers (no limit)
> 	These are accessed when second kernel as fully booted so can be
> 	addressed in higher addresses.
> 
> - A backup segment to copy first 640K of memory (not aware of any limit)
> - Setup/parameter segment (no limit)
> 	- We don't really execute anything here and just access it for
>   	  command line.

Probably has a 4 GB limit, since I believe it only has a 32-bit pointer.

> So atleast for bzImage it looks that if we specify crashkernel=128M<896M, it
> will work.
> 
> So I am fine with above additional syntax for crashkernel=. May be we shall
> have to the deprecate the crashkernel=X<@0 syntax.
> 
> CCing kexec list, in case others have any comments.

It would be easy enough to either deprecate or make it an alias for
crashkernel=...<896M, which is basically what Yinghai's patch does.

	-hpa
