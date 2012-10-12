Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932850Ab2JLHiR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 03:38:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50888 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932459Ab2JLHiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 03:38:16 -0400
Message-ID: <5077C8DA.5030604@redhat.com>
Date: Fri, 12 Oct 2012 09:38:02 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121009 Thunderbird/16.0
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>,
        virtualization@lists.linux-foundation.org,
        Thomas Lendacky <tahm@linux.vnet.ibm.com>, avi@redhat.com,
        Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: [PATCH 0/3] virtio-net: inline header support
References: <506C192E.5060700@redhat.com> <87bogj2j1b.fsf@rustcorp.com.au> <506D3610.7000103@redhat.com> <87ipaq1jtt.fsf@rustcorp.com.au> <506D8DD5.20904@redhat.com> <87391t1nkq.fsf__40391.6521034718$1349505001$gmane$org@rustcorp.com.au> <507029EB.2050405@redhat.com> <878vbg8cma.fsf@rustcorp.com.au> <5073D1D8.3060905@redhat.com> <87k3ux98oc.fsf@rustcorp.com.au> <20121011110430.GF5552@redhat.com> <87wqyw63et.fsf@rustcorp.com.au>
In-Reply-To: <87wqyw63et.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 12/10/2012 00:37, Rusty Russell ha scritto:
> "Michael S. Tsirkin" <mst@redhat.com> writes:
>> On Thu, Oct 11, 2012 at 10:33:31AM +1030, Rusty Russell wrote:
>>> OK.  Well, Anthony wants qemu to be robust in this regard, so I am
>>> tempted to rework all the qemu drivers to handle arbitrary layouts.
>>> They could use a good audit anyway.
>>
>> I agree here. Still trying to understand whether we can agree to use
>> a feature bit for this, or not.
> 
> I'd *like* to imply it by the new PCI layout, but if it doesn't work
> we'll add a new feature bit.
> 
> I'm resisting a feature bit, since it constrains future implementations
> which could otherwise assume it.

Future implementations may certainly refuse to start if the feature is
not there.  Whether it's a good idea or not, well, that depends on how
much future they are.

Paolo

>>> This would become a glaring exception, but I'm tempted to fix it to 32
>>> bytes at the same time as we get the new pci layout (ie. for the virtio
>>> 1.0 spec).
>>
>> But this isn't a virtio-pci only issue, is it?
>> qemu has s390 bus with same limmitation.
>> How can we tie it to pci layout?
> 
> They can use a transport feature if they need to, of course.  But
> perhaps the timing with ccw will coincide with the fix, in which they
> don't need to, but it might be a bit late.
> 
> Cornelia?
> 
> Cheers,
> Rusty.
> 

