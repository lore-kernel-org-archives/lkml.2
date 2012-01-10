Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932419Ab2AJQua (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 11:50:30 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:54849 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932114Ab2AJQu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 11:50:29 -0500
MIME-Version: 1.0
X-Originating-IP: [94.21.63.111]
In-Reply-To: <CA+55aFxKzDQgsHMuWdSarqak68-NVqJkjjxAh2jbVgkrXm7-eg@mail.gmail.com>
References: <87ipkl87m9.fsf@tucsk.pomaz.szeredi.hu>
	<20120109171639.GA9359@infradead.org>
	<20120109173010.GX23916@ZenIV.linux.org.uk>
	<CA+55aFwikQQrpGoyxvY+y=B8NfKBSdcAnKME+xZh+N1TQfp8LA@mail.gmail.com>
	<20120109205907.GE4198@dastard>
	<CA+55aFxN+Yh_M=P8cVbGcuHGo+PgcXm1bOFAJQ-5_euqU9LOww@mail.gmail.com>
	<20120110013434.GA23916@ZenIV.linux.org.uk>
	<CA+55aFzGe6sG0QotpqGpmNJ-HXqMxR5ocmXzvO2wdN_-MnARfA@mail.gmail.com>
	<CAJfpegu6BrLbmMSbf0QnKRe5rq0HgZYtYBEW8F+qehZC9GpQ8w@mail.gmail.com>
	<CA+55aFxszjhj5MatYe_KXJ=vYyf-05kzBbtmY1vgoGUio0DXuQ@mail.gmail.com>
	<CAJfpegszrDO112d9A3PLsMY1+NnRpqFoLzODABnMq_VZq=DWFw@mail.gmail.com>
	<CA+55aFxKzDQgsHMuWdSarqak68-NVqJkjjxAh2jbVgkrXm7-eg@mail.gmail.com>
Date: Tue, 10 Jan 2012 17:50:28 +0100
Message-ID: <CAJfpegvTPH9_KpJxYDbOU7YzsB=Uq=d706iGJK21BRy_UoWF=w@mail.gmail.com>
Subject: Re: [RFC PATCH] shrink_dcache_parent() deadlock
From: Miklos Szeredi <miklos@szeredi.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, mgorman@suse.de, gregkh@suse.de,
        akpm@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 10, 2012 at 5:33 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> Hmm. Even if they are never run in parallel, I think it would be much
> nicer to do it in both, just so that there would be a conceptual
> consistency of "when we remove the dentry from the LRU list and put it
> on our pruning list, we set the bit". That cacheline will be dirty
> anyway (due to the list move and getting the dentry lock), so setting
> a bit is not expensive - but having odd inconsistent ad-hoc rules is
> nasty.

Makes sense.

I'm testing the modified patch right now and will post shortly.

Thanks,
Miklos
