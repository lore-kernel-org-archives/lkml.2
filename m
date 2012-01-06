Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293Ab2AFMY1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 07:24:27 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:57297 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350Ab2AFMY0 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Fri, 6 Jan 2012 07:24:26 -0500
Message-Id: <4F06F640020000780006ACDE@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 06 Jan 2012 12:25:20 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Andi Kleen" <andi@firstfloor.org>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: x86-64: memset()/memcpy() not fully standards compliant
References: <4F05BBFE020000780006A983@nat28.tlf.novell.com>
 <20120105182846.GQ11715@one.firstfloor.org> <4F0630CC.7050001@zytor.com>
 <20120106014748.GS11715@one.firstfloor.org> <4F06566B.8080708@zytor.com>
 <20120106094922.GU11715@one.firstfloor.org>
 <4F06D979020000780006AC49@nat.nue.novell.com>
 <20120106103734.GV11715@one.firstfloor.org>
 <4F06DFEF020000780006AC84@nat28.tlf.novell.com>
 <20120106110845.GW11715@one.firstfloor.org>
In-Reply-To: <20120106110845.GW11715@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 06.01.12 at 12:08, Andi Kleen <andi@firstfloor.org> wrote:
>>  It's not the traditional bootmem implementation anymore, but
>> alloc_bootmem() et al still exist, and still clear the allocated memory
>> (in __alloc_memory_core_early()). So there is a code path that can
>> validly be used (and it is this code path that is presenting one of the
>> problems with the non-pv-ops Xen kernels, as they're using flatmem
>> rather than sparsemem since their physical address space is always
>> fully continuous).
> 
> Yes but there should be no callers that do alloc_bootmem(4G)
> The biggest ones afak are the 1GB pages I added some time ago.
> 
> How is it a problem in the non pv Xen kernels?

pgdat->node_mem_map[] exceeds 4G when total memory goes far
enough beyond 292G. At some later point ->node_page_cgroup[]
also exceeds 4G. Finally, the phys-to-machine mapping (which gets
resized during boot) exceeds 4G when crossing the 2T boundary.

Jan

