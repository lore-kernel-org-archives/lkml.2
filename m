Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761443Ab2C3Ty3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 15:54:29 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:59427 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761382Ab2C3TyZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 15:54:25 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwFkeR8pNo7dF1gr0VPD9hr+9zB8zoc_byvMxSzr2WEZw@mail.gmail.com>
References: <20120330175106.GB755@shiny> <CA+55aFwFkeR8pNo7dF1gr0VPD9hr+9zB8zoc_byvMxSzr2WEZw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 30 Mar 2012 12:54:03 -0700
X-Google-Sender-Auth: ufsZYhSQYHg3pEdovlVWiAMi0aM
Message-ID: <CA+55aFyn0TL6vJZrGVQkgAscT33nf9_7rH-DRVJbcG3K7d7QKA@mail.gmail.com>
Subject: Re: [GIT PULL] Btrfs fixes and features
To: Chris Mason <chris.mason@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2012 at 12:50 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> This causes a new warning for me:
>
>  fs/btrfs/extent_io.c: In function ‘repair_eb_io_failure’:
>  fs/btrfs/extent_io.c:1940:6: warning: ‘ret’ may be used
> uninitialized in this function
>
> Hmm?

Ok, so presumably num_pages (which is "num_extent_pages(eb->start,
eb->len)") cannot be zero, so I guess the code is ok. But gcc can't
know that, and it's an annoying warning.

So please fix, but it's not urgent. In the meantime I've pulled and pushed out.

                    Linus
