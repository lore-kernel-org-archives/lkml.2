Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059Ab1A0Mqw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 07:46:52 -0500
Received: from a.mx.secunet.com ([195.81.216.161]:47264 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921Ab1A0Mqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 07:46:50 -0500
Date: Thu, 27 Jan 2011 13:46:47 +0100
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Eric Paris <eparis@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: flex_array related problems on selinux policy loading
Message-ID: <20110127124647.GF3070@secunet.com>
References: <20110120122659.GD4639@secunet.com>
 <1295537330.9039.583.camel@nimitz>
 <20110121072022.GA3070@secunet.com>
 <1295625455.9039.3326.camel@nimitz>
 <20110126130407.GD3070@secunet.com>
 <1296058526.7567.57.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296058526.7567.57.camel@nimitz>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 27 Jan 2011 12:46:47.0877 (UTC) FILETIME=[42C72750:01CBBE20]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 08:15:26AM -0800, Dave Hansen wrote:
> On Wed, 2011-01-26 at 14:04 +0100, Steffen Klassert wrote:
> > Another thing came to my mind. An atempt to do a zero size allocation
> > always succeed on kmalloc. If we want to allocate our metadata even in
> > this case, we should be aware that this allocation _can_ fail. So
> > flex_array_alloc would not show the same behaviour as kmalloc on zero
> > size allocations.
> 
> I think that's just fine.
> 
> You have to check for and handle those allocation failures anyway.  

If we just return a pointer to the user that notifies that this was a
zerro size allocation, we would not need to allocate anything (like
kmalloc does), so we can't get allocation failures.

> Can
> you think of places in the kernel where we have known-zero-sized
> allocations that don't check kmalloc() returns?

Usually, if somebody allocates memory he just checks if he got a
NULL pointer. I've never seen somebody checking for ZERO_SIZE_PTR.

> 
> > As most potential flex_array users convert their code
> > from kmalloc, the behaviour of flex_array_alloc should be the same as of
> > kmalloc. Showing a different behaviour here will produce pitfalls for
> > potential new users. Also, to tell a user that we can not allocate memory
> > for him, if the wants to allocate 0 byte (nothing) is quite odd. This
> > user could easily continue processing, even if we can not allocate our
> > metadata in this moment.
> 
> This doesn't have to be a one to one, direct, replacement for kmalloc().
> As long as it's close enough not to confuse people or normally cause
> problems, I think it's fine.

Indeed, it does not have to be one to one. But if we do it different,
we should document the difference somewere at least. I'll do that
once I have an updated patch and I know how the difference will be.

Steffen
