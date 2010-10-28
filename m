Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758896Ab0J1WqU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 18:46:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37074 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753305Ab0J1WqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 18:46:14 -0400
Subject: Re: [PATCH 0/4] IMA: making i_readcount a first class inode citizen
From: Eric Paris <eparis@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, hch@infradead.org, warthog9@kernel.org,
        jmorris@namei.org, kyle@mcmartin.ca, hpa@zytor.com,
        akpm@linux-foundation.org, mingo@elte.hu, viro@zeniv.linux.org.uk,
        Matthew Wilcox <matthew@wil.cx>
In-Reply-To: <AANLkTimG6o66SFHskkDOtLqYeSzwKt2c0jR3CWe+sd2w@mail.gmail.com>
References: <1288303325-9628-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <20101028222404.GG2715@dastard>
	 <AANLkTimG6o66SFHskkDOtLqYeSzwKt2c0jR3CWe+sd2w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Oct 2010 18:45:07 -0400
Message-ID: <1288305907.3017.1.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-28 at 15:29 -0700, Linus Torvalds wrote:
> On Thu, Oct 28, 2010 at 3:24 PM, Dave Chinner <david@fromorbit.com> wrote:
> >
> > Why the wrapper functions and locking? Why not an atomic variable like
> > i_writecount?
> 
> Indeed. With moving this more into the VFS, let's just make sure it
> looks like i_writecount as much as possible.

My thought was that the IMA read/write checks should happen AFTER the
i_writecount and i_readcount counters were updated.  Thus even if we
raced with another task we can rest assured that the other task would
catch the situation we missed....

-Eric

