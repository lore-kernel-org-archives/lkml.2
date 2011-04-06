Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676Ab1DFK4K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 06:56:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46939 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807Ab1DFK4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 06:56:08 -0400
Date: Wed, 6 Apr 2011 12:55:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Olivier Galibert <galibert@pobox.com>
Cc: Avi Kivity <avi@redhat.com>, Anthony Liguori <anthony@codemonkey.ws>,
        Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        aarcange@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org,
        joro@8bytes.org, penberg@cs.helsinki.fi, asias.hejun@gmail.com,
        gorcunov@gmail.com
Subject: Re: [ANNOUNCE] Native Linux KVM tool
Message-ID: <20110406105547.GA13766@elte.hu>
References: <1301592656.586.15.camel@jaguar>
 <4D982E89.8070502@redhat.com>
 <BANLkTinbCAUqaKfmKaj-7GXTh9F2if0x+Q@mail.gmail.com>
 <4D9847BC.9060906@redhat.com>
 <4D98716D.9040307@codemonkey.ws>
 <4D9873CD.3080207@redhat.com>
 <20110406093333.GB6465@elte.hu>
 <20110406101405.GA65838@dspnet.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110406101405.GA65838@dspnet.fr>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Olivier Galibert <galibert@pobox.com> wrote:

> On Wed, Apr 06, 2011 at 11:33:33AM +0200, Ingo Molnar wrote:
> > Examples: X11 and GCC - both were struggling for years to break through magic 
> > invisible barriers of growth and IMHO a lot of it had to do with the lack of 
> > code (and development model) cleanliness.
> 
> A large part of what's killing X11 and qemu is the decomposition in
> multiple trees and the requirement that every version must work with
> every other version.
> 
> For X11 you have:
> - the server
> - the protocol headers
> - the individual 2D drivers
> - libdrm
> - the kernel
> - mesa
> - the video decoding driver/libs
> 
> For qemu you have:
> - qemu
> - qemu-kvm
> - the kernel
> - libvirt
> - seabios
> 
> Any reaching change ends up hitting most of the trees, with all to
> coordination that means.  And in any case you're supposed to handle
> any version of the other components.

Splitting up a project into several trees, often unnecessarily, is a 
self-inflicted wound really.

Smaller projects can hurt from that as well: a well-known example is oprofile.

Pointing to the stupidity of overmodularization is one of my pet peeves, i 
consider it a "development model cleanliness" bug that needlessly exposes OSS 
projects to the negative effects of technical and social forks and 
complicates/shackles them. I flamed^W argued about it before, in the KVM / Qemu 
context as well.

There are good examples of successful, highly integrated projects:

  - FreeBSD - it has achieved Linux-alike results with a fraction of the
              manpower

  - Android - on the desktop it has achieved much more than Linux, with a
              fraction of the manpower

And that concept can be brought to its logical conclusion: i think it's only a 
matter of time until someone takes the Linux kernel, integrates klibc and a 
toolchain into it with some good initial userspace and goes wild with that 
concept, as a single, sane, 100% self-hosting and self-sufficient OSS project, 
tracking the release schedule of the Linux kernel.

It might not happen on PC hardware (which is *way* too OSS-hostile), but it 
will eventually happen IMO. It's the eventual OSS killer feature and weirdly 
enough no-one has tried it yet. (Android comes close in a sense)

Thanks,

	Ingo
