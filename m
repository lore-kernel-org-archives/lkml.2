Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671Ab1I1QLR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 12:11:17 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60877 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568Ab1I1QLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 12:11:15 -0400
MIME-Version: 1.0
In-Reply-To: <4E835F8C0200007800058461@nat28.tlf.novell.com>
References: <cover.1315878463.git.jeremy.fitzhardinge@citrix.com>
 <3300108.XQUp9Wrktc@chlor> <4E81FD52.50106@goop.org> <CA+55aFx7dv4C4ZB_3CFjdJmX_wpoxecpqo1ARYr1=zTVP=CVVA@mail.gmail.com>
 <4E835F8C0200007800058461@nat28.tlf.novell.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 28 Sep 2011 09:10:54 -0700
X-Google-Sender-Auth: 15qd6EIGJGbtASGexJiuWoOHilU
Message-ID: <CA+55aFyVoZpZZp7ejypTv21Cx_qJWkZQdpJOnxBa_jUxsCjhuw@mail.gmail.com>
Subject: Re: [Xen-devel] [PATCH 00/10] [PATCH RFC V2] Paravirtualized ticketlocks
To: Jan Beulich <JBeulich@suse.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 28, 2011 at 8:55 AM, Jan Beulich <JBeulich@suse.com> wrote:
>
>> just use "lock xaddw" there too.
>
> I'm afraid that's not possible, as that might carry from the low 8 bits
> into the upper 8 ones, which must be avoided.

Oh damn, you're right. So I guess the "right" way to do things is with
cmpxchg, but some nasty mfence setup could do it too.

                          Linus
