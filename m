Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932833Ab2EJXDN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 19:03:13 -0400
Received: from gate.crashing.org ([63.228.1.57]:52425 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932800Ab2EJXDK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 19:03:10 -0400
Message-ID: <1336690954.3881.66.camel@pasglop>
Subject: Re: [PATCH] bitops: add _local bitops
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rob Landley <rob@landley.net>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 11 May 2012 09:02:34 +1000
In-Reply-To: <4FAACF1C.2060504@zytor.com>
References: <20120509134528.GA18044@redhat.com>
	 <20120509121940.459e93ba.akpm@linux-foundation.org>
	 <20120509200735.GA22743@redhat.com> <4FAACF1C.2060504@zytor.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-09 at 13:10 -0700, H. Peter Anvin wrote:
> On 05/09/2012 01:07 PM, Michael S. Tsirkin wrote:
> > 
> > In practice ATM any of the above will work. We probably don't even need
> > to add barrier() calls since what we do afterwards is apic access which
> > has an optimization barrier anyway.  But I'm fine with adding them in
> > there just in case if that's what people want.
> > 
> 
> If you have the optimization barrier anyway, then I'd be fine with you
> just using __test_and_clear_bit() and add to a comment in
> arch/x86/include/asm/bitops.h that KVM needs it to be locally atomic.
> 
> 	
What is it used for ? IE. Is this strictly a requirement of x86 KVM ?

Cheers,
Ben.


