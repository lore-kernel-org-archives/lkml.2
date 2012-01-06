Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758851Ab2AFRFU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 12:05:20 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:48346 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758790Ab2AFRFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 12:05:18 -0500
MIME-Version: 1.0
In-Reply-To: <201201061619.43584.arnd@arndb.de>
References: <CA+55aFyzqCVwpuRNOt8a=fdoDq_khsbSHBs6cT=TLuzQ7ixwgg@mail.gmail.com>
 <201201061619.43584.arnd@arndb.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 6 Jan 2012 09:04:56 -0800
X-Google-Sender-Auth: PBTxQsX6-FNE3ElBuWoszuxCffw
Message-ID: <CA+55aFxAhn8eqXnXKsxFK+DS_jYfPw7mzdsZHgWUu5ibRvyVMw@mail.gmail.com>
Subject: Re: Broken ioctl error returns (was Re: [PATCH 2/3] block: fail SCSI
 passthrough ioctls on partition devices)
To: Arnd Bergmann <arnd@arndb.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org, Willy Tarreau <w@1wt.eu>,
        linux-kernel@vger.kernel.org, security@kernel.org, pmatouse@redhat.com,
        agk@redhat.com, jbottomley@parallels.com, mchristi@redhat.com,
        msnitzer@redhat.com, Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 6, 2012 at 8:19 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>
> For a simpler solution, we could keep the old warning message, but change
> the logic from
>
> (.compat_ioctl == NULL || .compat_ioctl() == -ENOIOCTL) && (no generic handler)
>
> to
>
> (.ioctl != NULL && .compat_ioctl == NULL) && (no generic handler).
>
> and then fix the warnings we see by adding appropriate .compat_ioctl
> functions.

So I have no problem with that. What I did have problems with was the
net/socket.c kind of workarounds (which I noticed mainly because they
had that whole EINVAL confusion built into them). Those were why I
decided that the warning has to go.

But if you can re-introduce the warning without workarounds like
those, I have no problem with us reintroducing the warning, even if it
is technically not really kosher and will afaik still print that
warning for the case of a compat-ioctl transform that *would* have
been valid, just not for that particular file descriptor.

But the printout is small and not all that annoying, and explicitly
limited in number, so I guess I don't mind a few false positives if it
really can help find stale translation entries.

                       Linus
