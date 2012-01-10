Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536Ab2AJSEd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 13:04:33 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:59442 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303Ab2AJSEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 13:04:31 -0500
Date: Tue, 10 Jan 2012 18:04:21 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, mgorman@suse.de, gregkh@suse.de,
        akpm@linux-foundation.org
Subject: Re: [RFC PATCH] shrink_dcache_parent() deadlock
Message-ID: <20120110180421.GC23916@ZenIV.linux.org.uk>
References: <20120109171639.GA9359@infradead.org>
 <20120109173010.GX23916@ZenIV.linux.org.uk>
 <CA+55aFwikQQrpGoyxvY+y=B8NfKBSdcAnKME+xZh+N1TQfp8LA@mail.gmail.com>
 <20120109205907.GE4198@dastard>
 <CA+55aFxN+Yh_M=P8cVbGcuHGo+PgcXm1bOFAJQ-5_euqU9LOww@mail.gmail.com>
 <20120110013434.GA23916@ZenIV.linux.org.uk>
 <CA+55aFzGe6sG0QotpqGpmNJ-HXqMxR5ocmXzvO2wdN_-MnARfA@mail.gmail.com>
 <CAJfpegu6BrLbmMSbf0QnKRe5rq0HgZYtYBEW8F+qehZC9GpQ8w@mail.gmail.com>
 <CA+55aFxszjhj5MatYe_KXJ=vYyf-05kzBbtmY1vgoGUio0DXuQ@mail.gmail.com>
 <CAJfpegszrDO112d9A3PLsMY1+NnRpqFoLzODABnMq_VZq=DWFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegszrDO112d9A3PLsMY1+NnRpqFoLzODABnMq_VZq=DWFw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 10, 2012 at 05:22:22PM +0100, Miklos Szeredi wrote:

> I think prune_dcache_sb() doesn't need this logic (although it
> wouldn't hurt either) because that one is called from the slab
> shrinkers and those are protected from being run multiple times in
> parallel, I hope.

	Eh...  We already have too much convoluted logics in there, so
let's keep it as non-subtle as possible.
