Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988Ab1AaIIb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 03:08:31 -0500
Received: from a.mx.secunet.com ([195.81.216.161]:52320 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751616Ab1AaIIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 03:08:30 -0500
Date: Mon, 31 Jan 2011 09:08:26 +0100
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Eric Paris <eparis@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: flex_array related problems on selinux policy loading
Message-ID: <20110131080826.GJ3070@secunet.com>
References: <20110120122659.GD4639@secunet.com>
 <1295537330.9039.583.camel@nimitz>
 <20110121072022.GA3070@secunet.com>
 <1295625455.9039.3326.camel@nimitz>
 <20110126102328.GC3070@secunet.com>
 <1296058216.7567.21.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296058216.7567.21.camel@nimitz>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 31 Jan 2011 08:08:26.0618 (UTC) FILETIME=[09B445A0:01CBC11E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 08:10:16AM -0800, Dave Hansen wrote:
> 
> > If we would make
> > flex_array of dynamic size, say metadata plus the maximum size of the array
> > in the case that the metadata and the array fit into a single page, and
> > metadata plus space for all the base pointers we need to dereference the
> > parts, if the metadata and array is beyond page size. With this, the struct
> > flex_array would have a reasonable size in any case, even if the array to
> > store is small or of zero size.
> 
> Sounds like a good idea to me.  Done right, it should only really affect
> the allocation path since we use kmalloc() already, and we can still
> plain kfree() it.
> 


I started to look into making flex_array of dynamic size.
There are al lot of structural changes necessary, so I think this
is too much just to fix a zero size allocation bug. So
lets fix it like you proposed it by allocating the flex_array
in any case and accept that it will be of PAGE_SIZE by now.
Making flex_array of dynamic size can wait for 2.6.39 I think.

Steffen
