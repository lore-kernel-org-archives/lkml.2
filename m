Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284Ab0JEDBM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 23:01:12 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55642 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423Ab0JEDBL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 23:01:11 -0400
MIME-Version: 1.0
In-Reply-To: <1286233776.2463.329.camel@pasglop>
References: <E1P2Tqn-0004gj-W1@jdl.com> <20101004165212.GC13749@angua.secretlab.ca>
 <1286233776.2463.329.camel@pasglop>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 4 Oct 2010 21:00:50 -0600
X-Google-Sender-Auth: K5Lfp3o4e_TaLlvGmk4x7li_0RI
Message-ID: <AANLkTimGtuq8+yA121xg0tVQ=Z=nqfzUG6BC8YqzX3Qh@mail.gmail.com>
Subject: Re: [PATCH] Globally s/struct irq_host/struct irq_domain/
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Jon Loeliger <jdl@jdl.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, tglx@linutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 4, 2010 at 5:09 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Mon, 2010-10-04 at 10:52 -0600, Grant Likely wrote:
>> On Sun, Oct 03, 2010 at 02:03:57PM -0500, Jon Loeliger wrote:
>> >
>> > Just rename the irq_host structure as irq_domain to lessen the
>> > confusion around the word "host".  Updated a few comments and
>> > error messages to use "irq_domain" when refering to the structure.
>> >
>> > Suggested by Ben Herrenschmidt on the device-tree mailing list.
>> >
>> > Signed-off-by: Jon Loeliger <jdl@jdl.com>
>> > ---
>> >
>> > Grant requested one giant patch simply renaming the structure.
>>
>> Thanks Jon,
>>
>> However, considering that tglx has already embarked on his Grand IRQ
>> Subsystem Cleanup, I suspect that this will end up just getting in the
>> way unless he picks it up into his queue.  It may even by that the
>> need for irq_host will disappear once Thomas is finished by merging it
>> into the core code.  I'd like to sit tight on this until the details
>> of what powerpc virqs can be worked out with Ben and Thomas.
>
> I doubt the need for irq_host will disappear. However I don't see that
> going into the core under that name, so I think the rename is a very
> valid thing to do now. We just need to sync the patches to avoid pure
> mechanical clash.
>
> Thomas initial series doesn't yet generalize the virq layer and that
> will take a bit longer, so I'm happy to see Jon stuff go upstream first.

Alright, should tglx pick up this patch, or do you want to carry it in
the powerpc tree?

g.

>
> What hopefully will go away is the big irq_map array, I hope to put the
> domain & hw_number information in the irq_desc or irq_data eventually.
>
>> Also, sorry for sending you down this rabbit hole.  When I suggested
>> this I didn't realize how quickly Thomas was going to get started on
>> his rework.
>
> Cheers,
> Ben.
>
