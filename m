Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975Ab2AIAZa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 19:25:30 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:60817 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754762Ab2AIAZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 19:25:29 -0500
Date: Mon, 9 Jan 2012 00:25:26 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miklos Szeredi <mszeredi@suse.cz>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: Re: [git pull] vfs pile 1
Message-ID: <20120109002526.GS23916@ZenIV.linux.org.uk>
References: <20120105022318.GG23916@ZenIV.linux.org.uk>
 <CA+55aFw+7xvfP3NCr5p2Ma--UTb7zT+QQxtjCn3V2SU_g3LUdA@mail.gmail.com>
 <20120108235039.GQ23916@ZenIV.linux.org.uk>
 <20120108235338.GR23916@ZenIV.linux.org.uk>
 <CA+55aFzqfne7xs-M3qkZYs=wFmCJBL43AFcywRg3dc1S=8qK6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzqfne7xs-M3qkZYs=wFmCJBL43AFcywRg3dc1S=8qK6A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 08, 2012 at 04:11:17PM -0800, Linus Torvalds wrote:
> On Sun, Jan 8, 2012 at 3:53 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > ... and sure enough, ext3 has the same piece of fun.
> 
> Hmm. Do we want to have the s_remove_count games for this "temporarily
> zero nlink" case? Maybe we don't want to do drop_nlink/set_nlink? Does
> it matter?

The thing is, the total result in case of failure should be drop_nlink
with s_remove_count bumped.  We could turn that into
	set i_nlink to 0, without touching s_remove_count
	write the body
	if failed, bump s_remove_count and bugger off
	otherwise set i_nlink to 1, without touching s_remove_count
but that's far more intrusive change than what I posted.

> Anyway, mind sending me a patch with changelog and sign-off?

Sure, will do.  I have several more fixes in my tree right now (including
such gems as double kfree() in devpts on mount failure ;-/), so I'll send
a pull request in a couple of hours anyway.  Would you be OK with having
that patch in the same pile?
