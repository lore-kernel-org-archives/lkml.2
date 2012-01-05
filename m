Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008Ab2AERjC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 12:39:02 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:65334 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab2AERjA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 12:39:00 -0500
MIME-Version: 1.0
In-Reply-To: <4F05DD37.6010407@redhat.com>
References: <CA+55aFyzqCVwpuRNOt8a=fdoDq_khsbSHBs6cT=TLuzQ7ixwgg@mail.gmail.com>
 <4F05DD37.6010407@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 5 Jan 2012 09:38:37 -0800
X-Google-Sender-Auth: 32Xm7lOdmWMTaZqjxnK5-6TgOgE
Message-ID: <CA+55aFygZYYTVN2OL7zcwOkKMXU+rUCb=fmfH6GNMru+ZfbCXw@mail.gmail.com>
Subject: Re: Broken ioctl error returns (was Re: [PATCH 2/3] block: fail SCSI
 passthrough ioctls on partition devices)
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
        Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org,
        security@kernel.org, pmatouse@redhat.com, agk@redhat.com,
        jbottomley@parallels.com, mchristi@redhat.com, msnitzer@redhat.com,
        Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 5, 2012 at 9:26 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> On 01/05/2012 06:02 PM, Linus Torvalds wrote:
>>
>> +       return  ret == -EINVAL ||
>> +               ret == -ENOTTY ||
>> +               ret == ENOIOCTLCMD;
>
>
> Missing minus before ENOIOCTLCMD.

Oops, thanks, fixed.

Also, I do realize that the patch results in a warning about
"compat_ioctl_error()" no longer being used. I've removed it in my
tree, but I do wonder if we could perhaps have some kind of better
check, so maybe it is useful if somebody can come up with a saner way
to do it. Or at least a way that doesn't cause the kind of crazy code
that net/socket.c had.

And I notice that not only net/socket.c had workarounds for the bogus
warning, but fs/compat_ioctl.c itself does too: it's why we have those
IGNORE_IOCTL() entries.

So *maybe* we can reinstate that compat_ioctl_error() check, and just
remove the net/socket.c stuff, and make sure that all the ioctls that
net/socket.c had hacks for are mentioned as IGNORE_IOCTL's. Dunno.

Anybody have strong opinions either way? Has that printout helped
compat ioctl debugging a lot lately and we really want to maintain it?
Otherwise I'm inclined to remove it (we can always reinstate it later,
it's not like removal is necessarily final).

                            Linus
