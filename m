Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759233Ab0J1Wxk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 18:53:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59301 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758771Ab0J1Wxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 18:53:36 -0400
MIME-Version: 1.0
In-Reply-To: <1288305510.2610.13.camel@localhost.localdomain>
References: <1288303325-9628-1-git-send-email-zohar@linux.vnet.ibm.com>
 <20101028222404.GG2715@dastard> <AANLkTimG6o66SFHskkDOtLqYeSzwKt2c0jR3CWe+sd2w@mail.gmail.com>
 <1288305510.2610.13.camel@localhost.localdomain>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 28 Oct 2010 15:46:04 -0700
Message-ID: <AANLkTimvEAj2SL7RrwTdypGA_PYJcZyw8OMBGckWpVs7@mail.gmail.com>
Subject: Re: [PATCH 0/4] IMA: making i_readcount a first class inode citizen
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@infradead.org, warthog9@kernel.org, jmorris@namei.org,
        kyle@mcmartin.ca, hpa@zytor.com, akpm@linux-foundation.org,
        mingo@elte.hu, eparis@redhat.com, viro@zeniv.linux.org.uk,
        Matthew Wilcox <matthew@wil.cx>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 28, 2010 at 3:38 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
>
> Would making i_readcount atomic be enough in ima_rdwr_violation_check(),
> or would it still need to take the spin_lock? IMA needs guarantees
> that the i_readcount/i_writecount won't be updated in between.

If i_writecount is always updated under the i_lock, then the fix is
probably to make that one non-atomic instead. There's no point in
having an atomic that is always updated under a spinlock, that just
makes everything slower.

Regardless, I don't think i_readcount should be different from i_writecount.

Al? Comments?

                  Linus
