Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665Ab1GZQNW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 12:13:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34847 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751431Ab1GZQNQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 12:13:16 -0400
MIME-Version: 1.0
In-Reply-To: <20110726094901.GA18893@infradead.org>
References: <20110725185649.GA22133@ZenIV.linux.org.uk> <20110726033535.GA11939@x4.trippels.de>
 <CA+55aFzaKHpVdLKac6rFN+YsAugz1aR3fv-reThJiD4HWDND8w@mail.gmail.com>
 <20110726082146.GB11939@x4.trippels.de> <CADxeRwnYxgxZPT3DN=SraZOvL_juWzV+MoY9+0vqZr29y6U6cA@mail.gmail.com>
 <20110726085804.GA1639@x4.trippels.de> <20110726091520.GB1639@x4.trippels.de>
 <20110726093401.GA8334@infradead.org> <20110726094728.GA1629@x4.trippels.de> <20110726094901.GA18893@infradead.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 26 Jul 2011 09:12:25 -0700
Message-ID: <CA+55aFx3PoChMwJKbJkUoMAOvbVU+7JnaNKoyYQFVtD9g6nK1A@mail.gmail.com>
Subject: Re: [PATCH] xfs: Fix build breakage in xfs_iops.c when
 CONFIG_FS_POSIX_ACL is not set
To: Christoph Hellwig <hch@infradead.org>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Steven Liu <lingjiujianke@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 26, 2011 at 2:49 AM, Christoph Hellwig <hch@infradead.org> wrote:
>
> In that case we might as well just throw it in and try it.  In the worst
> case we'll get one expansion per site that takes the address, but no-acl
> builds aren't really something worth optimizing for.

If ACL's are enabled on a system level, but not in XFS, this is more
than a small optimization. It kills the RCU walk entirely if you just
return NULL without setting the cache.

                       Linus
