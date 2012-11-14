Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161080Ab2KNKJK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 05:09:10 -0500
Received: from claranet-outbound-smtp04.uk.clara.net ([195.8.89.37]:49042 "EHLO
	claranet-outbound-smtp04.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161008Ab2KNKJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 05:09:08 -0500
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
Date: Wed, 14 Nov 2012 10:08:51 +0000
Message-ID: <2105540.yeyMVrW4mH@deuteros>
User-Agent: KMail/4.8.4 (Linux/3.4.6-2.fc17.x86_64; KDE/4.8.4; x86_64; ; )
In-Reply-To: <20121114095812.GF16685@moon>
References: <20121112101440.665694060@openvz.org> <19056257.kzSp6roqV4@deuteros> <20121114095812.GF16685@moon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 November 2012 13:58:12 Cyrill Gorcunov wrote:
> On Wed, Nov 14, 2012 at 09:50:55AM +0000, Tvrtko Ursulin wrote:
> > > > You could not use a pointer and then allocate your buffers on the
> > > > check
> > > > point operation, freeing on restore?
> > > 
> > > The problem is not allocating the memory itself but rather the time when
> > > the information needed (ie the dentry) is available. The only moment
> > > when we can use dentry of the target file/directory is at
> > > inotify_new_watch, that's why i need to compose fhandle that early. At
> > > any later point we simply have no dentry to use.
> > 
> > But you do not fundamentally need the dentry to restore a watch, right?
> 
> dentry only needed to encode the file handle.
> 
> > Couldn't you restore, creating a new restore path if needed, using the
> > inode which is pinned anyway while the watch exists?
> 
> plain inode is not enough as far as i can tell, iow i don't see the way
> to restore path from inode solely. or there something i miss?

I don't know, as I said I was not following this at all until now. Just 
throwing in ideas.

I thought, since inotify does not use the path or dentry outside the system 
call at all, perhaps you need a different entry point allowing you to restore 
the watch using the inode or something. Assuming life time of objects and 
stuff in C&R world would allow you that. Since you don't need the full path, 
just something 64 bytes long, I assumed that could be the case.
 
Regards,

Tvrtko

