Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758138Ab0IUT12 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 15:27:28 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63220 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757200Ab0IUT11 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 15:27:27 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1009211826240.2416@localhost6.localdomain6>
References: <20100910060151.6613e9c3@debxo> <20100910172538.GC11284@angua.secretlab.ca>
 <20100910181458.GA7243@elte.hu> <20100910182135.GG11284@angua.secretlab.ca>
 <20100920190604.5a2118da@debxo> <alpine.LFD.2.00.1009211144070.2416@localhost6.localdomain6>
 <20100921091136.45f5f7fa@debxo> <alpine.LFD.2.00.1009211826240.2416@localhost6.localdomain6>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 21 Sep 2010 16:27:07 -0300
X-Google-Sender-Auth: _-Xw29ra99wr6HrzDqUDAhDU7fI
Message-ID: <AANLkTikmnzi_3EihiOMJS+tvHFTnb0uu=L-ZmUPZnFDB@mail.gmail.com>
Subject: Re: [PATCH 2/2] x86: of: define irq functions to allow drivers/of/*
 to build on x86
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andres Salomon <dilinger@queued.net>, Ingo Molnar <mingo@elte.hu>,
        devicetree-discuss@lists.ozlabs.org, x86@kernel.org, mingo@redhat.com,
        hpa@zytor.com, Mitch Bradley <wmb@laptop.org>,
        linux-kernel@vger.kernel.org,
        Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 21, 2010 at 1:27 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Tue, 21 Sep 2010, Andres Salomon wrote:
>> On Tue, 21 Sep 2010 11:45:37 +0200 (CEST)
>> Thomas Gleixner <tglx@linutronix.de> wrote:
>>
>> > > Any additional comments (ACKs, NACKs, etc) on the patches?  If I
>> > > need to rework it (or them), I can certainly make the patch
>> > > description longer.
>> >
>> > Fine with me, but you could make the "mapping" function an inline as
>> > well. While at it, some sensible changelog would be helpful :)
>> >
>> > Thanks,
>> >
>> >     tglx
>>
>> Hm, inlining it would require some additional x86 #ifdefs in
>> include/linux/of_irq.h (where the mapping function is declared).  You'd
>> prefer that?
>
> Urgh, no.

In OF code, I *have* been moving to the following pattern when the OF
code has a sane default:

#ifndef <symbol>
static inline <symbol>(...)
{
        <default implementation>
}
#define <symbol> <symbol>
#endif

I'd normally be totally okay with this in of_irq.h, except for the
fact that this implementation is a temporary solution.  Once I've got
the irq remapping code generalized for all architecture then the map
function could become a static inline in this form.

Fortunately, this code should never be on a hot path.

g.
