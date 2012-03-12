Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756324Ab2CLSlL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 14:41:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51872 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751622Ab2CLSlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 14:41:08 -0400
Message-ID: <4F5E431D.8010305@zytor.com>
Date: Mon, 12 Mar 2012 11:40:29 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: =?UTF-8?B?RmVybmFuZG8gTHVpcyBWw6F6cXVleiBDYW8=?= 
	<fernando@oss.ntt.co.jp>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        Don Zickus <dzickus@redhat.com>, linux-tip-commits@vger.kernel.org,
        torvalds@linux-foundation.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        mingo@elte.hu, Yinghai Lu <yinghai@kernel.org>,
        akpm@linux-foundation.org, vgoyal@redhat.com
Subject: Re: [PATCH 1/2] boot: ignore early NMIs
References: <CAE9FiQVPnO8-tuPoio0Wxv=8rjdm2tJbBk3+3ystueyYtZn9BA@mail.gmail.com> <20120216172735.GX9751@redhat.com> <CAE9FiQVhbAM9vjx-uFcuc0ndsUp0aez9_TsQHStje5G5iwYbag@mail.gmail.com> <20120216215603.GH9751@redhat.com> <m1y5s2ku36.fsf@fess.ebiederm.org> <m1fwe9bpk2.fsf@fess.ebiederm.org> <20120217195430.GO9751@redhat.com> <m1y5s07rn3.fsf@fess.ebiederm.org> <20120220151419.GU9751@redhat.com> <m1obss39a4.fsf@fess.ebiederm.org> <20120221135934.GF26998@redhat.com> <m1ipip6xe8.fsf@fess.ebiederm.org> <4F573E1C.2060909@oss.ntt.co.jp> <4F573E74.5040504@oss.ntt.co.jp> <m1eht31z8e.fsf@fess.ebiederm.org> <4F58495B.5080308@oss.ntt.co.jp> <m1r4x3yrsv.fsf@fess.ebiederm.org> <4F5A6D87.4050809@zytor.com> <4F5D8D0E.8060702@oss.ntt.co.jp> <4F5D8E63.60606@zytor.com> <4F5D943C.5020403@oss.ntt.co.jp>
In-Reply-To: <4F5D943C.5020403@oss.ntt.co.jp>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2012 11:14 PM, Fernando Luis Vázquez Cao wrote:
> 
> The thing is that we want to avoid playing with hardware in the kdump
> reboot patch when we can avoid it, the premise being that it cannot
> be accessed without risking a lockup or worse (as the deadlock accessing
> the I/O APIC showed). The kernel is crashing after all. What is more,
> I forgot to mention that the long term goal is to leave the LAPIC
> untouched too (we really want to keep the number of things we do in the
> context of the crashing kernel to the bare minimum), so we would still
> need to fix the early IDT.
> 
> My patch set just installs a special handler for the NMI case so I think
> it is pretty simple and self contained.
> 
> Another reason to apply these patches is to be consistent with the rest
> of the kernel. Spurious NMIs that would have been ignored after installing
> the final IDT would cause the system to halt if they happen
> to arrive while the early IDT is in place.
> 

I'm concerned that you're adding failure modes because you don't want to
solve the real problem which is you need to block this at the source.
It is way more than the IDT that has to work (at the very least, you
need the GDT and a working stack) at all times in order for NMIs to be
receivable.  That doesn't address what happens if you're getting an NMI
storm either.

	-hpa


