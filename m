Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757735Ab1DHTV3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 15:21:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4876 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757680Ab1DHTV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 15:21:27 -0400
Date: Fri, 8 Apr 2011 21:20:39 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
        mtosatti@redhat.com, kvm@vger.kernel.org, joro@8bytes.org,
        penberg@cs.helsinki.fi, asias.hejun@gmail.com, gorcunov@gmail.com
Subject: Re: [ANNOUNCE] Native Linux KVM tool
Message-ID: <20110408192039.GJ29444@random.random>
References: <1301592656.586.15.camel@jaguar>
 <4D982E89.8070502@redhat.com>
 <BANLkTinbCAUqaKfmKaj-7GXTh9F2if0x+Q@mail.gmail.com>
 <4D9847BC.9060906@redhat.com>
 <4D98716D.9040307@codemonkey.ws>
 <4D9873CD.3080207@redhat.com>
 <20110406093333.GB6465@elte.hu>
 <4D9E6F6E.9050709@codemonkey.ws>
 <BANLkTimEwAuL4PM9vBfogkrua-Z44AZQvg@mail.gmail.com>
 <4D9F150B.1030809@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D9F150B.1030809@codemonkey.ws>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anthony,

On Fri, Apr 08, 2011 at 09:00:43AM -0500, Anthony Liguori wrote:
> An example is ioport_ops.  This maps directly to 
> ioport_{read,write}_table in QEMU.  Then you use ioport__register() to 
> register entries in this table similar register_ioport_{read,write}() in 
> QEMU.
> 
> The use of a struct is a small improvement but the fundamental design is 
> flawed because it models a view of hardware where all devices are 
> directly connected to the CPU.  This is not how hardware works at all.

Not sure if I've the whole picture on this but I see no answer to your
email and I found your remark above the most interesting. This is
because I thought the whole point of a native kvm tool was to go all
the paravirt way to provide max performance and maybe also depend on
vhost as much as possible.

I mean if we have to care to emulate hardware _again_ and end up
replicating qemu (with the only exception of TCG) I don't see an need
of an alternative userland, let's not understimate how qemu is already
mature and good to emulate real hardware. I thought the whole point
was to exactly avoid any complaint like "this is not how the hardware
works" and focus only to optimize for smp and max scalability and
ignore how a real hardware would actually work to get there faster
than qemu can.

I had no time to read/try it yet I'm just reading the thread here...

Thanks,
Andrea
