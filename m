Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224Ab1CYLWK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 07:22:10 -0400
Received: from ozlabs.org ([203.10.76.45]:58703 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753564Ab1CYLWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 07:22:04 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christian Borntraeger <borntraeger@de.ibm.com>,
        Anthony Liguori <aliguori@us.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>, qemu-devel@nongnu.org,
        linux-kernel@vger.kernel.org, stefanha@gmail.com, kwolf@redhat.com,
        prerna@linux.vnet.ibm.com
Subject: Re: [PATCH, RFC] virtio_blk: add cache control support
In-Reply-To: <4D8B14BD.2060602@de.ibm.com>
References: <20110315141049.GA30627@lst.de> <20110315141644.GA30803@lst.de> <87y64fhfjw.fsf@rustcorp.com.au> <20110316140958.GB21877@lst.de> <877hbygwu7.fsf@rustcorp.com.au> <4D8AB514.5020306@us.ibm.com> <4D8B14BD.2060602@de.ibm.com>
User-Agent: Notmuch/0.3.1 (http://notmuchmail.org) Emacs/23.1.1 (i686-pc-linux-gnu)
Date: Fri, 25 Mar 2011 15:38:51 +1030
Message-ID: <8762r7lrbw.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Mar 2011 10:54:05 +0100, Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> Am 24.03.2011 04:05, schrieb Anthony Liguori:
> >> ie. lguest and S/390 don't trap writes to config space.
> >>
> >> Or perhaps they should?  But we should be explicit about needing it...
> > I don't think we ever operated on the assumption that config space writes would trap.
> > 
> > I don't think adding it is the right thing either because you can do byte access to the config space which makes atomicity difficult.
> 
> There is the additional problem, that s390 has no MMIO and,therefore,
> there is no real HW support for trapping writes to an area. You can
> use page faults, or read-only faults on newer systems, but this is 
> expensive. In addition, page faults only deliver the page frame, but
> not the offset within a page.

That's not *really* a problem, since you have control over the
config_set operation and could do whatever you wanted.

But I wanted to make sure we're all on the same page: you *can't* rely
on the host knowing immediately what you write to the config space.  If
you want that, an actual queued request is necessary...

Thanks,
Rusty.
