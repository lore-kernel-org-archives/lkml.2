Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476Ab2KTAtl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 19:49:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53094 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049Ab2KTAtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 19:49:39 -0500
Date: Mon, 19 Nov 2012 16:49:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org, oleg@redhat.com,
        rientjes@google.com, tvrtko.ursulin@onelan.co.uk,
        Andrey Vagin <avagin@openvz.org>
Subject: Re: [patch 7/7] fs, notify: Add procfs fdinfo helper v6
Message-Id: <20121119164938.7f19f3d9.akpm@linux-foundation.org>
In-Reply-To: <20121117083437.GC22855@moon>
References: <20121114151937.344922058@openvz.org>
	<20121114152239.936025193@openvz.org>
	<20121116155603.2118394c.akpm@linux-foundation.org>
	<20121117071039.GA22855@moon>
	<20121117083437.GC22855@moon>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 Nov 2012 12:34:37 +0400
Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> On Sat, Nov 17, 2012 at 11:10:39AM +0400, Cyrill Gorcunov wrote:
> > > 
> > > What happens if we do something like the below (which will require a
> > > changelog update)?
> > 
> > Looks good for me, Andrew. The only reason for such whitespace rich format
> > was to make output column aligned. But it's fine to have name:val as well.
> > I'll update. Thanks!
> 
> Andrew, here is a patch which contains and your change, and changelog update
> and one fix (you've lost %lx for ino number thus compiler warns me about
> missing specificator). Also the inotify/fanotify at first position on the
> line (without dash, as you propose, ie inotify-wd) applies to the whole line,
> that's why I didn't use dashes in first place.

Oh, I see.

>  | pos:	0
>  | flags:	02000000
>  | inotify wd:3 ino:9e7e sdev:800013 mask:800afce ignored_mask:0 fhandle-bytes:8 fhandle-type:1 f_handle:7e9e0000640d1b6d

It's still a bit strange, isn't it?  The "inotify" identifier doesn't
have the colon.  I guess it's unavoidable, as this multiple-name-value
line is being mixed into the same pseudo-file as single name-value lines.

Where *is* this pseudo-file, anyway?  The changelog doesn't tell us
where it lies in the filesystem.

I know!  I'll search the documentation!  /proc/sys/fs/epoll/..., yes?

btw, Documentation/sysctl/fs.txt is missing documentation for
max_user_instances and max_queued_events.  Perhaps you can fix that
when providing the documentation changes for your patch :)

