Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161043Ab2KNJ6U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 04:58:20 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:37670 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187Ab2KNJ6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 04:58:18 -0500
Date: Wed, 14 Nov 2012 13:58:12 +0400
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
Message-ID: <20121114095812.GF16685@moon>
References: <20121112101440.665694060@openvz.org>
 <4242534.oR1fYvhZDe@deuteros>
 <20121114093849.GE16685@moon>
 <19056257.kzSp6roqV4@deuteros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19056257.kzSp6roqV4@deuteros>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2012 at 09:50:55AM +0000, Tvrtko Ursulin wrote:
> > > You could not use a pointer and then allocate your buffers on the check
> > > point operation, freeing on restore?
> > 
> > The problem is not allocating the memory itself but rather the time when the
> > information needed (ie the dentry) is available. The only moment when we
> > can use dentry of the target file/directory is at inotify_new_watch, that's
> > why i need to compose fhandle that early. At any later point we simply have
> > no dentry to use.
> 
> But you do not fundamentally need the dentry to restore a watch, right? 

dentry only needed to encode the file handle.

> Couldn't you restore, creating a new restore path if needed, using the inode 
> which is pinned anyway while the watch exists?

plain inode is not enough as far as i can tell, iow i don't see the way
to restore path from inode solely. or there something i miss?

	Cyrill
