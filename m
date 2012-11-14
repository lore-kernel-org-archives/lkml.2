Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932840Ab2KNJi5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 04:38:57 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:40634 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932776Ab2KNJiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 04:38:55 -0500
Date: Wed, 14 Nov 2012 13:38:49 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
Cc: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org
Subject: Re: [patch 3/7] fs, notify: Add file handle entry into
 inotify_inode_mark
Message-ID: <20121114093849.GE16685@moon>
References: <20121112101440.665694060@openvz.org>
 <2176466.A8PC9hQJK4@deuteros>
 <20121113152846.GJ7808@moon>
 <4242534.oR1fYvhZDe@deuteros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4242534.oR1fYvhZDe@deuteros>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2012 at 09:20:51AM +0000, Tvrtko Ursulin wrote:
> On Tuesday 13 November 2012 19:28:46 Cyrill Gorcunov wrote:
> > On Tue, Nov 13, 2012 at 03:02:22PM +0000, Tvrtko Ursulin wrote:
> > > Perhaps there could be a different way, where you could use additional
> > > space only when it is actually used at runtime. But as I said, I am not
> > > following closely.
> > 
> > Unfortunatelly at moment I see no way how to make it in on-demand fashion.
> 
> You could not use a pointer and then allocate your buffers on the check point 
> operation, freeing on restore?

The problem is not allocating the memory itself but rather the time when the
information needed (ie the dentry) is available. The only moment when we can
use dentry of the target file/directory is at inotify_new_watch, that's why
i need to compose fhandle that early. At any later point we simply have no
dentry to use.

	Cyrill
