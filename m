Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176Ab1AaIAZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 03:00:25 -0500
Received: from a.mx.secunet.com ([195.81.216.161]:50331 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752075Ab1AaIAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 03:00:23 -0500
Date: Mon, 31 Jan 2011 09:00:21 +0100
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Eric Paris <eparis@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: flex_array related problems on selinux policy loading
Message-ID: <20110131080021.GI3070@secunet.com>
References: <20110120122659.GD4639@secunet.com>
 <1295537330.9039.583.camel@nimitz>
 <20110121072022.GA3070@secunet.com>
 <1295625455.9039.3326.camel@nimitz>
 <20110126130407.GD3070@secunet.com>
 <1296058526.7567.57.camel@nimitz>
 <20110127124647.GF3070@secunet.com>
 <1296147449.7567.5780.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296147449.7567.5780.camel@nimitz>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 31 Jan 2011 08:00:21.0674 (UTC) FILETIME=[E8A7B0A0:01CBC11C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 27, 2011 at 08:57:29AM -0800, Dave Hansen wrote:
> > > 
> > > You have to check for and handle those allocation failures anyway.  
> > 
> > If we just return a pointer to the user that notifies that this was a
> > zerro size allocation, we would not need to allocate anything (like
> > kmalloc does), so we can't get allocation failures.
> 
> Could you point me to some of this code?  I'm having a hard time seeing
> how this is going to get used, and I don't see any use of
> ZERO_SIZE_PTR/ZERO_OR_NULL_PTR() outside of the sl*b code.
> 

Perhaps I did not express it the right way, but
I did not say that this is used somewhere outside the sl*b code.
All I meant is that we return a pointer, like ZERO_SIZE_PTR
that notifies us that we have not allocated anything if a user
wants to access or to free data. This pointers are just for
internal usage of course.

Steffen
