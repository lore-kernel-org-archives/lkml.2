Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621Ab2AERrt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 12:47:49 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:63699 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab2AERrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 12:47:47 -0500
MIME-Version: 1.0
In-Reply-To: <4F05DFF0.3000809@infradead.org>
References: <CA+55aFyzqCVwpuRNOt8a=fdoDq_khsbSHBs6cT=TLuzQ7ixwgg@mail.gmail.com>
 <4F05DFF0.3000809@infradead.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 5 Jan 2012 09:47:26 -0800
X-Google-Sender-Auth: IWZGlw-sRLgXVhxBztqFGiR93pg
Message-ID: <CA+55aFyDJ5PJ75R_bSaV5KCpLANmNwCjCA=mYj4g+H+35NQSNQ@mail.gmail.com>
Subject: Re: Broken ioctl error returns (was Re: [PATCH 2/3] block: fail SCSI
 passthrough ioctls on partition devices)
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-media@vger.kernel.org,
        Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org,
        security@kernel.org, pmatouse@redhat.com, agk@redhat.com,
        jbottomley@parallels.com, mchristi@redhat.com, msnitzer@redhat.com,
        Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 5, 2012 at 9:37 AM, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
>
> For the media drivers, we've already fixed it, at the V4L side:
> -EINVAL doesn't mean that an ioctl is not supported anymore.
> I think that such fix went into Kernel 3.1.

Ok, I'm happy to hear that the thing should be fixed. My grepping
still found a fair amount of EINVAL returns both in code and in the
Documentation subdirectory for media ioctls, but it really was just
grepping with a few lines of context, so I didn't look closer at the
semantics. I was just looking for certain patterns (ie grepping for
"EINVAL" near ioctl or ENOIOCTLCMD etc) that I thought might indicate
problem spots, and the media subdirectory had a lot of them.

Can you test the patch with some media capture apps (preferably with
the obvious fix for the problem that Paulo already pointed out -
although that won't actually matter until some block driver starts
using ENOIOCTLCMD there, so even the unfixed patch should mostly work
for testing)?

                              Linus
