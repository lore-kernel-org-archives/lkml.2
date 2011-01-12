Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864Ab1ALRRH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 12:17:07 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49798 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673Ab1ALRRF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 12:17:05 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1101121145430.24532@xanadu.home>
References: <20110111015409.18291.87166.stgit@localhost6.localdomain6>
 <20110111104051.GA11039@n2100.arm.linux.org.uk> <20110111153630.GB2707@angua.secretlab.ca>
 <20110111154833.GF11039@n2100.arm.linux.org.uk> <AANLkTi=29LB66j123ufMHQk=46hGYdmR4nZZQFnN=Tku@mail.gmail.com>
 <20110112155215.GB11039@n2100.arm.linux.org.uk> <AANLkTinwGd9pa7YQ=5hXfarw=MB=YdpBuN7xJAd+Ps4f@mail.gmail.com>
 <alpine.LFD.2.00.1101121145430.24532@xanadu.home>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 12 Jan 2011 10:16:44 -0700
X-Google-Sender-Auth: DFtZma-i8QFRZ19Rm69nK_nYkac
Message-ID: <AANLkTinPibTVUu2zoMbDYnSWXGvB6dVjCp54DoN9S1p3@mail.gmail.com>
Subject: Re: [RFC] arm: Defer lookup of machine_type and vet of atags to setup.c
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 12, 2011 at 9:53 AM, Nicolas Pitre <nico@fluxnic.net> wrote:
> On Wed, 12 Jan 2011, Grant Likely wrote:
>
>> Actually it looks like the real problem is that the mmu has been
>> turned on, but the virtual mappings for devices have not yet been
>> established, and so the debug macros aren't using a valid address.
>
> A temporary virtual mapping should be there -- look for addruart in
> head.S.

Hi Russell and Nicolas,

Oops, yes all the early debug stuff works fine.  Stupid human trick on
my end, but I've sorted it out now.  Thanks for the help.  I'll have
patches to post later today.

g.

>
>> I'm using printk to get output into the ring buffer in my patch to
>> rework lookup_machine_type() in C, and that does indeed output to the
>> ring buffer, but the kernel cannot spit stuff out the serial port.
>>
>> It looks like I'd need to get past paging_init() in order to get
>> ll_debug working between turning on the mmu and paging_init(), but
>> paging_init() needs the mdesc pointer, and the whole point of the
>> error message is that the mdesc pointer is unknown!  I don't see any
>> code that sets up a debug mapping of the uart before paging_init time.
>
> See above.
>
>>  I could try to implement something like that, but it is looking to be
>> more complicated than it is worth when the current code works just
>> fine.
>
> My bet is that there is a bug with the current code that you are
> exposing.
>
>> Let me know if I've missed something, but I think I should drop the
>> removal of __lookup_machine_type from head.S from my patch.
>
> It's not the location of that code which is a problem.  Even if you
> leave that code in place, you want to call it later and I bet that the
> display would be broken even if __lookup_machine_type doesn't move.
>
>
> Nicolas
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
