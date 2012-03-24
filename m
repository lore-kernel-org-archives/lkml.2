Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443Ab2CXPig (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 11:38:36 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:42744 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836Ab2CXPie convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 11:38:34 -0400
MIME-Version: 1.0
X-Originating-IP: [178.164.220.0]
In-Reply-To: <20120324142752.GE25980@infradead.org>
References: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
	<1331155362-11132-22-git-send-email-miklos@szeredi.hu>
	<20120324142752.GE25980@infradead.org>
Date: Sat, 24 Mar 2012 16:38:33 +0100
Message-ID: <CAJfpegu3GZSp+sXCird+oo58+yWO4daAOQ_9sSL1Q_mctxEybA@mail.gmail.com>
Subject: Re: [PATCH 21/25] gfs2: use i_op->atomic_create()
From: Miklos Szeredi <miklos@szeredi.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Trond.Myklebust@netapp.com,
        sfrench@samba.org, sage@newdream.net, ericvh@gmail.com,
        mszeredi@suse.cz
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 24, 2012 at 3:27 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Wed, Mar 07, 2012 at 10:22:38PM +0100, Miklos Szeredi wrote:
>> From: Miklos Szeredi <mszeredi@suse.cz>
>>
>> GFS2 doesn't open the file in ->create, but it does check the LOOKUP_EXCL flag
>> in it's create function.  Convert to using ->atomic_create and checking O_EXCL
>> so that the nameidata argument is no longer necessary.
>
> It seems odd that we require implementing ->atomic_create even if we
> don't actually do an atomic create but just want to look at the flags.
>
> In fact I wonder if we really need to bother with having ->atomic_create
> and ->create, or if we should have one method (kinda contra my previous
> stance that ->atomic_open and ->atomic_create should be one).
>
> This method then could or could not return a file pointer, but it would
> always be the entry point for creates.

Yes, except I thought of the pain of converting all those returns to
ERR_PTR and left the old ->create instead.

Maybe I should just byte the bullet or do that, having a single return
point for those functions shouldn't be that difficult to do.

Thanks,
Miklos
