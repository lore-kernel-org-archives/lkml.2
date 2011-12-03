Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296Ab1LCWXH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 17:23:07 -0500
Received: from gate.crashing.org ([63.228.1.57]:36960 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911Ab1LCWXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 17:23:04 -0500
Message-ID: <1322950969.11728.24.camel@pasglop>
Subject: Re: [PATCH 1/2] virtio-scsi: first version
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Date: Sun, 04 Dec 2011 09:22:49 +1100
In-Reply-To: <4EDA5E7F.30508@redhat.com>
References: <1322661299-28855-1-git-send-email-pbonzini@redhat.com>
	 <1322661299-28855-2-git-send-email-pbonzini@redhat.com>
	 <1322867228.11728.19.camel@pasglop> <4EDA5E7F.30508@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-12-03 at 18:38 +0100, Paolo Bonzini wrote:
> On 12/03/2011 12:07 AM, Benjamin Herrenschmidt wrote:
> > This is typically the one thing you should -really- obtain from the
> > other side. This is the number one reason why we cannot today reliably
> > emulate a SCSI controller in qemu -and- pass-through the SCSI commands
> > to the host /dev/sg or equivalent (only full device emulation is
> > reliable).
> >
> > This is also typically what something like virtio-scsi allows us to fix,
> > so let's fix it. IE. we have the ability to query the "limits" of the
> > real HBA /  transport on the host side and to pass them along to the
> > guest, which enables us to do real pass-through.
> 
> You can fix this in QEMU; READ and WRITE commands can be split in 
> multiple parts.  The scsi-block device I added recently does this.

You can split -some- commands... it's clumsy and not always legit, you
don't always know all commands (what about vendor commands such as
firmware updates etc...) and it can be really tricky with tagged queues
and barriers.

> However, it seems like a simple change, so I'll do it.  I'll add 
> max_sectors and cmd_per_lun to the config space.

Sounds like a good start :-)

Cheers,
Ben.


