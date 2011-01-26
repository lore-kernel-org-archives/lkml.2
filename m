Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382Ab1AZQRi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 11:17:38 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:53739 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752732Ab1AZQRg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 11:17:36 -0500
Subject: Re: flex_array related problems on selinux policy loading
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Eric Paris <eparis@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
In-Reply-To: <20110126130407.GD3070@secunet.com>
References: <20110120122659.GD4639@secunet.com>
	 <1295537330.9039.583.camel@nimitz> <20110121072022.GA3070@secunet.com>
	 <1295625455.9039.3326.camel@nimitz>  <20110126130407.GD3070@secunet.com>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Wed, 26 Jan 2011 08:15:26 -0800
Message-ID: <1296058526.7567.57.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-26 at 14:04 +0100, Steffen Klassert wrote:
> Another thing came to my mind. An atempt to do a zero size allocation
> always succeed on kmalloc. If we want to allocate our metadata even in
> this case, we should be aware that this allocation _can_ fail. So
> flex_array_alloc would not show the same behaviour as kmalloc on zero
> size allocations.

I think that's just fine.

You have to check for and handle those allocation failures anyway.  Can
you think of places in the kernel where we have known-zero-sized
allocations that don't check kmalloc() returns?

> As most potential flex_array users convert their code
> from kmalloc, the behaviour of flex_array_alloc should be the same as of
> kmalloc. Showing a different behaviour here will produce pitfalls for
> potential new users. Also, to tell a user that we can not allocate memory
> for him, if the wants to allocate 0 byte (nothing) is quite odd. This
> user could easily continue processing, even if we can not allocate our
> metadata in this moment.

This doesn't have to be a one to one, direct, replacement for kmalloc().
As long as it's close enough not to confuse people or normally cause
problems, I think it's fine.
-- Dave

