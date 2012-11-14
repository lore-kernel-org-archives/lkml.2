Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932876Ab2KNJvN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 04:51:13 -0500
Received: from claranet-outbound-smtp05.uk.clara.net ([195.8.89.38]:36299 "EHLO
	claranet-outbound-smtp05.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932782Ab2KNJvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 04:51:11 -0500
From: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org
Subject: Re: [patch 3/7] fs, notify: Add file handle entry into inotify_inode_mark
Date: Wed, 14 Nov 2012 09:50:55 +0000
Message-ID: <19056257.kzSp6roqV4@deuteros>
User-Agent: KMail/4.8.4 (Linux/3.4.6-2.fc17.x86_64; KDE/4.8.4; x86_64; ; )
In-Reply-To: <20121114093849.GE16685@moon>
References: <20121112101440.665694060@openvz.org> <4242534.oR1fYvhZDe@deuteros> <20121114093849.GE16685@moon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 November 2012 13:38:49 Cyrill Gorcunov wrote:
> On Wed, Nov 14, 2012 at 09:20:51AM +0000, Tvrtko Ursulin wrote:
> > On Tuesday 13 November 2012 19:28:46 Cyrill Gorcunov wrote:
> > > On Tue, Nov 13, 2012 at 03:02:22PM +0000, Tvrtko Ursulin wrote:
> > > > Perhaps there could be a different way, where you could use additional
> > > > space only when it is actually used at runtime. But as I said, I am
> > > > not
> > > > following closely.
> > > 
> > > Unfortunatelly at moment I see no way how to make it in on-demand
> > > fashion.
> > 
> > You could not use a pointer and then allocate your buffers on the check
> > point operation, freeing on restore?
> 
> The problem is not allocating the memory itself but rather the time when the
> information needed (ie the dentry) is available. The only moment when we
> can use dentry of the target file/directory is at inotify_new_watch, that's
> why i need to compose fhandle that early. At any later point we simply have
> no dentry to use.

But you do not fundamentally need the dentry to restore a watch, right? 
Couldn't you restore, creating a new restore path if needed, using the inode 
which is pinned anyway while the watch exists?

Regards,

Tvrtko

