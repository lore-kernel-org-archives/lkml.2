Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041Ab1DHKnK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 06:43:10 -0400
Received: from thoth.sbs.de ([192.35.17.2]:27506 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592Ab1DHKnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 06:43:09 -0400
Message-ID: <4D9EE6A0.9020205@siemens.com>
Date: Fri, 08 Apr 2011 12:42:40 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Pekka Enberg <penberg@kernel.org>, Anthony Liguori <anthony@codemonkey.ws>,
        Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "aarcange@redhat.com" <aarcange@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "asias.hejun@gmail.com" <asias.hejun@gmail.com>
Subject: Re: [ANNOUNCE] Native Linux KVM tool
References: <1301592656.586.15.camel@jaguar>	<4D982E89.8070502@redhat.com>	<BANLkTinbCAUqaKfmKaj-7GXTh9F2if0x+Q@mail.gmail.com>	<4D9847BC.9060906@redhat.com>	<4D98716D.9040307@codemonkey.ws>	<4D9873CD.3080207@redhat.com>	<20110406093333.GB6465@elte.hu>	<4D9E6F6E.9050709@codemonkey.ws>	<BANLkTimEwAuL4PM9vBfogkrua-Z44AZQvg@mail.gmail.com>	<4D9EBBC3.2040803@siemens.com>	<1302251236.27918.31.camel@jaguar>	<4D9ED146.7040004@siemens.com> <BANLkTimuicK-7Og8V+W1Oz6MqL3sa13H4A@mail.gmail.com>
In-Reply-To: <BANLkTimuicK-7Og8V+W1Oz6MqL3sa13H4A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-04-08 11:32, Cyrill Gorcunov wrote:
> It seems there is a misunderstanding. KVM-tool is quite far from been KVM
> replacement (if ever). And what we're doing -- extremely tiny/small HV which
> would help us to debug/test kernel code.

I think your core team may have this vision, but my impression is that
some people here think much further.

Also note that even for guest debugging some fairly essential features
are missing yet. The gdbstub is among them and the most prominent one.

> 
> So I personally think of two scenarios:
> 
> 1) QEMU eventually get merged upstream and kvm-tool remains small and
> tiny example of
> how to do /dev/kvm ioctls with some positive (I hope) results. Or
> maybe kvm-tool gets dropped
> since nobody needs it, this is possible too of course.
> 
> 2) kvm-tool silently sit in tools/kvm while qemu remains on separated
> repo. Both go own
> ways. Not a pleasant scenario but still possible.

For me the separate tree thing is not that important as long as KVM
developers continue to hack on both sides (which most of us do).

> 
> And we don't consider kvm-tool as a qemu competitor by any means. It
> simply different
> weight categories.

Long-term, IMHO, kvm-tool either has to cover at least one use case qemu
is not interested in or it has to be noticeably better in one domain.
Just being a small demo that has to be maintained _in_addition_ to qemu
/wrt KVM ABI changes will make it suffer quickly. Right now x86 has
reached a rather calm period in this regard, but PPC e.g. is about to
enter the same stormy times we had with x86 in the past years. We've
been through duplicate userland maintenance phase with qemu-kvm vs.
upstream qemu for far too long, and it was a real pain (it still is, but
the last duplicate bits should disappear before qemu-0.15).

> 
> And of course we're glad to get any feedback (and positive and
> especially negative).
> Pointing out that SMP might be such a problem made us scratching the head ;)

One big advantage of qemu is that it can nicely reproduce tricky
concurrency issues (not all but many) as it provides true SMP support.
We've successfully used this several times for debugging weird kernel
and driver issues in the past 4 years.

So I personally have no use case for kvm-tool that qemu(-kvm) wouldn't
already solve, generally in a more advance way. That may explain my
skepticism. :)

Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
