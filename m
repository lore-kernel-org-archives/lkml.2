Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab0HWVSu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 17:18:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50241 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753965Ab0HWVSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 17:18:48 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: aio: bump i_count instead of using igrab
References: <20100823144755.GP21975@think>
	<20100823145031.GA1279@infradead.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 23 Aug 2010 17:18:41 -0400
In-Reply-To: <20100823145031.GA1279@infradead.org> (Christoph Hellwig's
	message of "Mon, 23 Aug 2010 10:50:31 -0400")
Message-ID: <x4962z12fke.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

> On Mon, Aug 23, 2010 at 10:47:55AM -0400, Chris Mason wrote:
>> The aio batching code is using igrab to get an extra reference on the
>> inode so it can safely batch.  igrab will go ahead and take the global
>> inode spinlock, which can be a bottleneck on large machines doing lots
>> of AIO.
>> 
>> In this case, igrab isn't required because we already have a reference
>> on the file handle.  It is safe to just bump the i_count directly
>> on the inode.
>> 
>> Benchmarking shows this patch brings IOP/s on tons of flash up by about
>> 2.5X.
>
> There's some places in XFS where we do the same, and it showed up as a
> bottle neck before.  Instead of open coding the increment we have
> a wrapper that includes and assert that the numbers is always positive.
>
> I think we really want a proper helper for general use instead of
> completly opencoding it.

Well, it would make detecting races or invalid assumptions a little
easier.  If Chris wants to code that up, that's fine with me.  Honestly,
though, I don't think it's necessary.

I've gone through the alloc/free paths for the inode and I'm convinced
this is safe.  I'm happy with this version of the patch.

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
