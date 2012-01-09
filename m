Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562Ab2AIVWI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 16:22:08 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:34668 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab2AIVWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 16:22:05 -0500
MIME-Version: 1.0
In-Reply-To: <20120109205907.GE4198@dastard>
References: <87ipkl87m9.fsf@tucsk.pomaz.szeredi.hu> <20120109171639.GA9359@infradead.org>
 <20120109173010.GX23916@ZenIV.linux.org.uk> <CA+55aFwikQQrpGoyxvY+y=B8NfKBSdcAnKME+xZh+N1TQfp8LA@mail.gmail.com>
 <20120109205907.GE4198@dastard>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 9 Jan 2012 13:21:43 -0800
X-Google-Sender-Auth: wXFqq1_05EUVVFCD6HIo4NJfYC8
Message-ID: <CA+55aFxN+Yh_M=P8cVbGcuHGo+PgcXm1bOFAJQ-5_euqU9LOww@mail.gmail.com>
Subject: Re: [RFC PATCH] shrink_dcache_parent() deadlock
To: Dave Chinner <david@fromorbit.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>,
        Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, mgorman@suse.de, gregkh@suse.de,
        akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 9, 2012 at 12:59 PM, Dave Chinner <david@fromorbit.com> wrote:
>
>> It compiles. That's all I'm going to say about my extensive testing.
>> Which is also why I haven't added my sign-off to it.
>
> I did quite a bit of load and stress testing on the series back when
> I first posted it, so the dcache changes don't have any problems I
> know of.

.. and from the kernel compiles and looking at the code some more
today, I'm getting more and more convinced that the patch is
absolutely the right thing to do.

So I'll happily add my signed-off on that code if Al wants to take
that edited patch into his tree. Or just commit it directly.

I'd like to hear that it fixes Miklos' case from somebody that
recreated it - that bonding_masters script doesn't work for me because
I compile or use (nor do I compile or use the soft-lockup detector),
so it would be good if somebody who has the particular test-case
working (or "not working" ;) for them to verify that yes, it fixes it.

But I think I agree with the explanation for why it would be fixed,
and I certainly agree with the code being cleaner.

                      Linus
