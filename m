Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030353Ab2HPSWP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 14:22:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33557 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030311Ab2HPSWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 14:22:10 -0400
Message-ID: <502D1FF4.20506@redhat.com>
Date: Thu, 16 Aug 2012 19:29:40 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Alex Williamson <alex.williamson@redhat.com>, gleb@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 0/6] kvm: level irqfd support
References: <20120810223633.809.44188.stgit@bling.home> <20120815142803.GF3068@redhat.com> <1345052191.4683.435.camel@ul30vt.home> <20120815192224.GB5670@redhat.com>
In-Reply-To: <20120815192224.GB5670@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2012 10:22 PM, Michael S. Tsirkin wrote:
> On Wed, Aug 15, 2012 at 11:36:31AM -0600, Alex Williamson wrote:
>> On Wed, 2012-08-15 at 17:28 +0300, Michael S. Tsirkin wrote:
>> > On Fri, Aug 10, 2012 at 04:37:08PM -0600, Alex Williamson wrote:
>> > > v8:
>> > > 
>> > > Trying a new approach.  Nobody seems to like the internal IRQ
>> > > source ID object and the interactions it implies between irqfd
>> > > and eoifd, so let's get rid of it.  Instead, simply expose
>> > > IRQ source IDs to userspace.  This lets the user be in charge
>> > > of freeing them or hanging onto a source ID for later use.
>> > 
>> > In the end it turns out source ID is an optimization for shared
>> > interrupts, isn't it?  Can't we apply the optimization transparently to
>> > the user?  E.g. if we have some spare source IDs, allocate them, if we
>> > run out, use a shared source ID?
>> 
>> Let's think about shared source IDs a bit more.  I think it's wrong that
>> irqfd uses KVM_USERSPACE_IRQ_SOURCE_ID, but I'm questioning whether all
>> irqfd users can share a source ID.  We do not get the logical OR of all
>> users by putting them on the same source ID, we get "last set wins".
>> KVM_USERSPACE_IRQ_SOURCE_ID is used for multiple inputs because the
>> logical OR happens in userspace.  How would we not starve a user if we
>> define KVM_IRQFD_SOURCE_ID?  What am I missing?
> 
> That all irqfds are deasserted on EOI anyway.  So there's no point
> to do a logical OR.
> 
> 

What if a level irqfd shares a line with a KVM_IRQ_LINE ioctl?  Then an
EOI can de-assert the irqfd source, but the line is kept high by the
last KVM_IRQ_LINE invocation.


-- 
error compiling committee.c: too many arguments to function
