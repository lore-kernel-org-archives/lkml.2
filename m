Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932266Ab1KIMux (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 07:50:53 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55280 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974Ab1KIMuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 07:50:52 -0500
Subject: Re: [PATCH RFC] virtio-spec: flexible configuration layout
From: Sasha Levin <levinsasha928@gmail.com>
To: Avi Kivity <avi@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, Amit Shah <amit.shah@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Krishna Kumar <krkumar2@in.ibm.com>, Pawel Moll <pawel.moll@arm.com>,
        Wang Sheng-Hui <shhuiw@gmail.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
In-Reply-To: <4EBA744D.8020107@redhat.com>
References: <87wrbkvh3v.fsf@rustcorp.com.au>
	 <20111101114542.GA13434@redhat.com> <1320150813.3847.24.camel@lappy>
	 <20111101124223.GA14060@redhat.com> <8739e7uy87.fsf@rustcorp.com.au>
	 <20111102233110.GA20289@redhat.com>  <20111108214021.GA4538@redhat.com>
	 <1320828366.31056.16.camel@lappy>  <4EBA744D.8020107@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Date: Wed, 09 Nov 2011 14:48:58 +0200
Message-ID: <1320842938.31056.55.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-09 at 14:38 +0200, Avi Kivity wrote:
> On 11/09/2011 10:46 AM, Sasha Levin wrote:
> > > Alternatively we can add new structures with new
> > > structure IDs, pointed to from PCI configuration space.
> > > 
> > > As we don't yet have devices or drivers with 64 bit features,
> > > I decided we don't need high feature bits in legacy space.
> > > This also frees up feature bit 31 as we don't need it
> > > to enable high feature bits anymore.
> >
> > KVM tool actually has support for 64bit features, we can probably remove
> > that when Pekka isn't looking :)
> >
> 
> What about the Windows drivers?

While 64-bit features were defined, there was no actual devices to use
them.

So even if Windows drivers had the ability to support 64-bit features,
no device ever needed it therefore no device ever activated it.

A potential issue might arise when we remap feature bit 31 to do
something else, and when activated it would fool Windows drivers to
think that 64-bit features are now activated, while they're not - but
thats not something that should happen since legacy layout shouldn't
have that field enabled as per the spec (no new features in legacy
code).

I was unable to check if it was actually implemented in the drivers
because
http://git.kernel.org/?p=virt/kvm/kvm-guest-drivers-windows.git;a=summary is not quite there (*cough*).

-- 

Sasha.


