Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913Ab0IHU4a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 16:56:30 -0400
Received: from ns2.cypress.com ([157.95.67.5]:48426 "EHLO ns2.cypress.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754793Ab0IHU40 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 16:56:26 -0400
Reply-To: <david.cross@cypress.com>
From: "David Cross" <david.cross@cypress.com>
To: "'Greg KH'" <greg@kroah.com>
Cc: <linux-kernel@vger.kernel.org>
References: <5BFACB1451C1459BA8562A5561D0A4E6@stanford.edu> <1283386101.17399.10.camel@odc-laptop> <1283467434.4378.11.camel@odc-laptop> <1283887330.7250.6.camel@odc-laptop> <20100907235704.GC12823@kroah.com>
Subject: RE: [PATCH] west bridge, kconfig and hal fixes
Date: Wed, 8 Sep 2010 13:56:09 -0700
Organization: Cypress Semiconductor
Message-ID: <04CAA605B7EE4630B1EB550AAAD0B746@stanford.edu>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Thread-Index: ActO7FSscnCRUH7lR9yGXuqJCBaReAAqReng
In-Reply-To: <20100907235704.GC12823@kroah.com>
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-Tracker: AAAAAA==
X-MailScanner: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Greg KH [mailto:greg@kroah.com] 

On Tue, Sep 07, 2010 at 12:22:10PM -0700, David Cross wrote:

> First off, what's with the "Re:" of the Subject?  What are you
> responding to here?
I will removed that going forward when submitting patches, it does seem
appropriate on this response, so am leaving it in.

> > This patch contains the kconfig changes necessary to fix build errors
> > that could come up in the linux-next version. It also includes an
> > additional HAL layer for the west bridge CRAM interface.

> Again, one patch per change, please break this up.

Can I break it up as 1) moving PNAND HAL layer + Kconfig changes and 2) CRAM
HAL layer inclusion or is this still too tightly coupled? The issue that I
am having is that I was working on these drivers while waiting on inclusion
in the staging area in order to incorporate all of the feedback I have
gotten so far. As such, I now either have to artificially break up the
patches or start with a clean kernel and start sequentially hand coding them
again. I think this latter might be what you want, but this is really
time-consuming to do at this point. 
While I definitely understand the need for this type of review of patches
for changes to the kernel itself, it is hard for me to understand why the
same rigor needs to apply to this driver in the staging area. As you
mentioned, it needs a lot of work to meet the standards for acceptance. I
have done a fair amount of work to move it closer. Do I really need to undo
and repeat all of that in order to clean up "BROKEN" code in the staging
area of the linux-next tree? 

> > The inclusion
> > of this interface support did require the reorganization of some of the
> > existing code, which is part of the reason for the size of the patch.
> > Moving files and directories makes this patch seem larger than it really
> > is.

> If you use git you can send a patch that properly shows only what
> changes even if the file is moved.  Care to do that?

I have not used git so far, other than to pull from repositories. I probably
could, but it will take me some time to learn. Is this "nice to have" or do
I need to do it to get this patch applied?

> > The Kconfig changes are closely related to the inclusion of the CRAM
> > HAL layer, and as such this patch is difficult to logically separate. 

> Why is it necessary?

The HAL layer in general or this specific HAL layer? One of the reasons for
needing memory interface options is the allocation of pins on a given
platform. For example, if CLE was used as a GPIO for some other purpose, it
is nice to have the option to move to an SRAM like interface. Also, I needed
to develop this for unrelated reasons. As such, making minor structural
changes such that new HALs could be easily incorporated in an intuitive
manner seemed to be a plus. I also hoped that it would make the structure
and rationale behind the initial driver structure more intuitive to the
kernel maintainers.

> > The linux-next tree does not seem to have a config for the zoom2, and
> > trying to build it for that board seems to make the compilation break.

> Why should the driver care about which arch it is built for?  It should
> build on _all_ arches, right?

It should build on all architectures that have an appropriate HAL
implemented. Otherwise, if you don't have a method for low level
communication with west bridge, why would you want to build the driver?

> > As such, the only thing that I tested was compilation using the two
> > different HALs (one of which is added in this patch). Please let me know
> > if there are problems or questions with this.

> Why do you need a "HAL" at all here?

For low level communication. The interface to the processor is a memory
interface across which mailbox messages are passed. These mailbox messages
makeup a sort of data link layer on top of which higher levels of
abstraction can be built. 
Additionally, the HAL defines how you pump data to the device's endpoints,
since this is also done across the memory interface from the processor's
perspective. Other power management items are also included, and the
complete list of functions can be seen in the header files.

Thanks,
david


---------------------------------------------------------------
This message and any attachments may contain Cypress (or its
subsidiaries) confidential information. If it has been received
in error, please advise the sender and immediately delete this
message.
---------------------------------------------------------------

