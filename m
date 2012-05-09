Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760197Ab2EIQVK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 12:21:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18464 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758262Ab2EIQVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 12:21:07 -0400
Date: Wed, 9 May 2012 18:47:35 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Rob Landley <rob@landley.net>, Thomas Gleixner <tglx@linutronix.de>,
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
        kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] bitops: add _local bitops
Message-ID: <20120509154734.GB20867@redhat.com>
References: <20120509134528.GA18044@redhat.com>
 <4FAA7939.6040706@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FAA7939.6040706@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 07:03:37AM -0700, H. Peter Anvin wrote:
> On 05/09/2012 06:45 AM, Michael S. Tsirkin wrote:
> > kvm needs to update some hypervisor variables atomically
> > in a sense that the operation can't be interrupted
> > in the middle. However the hypervisor always runs
> > on the same CPU so it does not need any memory
> > barrier or lock prefix.
> > 
> > At Peter Anvin's suggestion, add _local bitops for this purpose:
> > define them as non-atomics for x86 and (for now) atomics
> > for everyone else.
> > 
> > Uses are not restricted to virtualization: they
> > might be useful to communicate with an interrupt
> > handler if we know that it's running on the same CPU.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> 
> I don't think you can use the x86 nonatomics as-is, because they don't
> contain optimization barriers.
> 
> 	-hpa

By the way, clear_bit on x86 does not seem to contain
an optimization barrier - is my reading correct?
Lock prefix does not affect the compiler, right?
