Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755733Ab0JSREm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 13:04:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44190 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753402Ab0JSREj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 13:04:39 -0400
MIME-Version: 1.0
In-Reply-To: <20101019165530.GT19804@ZenIV.linux.org.uk>
References: <20101019011650.25346.99614.stgit@paris.rdu.redhat.com>
 <AANLkTimGdjPyLXuknDNa7WNthDT9+2FdOuPdxwjRiMHD@mail.gmail.com>
 <1287506215.2530.187.camel@localhost.localdomain> <20101019165530.GT19804@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 19 Oct 2010 10:03:48 -0700
Message-ID: <AANLkTimL=eChoCQHGoiouE5s6dGG=n9ZAQGhW-RW+gDj@mail.gmail.com>
Subject: Re: [PATCH 1/3] IMA: move read/write counters into struct inode
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@infradead.org, zohar@us.ibm.com, warthog9@kernel.org,
        david@fromorbit.com, jmorris@namei.org, kyle@mcmartin.ca,
        hpa@zytor.com, akpm@linux-foundation.org, mingo@elte.hu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 9:55 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> a) i_writecount is about VM_DENYWRITE, basically.  Reusing it for ima could
> get unpleasant; when it's positive, we are fine, but it can get negative as
> well.  IMA will have interesting time dealing with that.
>
> b) i_count is simply a refcount for struct inode.  Not exactly the number
> of dentries, but that's the main contributor.  Basically, that's "how many
> pointers outside of inode hash chains point that that struct inode at the
> moment".

My question was deeper. More along the lines of "why would IMA care?"

How/why could IMA ever care about the pointless and trivial
differences between its current private open/read/write counts and the
counts that we already maintain?

Yes, yes, I realize that they have technical differences in what they
count. That's not the question. The question is "Why would IMA care?"

                       Linus
