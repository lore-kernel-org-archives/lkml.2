Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398Ab1JRGvd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 02:51:33 -0400
Received: from ozlabs.org ([203.10.76.45]:34775 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751668Ab1JRGvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 02:51:32 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Pawel Moll <pawel.moll@arm.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        virtualization@lists.linux-foundation.org
Cc: Anthony Liguori <aliguori@us.ibm.com>,
        "Michael S.Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v3] virtio: Add platform bus driver for memory mapped virtio device
In-Reply-To: <1317921230.28696.102.camel@hornet.cambridge.arm.com>
References: <1317841030-17758-1-git-send-email-pawel.moll@arm.com> <1317919843-8343-1-git-send-email-pawel.moll@arm.com> <1317921230.28696.102.camel@hornet.cambridge.arm.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Tue, 18 Oct 2011 14:39:17 +1030
Message-ID: <87lisjq6tu.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Oct 2011 18:13:50 +0100, Pawel Moll <pawel.moll@arm.com> wrote:
> > I'll post the updated device spec shortly.
> 
> Here it goes. I'm actually happy about the "maximum queue size" solution
> - it worked out quite neat in the end :-)
> 
> Please, do have a look at the hopefully final shape of things and
> comment if you still see some potential issues :-)
> 
> Cheers!
> 
> Pawel

Looks good.  I'll have a go at moving it across to the LyX master soon.

> \item 0x028 | W | GuestPageSize \\
> Guest page size.\\
> Device driver must write the guest page size in bytes to the register
> during initialization, before any queues are used.

This has to be a power of 2, and you should specify what it's used for.
It's really the multiplier for PFN values, right?

> \item 0x03c | W | QueueAlign \\
> Used Ring alignment in the virtual queue.\\
> Writing to this register notifies the Host about alignment boundary of
> the Used Ring in bytes. This applies to the queue selected by writing to
> QueueSel.

Either specify that this must be a power of 2, or actually specify it as
the power of 2 to use, (ie. valid values are 1 through 16, with 12 being
the value that virtio PCI would use).

Otherwise you have to do a divide on the qemu side.

Looks good otherwise though!

Cheers,
Rusty.
