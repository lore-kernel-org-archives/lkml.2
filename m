Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094Ab1G1WK2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 18:10:28 -0400
Received: from smtp-out.google.com ([216.239.44.51]:27643 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756071Ab1G1WKX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 18:10:23 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=Hg3B5xK2k8fG2oHorRs8JBoPIu5cobMoZRo4d/OdhK4I/oLPLhP5methttqtvIjFN
	dPJ5vO7vO5wfhPXOjQ2Aw==
MIME-Version: 1.0
In-Reply-To: <20110727210828.GB12714@infradead.org>
References: <1308611855-18096-1-git-send-email-dehrenberg@google.com>
	<20110727210828.GB12714@infradead.org>
Date: Thu, 28 Jul 2011 15:10:20 -0700
Message-ID: <CAAK6Zt1xHuc76GHgcVtxhZPqAK4413Jcb4aWj9DNUUXFrBfrAg@mail.gmail.com>
Subject: Re: [PATCH] dio: Fast-path for page-aligned IOs
From: Daniel Ehrenberg <dehrenberg@google.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 27, 2011 at 2:08 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Mon, Jun 20, 2011 at 04:17:35PM -0700, Dan Ehrenberg wrote:
>> The fast path does not apply for operations of the wrong size
>> or alignmnent, or for operations on raw drives with 512-byte sectors.
>> It might be possible to make this special case a little more general
>> while maintaining its performance benefits, but I do not believe that
>> the full performance benefits can be achieved without resorting to
>> special handling of simple cases, as is done in this patch.
>
> Did you check how this compares to Andis small optimizations?

I'm having a little trouble getting his patch working. I hope to have
this data soon, but I've been distracted by some other things.
>
> Also operations on raw disks are something people with fast devices
> care about a lot.  We often hear about benchmark regressions due to
> stupid little things in the direct I/O code.
>
> If we want to special case something that would be a very easy target,
> with a 1:1 mapping of logical to physical blocks and thus no need
> to call the allocator first, and no need for any kind of locking
> or alignment handling.

Are you talking about special-casing a raw block device? I'd like the
optimization to also work with a file system to support a particular
workload I've been looking at.

Thanks,
Dan
