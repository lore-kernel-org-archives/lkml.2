Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049Ab2EAOIZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 10:08:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54599 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755991Ab2EAOIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 10:08:19 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Nick Piggin <npiggin@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        jaxboe@fusionio.com, Kyle McMartin <kmcmarti@redhat.com>
Subject: Re: [patch|rfc] block: don't mark buffers beyond end of disk as mapped
References: <x49pqaom2u4.fsf@segfault.boston.devel.redhat.com>
	<CAPa8GCAgDU8FYdMuWsn2PuUW0GQxdKWJV6K0SmQEzb3s1GHxwA@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 01 May 2012 10:08:16 -0400
In-Reply-To: <CAPa8GCAgDU8FYdMuWsn2PuUW0GQxdKWJV6K0SmQEzb3s1GHxwA@mail.gmail.com>
	(Nick Piggin's message of "Wed, 2 May 2012 00:01:36 +1000")
Message-ID: <x49lilcm1tb.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <npiggin@gmail.com> writes:

> Not a bad fix. But it's kind of sad to have i_size checking logic also in
> block_read_full_page, that does not cope with this.
>
> I have found there are parts of the kernel (readahead) that try to read
> beyond EOF and seem to get angry if we return an error (by not
> marking uptodate in readpage) in that case though :(
>
> But, either way, I think it's very reasonable to not mark buffers beyond
> end of device as mapped. So I think your patch is fine.
>
> I guess for ext[234], it does not read metadata close to the end of the
> device or you were using 4K sized blocks?

Well, the test case just reads directly from the loop device, bypassing
the file system, and I did use 1KB blocks when making the file system, so
it is quite puzzling.

Thanks for taking a look, Nick.

Cheers,
Jeff
