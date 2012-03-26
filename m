Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932483Ab2CZNWM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 09:22:12 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:41942 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932458Ab2CZNWK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 09:22:10 -0400
MIME-Version: 1.0
X-Originating-IP: [178.164.220.0]
In-Reply-To: <20120324141251.GA25980@infradead.org>
References: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
	<1331155362-11132-4-git-send-email-miklos@szeredi.hu>
	<20120324141251.GA25980@infradead.org>
Date: Mon, 26 Mar 2012 15:22:09 +0200
Message-ID: <CAJfpegu8byHvPk3_KM3f1HE0dyaytVtsjZcUH5RB4pfwbQHEYA@mail.gmail.com>
Subject: Re: [PATCH 03/25] vfs: split __dentry_open()
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

On Sat, Mar 24, 2012 at 3:12 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Wed, Mar 07, 2012 at 10:22:20PM +0100, Miklos Szeredi wrote:
>> From: Miklos Szeredi <mszeredi@suse.cz>
>>
>> Split __dentry_open() into two functions:
>>
>>   do_dentry_open() - does most of the actual work, doesn't put file on failure
>>   open_check_o_direct() - after a successful open, checks direct_IO method
>>
>> This will allow i_op->atomic_open to do just the file initialization and leave
>> the direct_IO checking to the VFS.
>
> I think the O_DIRECT checks should move out of the VFS.  The direct I/O
> method isn't called from the VFS anywhere, but just from the
> generic_file_* routines in filemap.c, which suggest doing the O_DIRECT
> check in there as well.

Returning the error at the earliest opportunity (from open as opposed
to read/write) makes sense.  Given that some apps may actually rely on
the return value from open to verify O_DIRECT support, it doesn't seem
to be a good idea to move the checks to read/write.

Thanks,
Miklos
