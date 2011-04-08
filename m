Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971Ab1DHJc0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 05:32:26 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:54981 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681Ab1DHJcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 05:32:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Bv9iOjt35BpNSfYoBr2SZkWkbz0LMsc4IDl9ihQx+z/OIsBRG2GiQ/cS2Pny5XR+10
         RJ7i5dle9u9IUD43fhNCihI0apQnaoYzdAu1sVPe/NMEJsNPRidRHFdMer75jJrgrIoD
         LSkzwZ5RAM//H2PH9ddhFvXtlCC2zhSAd00zI=
MIME-Version: 1.0
In-Reply-To: <4D9ED146.7040004@siemens.com>
References: <1301592656.586.15.camel@jaguar>
	<4D982E89.8070502@redhat.com>
	<BANLkTinbCAUqaKfmKaj-7GXTh9F2if0x+Q@mail.gmail.com>
	<4D9847BC.9060906@redhat.com>
	<4D98716D.9040307@codemonkey.ws>
	<4D9873CD.3080207@redhat.com>
	<20110406093333.GB6465@elte.hu>
	<4D9E6F6E.9050709@codemonkey.ws>
	<BANLkTimEwAuL4PM9vBfogkrua-Z44AZQvg@mail.gmail.com>
	<4D9EBBC3.2040803@siemens.com>
	<1302251236.27918.31.camel@jaguar>
	<4D9ED146.7040004@siemens.com>
Date: Fri, 8 Apr 2011 13:32:24 +0400
Message-ID: <BANLkTimuicK-7Og8V+W1Oz6MqL3sa13H4A@mail.gmail.com>
Subject: Re: [ANNOUNCE] Native Linux KVM tool
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Pekka Enberg <penberg@kernel.org>, Anthony Liguori <anthony@codemonkey.ws>,
        Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "aarcange@redhat.com" <aarcange@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "asias.hejun@gmail.com" <asias.hejun@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 8, 2011 at 1:11 PM, Jan Kiszka <jan.kiszka@siemens.com> wrote:
> On 2011-04-08 10:27, Pekka Enberg wrote:
>> Hi Jan,
>>
>> On Fri, 2011-04-08 at 09:39 +0200, Jan Kiszka wrote:
>>> I agree that it's easy to change 2kSomething LOC for this. But if you
>>> now wait too long designing in essential features like SMP, a scalable
>>> execution model, and - very important - portability (*), it can get
>>> fairly painful to fix such architectural deficits later on. How long did
>>> it take for Linux to overcome the BKL? QEMU is in the same unfortunate
>>> position.
>>
>> Yup, and we're taking your feedback seriously (and are thankful for
>> it!). We're hoping to look at SMP in the near future - help is
>> appreciated!
>
> Honestly, I do not yet see a major advantage for us to invest here
> instead of / in addition to continuing to improve QEMU. We've spend
> quite some effort on the latter with IMO noteworthy results. Porting
> over qemu-kvm to upstream was and still is among those efforts. We (*)
> are "almost done". :)
>
> Just one example: Despite QEMU's current deficits, I just have add a
> handful of (ad-hoc) patches to turn it into a (soft) real-time
> hypervisor, and that also for certain non-Linux guests. Your approach is
> yet man years of development and stabilization effort away from getting
> close to such a level.
>
> Don't want to discourage you or other contributors. I wish you that this
> approach can gather the critical mass and momentum to make it a real
> alternative, at least for a subset of use cases. We will surely keep an
> eye on it and re-assess its pros&cons as it progresses.
>
> Jan
>
> (*) the QEMU & KVM community
>
> --
> Siemens AG, Corporate Technology, CT T DE IT 1
> Corporate Competence Center Embedded Linux
>

It seems there is a misunderstanding. KVM-tool is quite far from been KVM
replacement (if ever). And what we're doing -- extremely tiny/small HV which
would help us to debug/test kernel code.

So I personally think of two scenarios:

1) QEMU eventually get merged upstream and kvm-tool remains small and
tiny example of
how to do /dev/kvm ioctls with some positive (I hope) results. Or
maybe kvm-tool gets dropped
since nobody needs it, this is possible too of course.

2) kvm-tool silently sit in tools/kvm while qemu remains on separated
repo. Both go own
ways. Not a pleasant scenario but still possible.

And we don't consider kvm-tool as a qemu competitor by any means. It
simply different
weight categories.

And of course we're glad to get any feedback (and positive and
especially negative).
Pointing out that SMP might be such a problem made us scratching the head ;)
