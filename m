Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751Ab0IHVUo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 17:20:44 -0400
Received: from ns2.cypress.com ([157.95.67.5]:49083 "EHLO ns2.cypress.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755388Ab0IHVUl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 17:20:41 -0400
Reply-To: <david.cross@cypress.com>
From: "David Cross" <david.cross@cypress.com>
To: "'Christoph Hellwig'" <hch@infradead.org>
Cc: <dhowells@redhat.com>, <linux-cachefs@redhat.com>, <greg@kroah.com>,
        <linux-kernel@vger.kernel.org>
References: <1283888011.7250.17.camel@odc-laptop> <4313.1283956531@redhat.com> <9465F8A421744836B35704023ECA8253@stanford.edu> <20100908210553.GA22411@infradead.org>
Subject: RE: [PATCH] Cachefiles, mpage_cleardirty addtition, west bridge related
Date: Wed, 8 Sep 2010 14:20:06 -0700
Organization: Cypress Semiconductor
Message-ID: <AE20F72077384EF281F87A1E094BED26@stanford.edu>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Thread-Index: ActPmaNjVy1m5z4xRfaTMlOmvfkoZgAAPsFg
In-Reply-To: <20100908210553.GA22411@infradead.org>
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-Tracker: AAAAAA==
X-MailScanner: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



-----Original Message-----
From: Christoph Hellwig [mailto:hch@infradead.org] 

On Wed, Sep 08, 2010 at 09:51:22AM -0700, David Cross wrote:
> > This is used by the current west bridge driver in the linux-next tree,
> > marked as BROKEN at the moment. It is used in order to clear dirty pages
> > from the page cache for a specific file after it has been allocated.
This
> > allows west bridge to transfer data from USB to storage directly without
> > requiring that the file data path go through the CPU. The easiest way to
> > think of this is that it allows for direct file based DMA. Please let me
> > know if you have any additional questions or concerns on this.

> It's sad enough that it was taken into any tree at all, but we're not
> going to add incorrect crap into the kernel kernel for it.

Can you elaborate on what you mean by "incorrect crap" in a constructive way
if at all possible please?

> mpage_* are pagecache manpipulation routines, and are only for use by
> filesystems for inodes they manage.  A driver may never access this
> directly.

Then what about a user space call such as falloc()? Is your objection to the
existence of the code or the place where it is called from?

> Is this the same piece of junk you wanted fat_get_block
> exported for?

It is the same driver code, but I removed the fat_get_block call in a patch
that I submitted previously based on past inputs, instead adding a few lines
to this function.





---------------------------------------------------------------
This message and any attachments may contain Cypress (or its
subsidiaries) confidential information. If it has been received
in error, please advise the sender and immediately delete this
message.
---------------------------------------------------------------

