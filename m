Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263Ab1I1RXS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 13:23:18 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64329 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433Ab1I1RXR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 13:23:17 -0400
MIME-Version: 1.0
In-Reply-To: <4E834FBA.1080709@goop.org>
References: <cover.1315878463.git.jeremy.fitzhardinge@citrix.com>
 <3300108.XQUp9Wrktc@chlor> <4E81FD52.50106@goop.org> <CA+55aFx7dv4C4ZB_3CFjdJmX_wpoxecpqo1ARYr1=zTVP=CVVA@mail.gmail.com>
 <4E835F8C0200007800058461@nat28.tlf.novell.com> <CA+55aFyVoZpZZp7ejypTv21Cx_qJWkZQdpJOnxBa_jUxsCjhuw@mail.gmail.com>
 <4E834FBA.1080709@goop.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 28 Sep 2011 10:22:56 -0700
X-Google-Sender-Auth: iVnfVLDx5k2y48QFCo9e991pa5g
Message-ID: <CA+55aFzGZp8YaQMMUMwV+pd_vnqR14CtiTmTtkXuotQBg0zspg@mail.gmail.com>
Subject: Re: [Xen-devel] [PATCH 00/10] [PATCH RFC V2] Paravirtualized ticketlocks
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Jan Beulich <JBeulich@suse.com>,
        Stephan Diestelhorst <stephan.diestelhorst@amd.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>, Nick Piggin <npiggin@kernel.dk>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        xen-devel@lists.xensource.com, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 28, 2011 at 9:47 AM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
> Could do something like:
>
>        if (ticket->head >= 254)
>                prev = xadd(&ticket->head_tail, 0xff02);
>        else
>                prev = xadd(&ticket->head_tail, 0x0002);
>
> to compensate for the overflow.

Oh wow. You havge an even more twisted mind than I do.

I guess that will work, exactly because we control "head" and thus can
know about the overflow in the low byte. But boy is that ugly ;)

But at least you wouldn't need to do the loop with cmpxchg. So it's
twisted and ugly, but migth be practical.

                   Linus
