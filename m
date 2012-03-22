Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030627Ab2CVPJu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 11:09:50 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48026 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030385Ab2CVPJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 11:09:47 -0400
Date: Thu, 22 Mar 2012 15:09:45 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        David Safford <safford@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Matt Helsley <matt.helsley@gmail.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH v3 10/12] ima: defer calling __fput()
Message-ID: <20120322150945.GW6589@ZenIV.linux.org.uk>
References: <1332356057-3356-1-git-send-email-zohar@linux.vnet.ibm.com>
 <1332356057-3356-11-git-send-email-zohar@linux.vnet.ibm.com>
 <20120322142212.GV6589@ZenIV.linux.org.uk>
 <1332427986.2218.53.camel@falcor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332427986.2218.53.camel@falcor>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2012 at 10:53:04AM -0400, Mimi Zohar wrote:
> > BTW, you've missed several other places in mm/* doing fput(), so it wouldn't
> > be enough to paper over your problem anyway.
> > 
> > Final fput() *can* happen under mmap_sem.  Period.
> 
> I think I got that loud and clear; otherwise we wouldn't have come up
> with deferring the __fput().  We have a very real problem here - writing
> extended attributes requires taking the i_mutex.

Don't do it, then?  If you _must_ write to xattr on final fput, I'd suggest
starting to figure out if xattr needs its protection to be ->i_mutex - it
might make sense to introduce a separate mutex for xattr crap.  Or not - I'm
not familiar enough with the guts of xattr handling in individual filesystems
to tell if that would work (e.g. if it would need unpleasant changes to
->setattr() instances)...
