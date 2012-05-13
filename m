Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764Ab2EMKss (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 06:48:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739Ab2EMKsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 06:48:46 -0400
Message-ID: <4FAF917A.1080904@redhat.com>
Date: Sun, 13 May 2012 13:48:26 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Christoph Lameter <cl@linux.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Rob Landley <rob@landley.net>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCHv2] bitops: add _local bitops
References: <20120509162819.GA21328@redhat.com> <alpine.DEB.2.00.1205101401010.18664@router.home> <4FAF8941.2010308@redhat.com> <20120513104502.GD23273@redhat.com>
In-Reply-To: <20120513104502.GD23273@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2012 01:45 PM, Michael S. Tsirkin wrote:
> On Sun, May 13, 2012 at 01:13:21PM +0300, Avi Kivity wrote:
> > On 05/10/2012 10:04 PM, Christoph Lameter wrote:
> > > On Wed, 9 May 2012, Michael S. Tsirkin wrote:
> > >
> > > > kvm needs to update some hypervisor variables atomically
> > > > in a sense that the operation can't be interrupted
> > > > in the middle. However the hypervisor always runs
> > > > on the same CPU so it does not need any memory
> > > > barrier or lock prefix.
> > > >
> > > > Add _local bitops for this purpose: define them
> > > > as non-atomics for x86 and (for now) atomics for
> > > > everyone else.
> > >
> > > Have you tried to use the this_cpu_ops for that purpose? They create the
> > > per cpu atomic instructions that you want without a lock prefix and can
> > > also relocate the per cpu pointer to the correct processor via a
> > > segment register prefix.
> > >
> > > There are no bit operations provided right now but those can either be
> > > improvised using this_cpu_cmpxchg or added.
> > 
> > this_cpu_xchg() should be sufficient, since only bit zero has any
> > meaning in our use case (so xchg with zero is equivalent to
> > test_and_clear_bit).
>
> Yes it should work. No idea how it'd perform:
> arch/x86/include/asm/percpu.h implies it's expensive.  

It says a naive implementation is expensive, whereas the implementation
actually used (a cmpxchg loop) is better.

> My latest version
> simply documents what __test_and_clear does anyway.
> Which was indicated is acceptable ...
> Did you change your mind?

No.

-- 
error compiling committee.c: too many arguments to function

