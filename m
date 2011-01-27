Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748Ab1A0Q5h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 11:57:37 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:58202 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752522Ab1A0Q5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 11:57:36 -0500
Subject: Re: flex_array related problems on selinux policy loading
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Eric Paris <eparis@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
In-Reply-To: <20110127124647.GF3070@secunet.com>
References: <20110120122659.GD4639@secunet.com>
	 <1295537330.9039.583.camel@nimitz> <20110121072022.GA3070@secunet.com>
	 <1295625455.9039.3326.camel@nimitz> <20110126130407.GD3070@secunet.com>
	 <1296058526.7567.57.camel@nimitz>  <20110127124647.GF3070@secunet.com>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Thu, 27 Jan 2011 08:57:29 -0800
Message-ID: <1296147449.7567.5780.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-27 at 13:46 +0100, Steffen Klassert wrote:
> On Wed, Jan 26, 2011 at 08:15:26AM -0800, Dave Hansen wrote:
> > On Wed, 2011-01-26 at 14:04 +0100, Steffen Klassert wrote:
> > > Another thing came to my mind. An atempt to do a zero size allocation
> > > always succeed on kmalloc. If we want to allocate our metadata even in
> > > this case, we should be aware that this allocation _can_ fail. So
> > > flex_array_alloc would not show the same behaviour as kmalloc on zero
> > > size allocations.
> > 
> > I think that's just fine.
> > 
> > You have to check for and handle those allocation failures anyway.  
> 
> If we just return a pointer to the user that notifies that this was a
> zerro size allocation, we would not need to allocate anything (like
> kmalloc does), so we can't get allocation failures.

Could you point me to some of this code?  I'm having a hard time seeing
how this is going to get used, and I don't see any use of
ZERO_SIZE_PTR/ZERO_OR_NULL_PTR() outside of the sl*b code.

-- Dave

