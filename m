Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932573Ab2CZNrK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 09:47:10 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:54011 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932456Ab2CZNrI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 09:47:08 -0400
MIME-Version: 1.0
X-Originating-IP: [178.164.220.0]
In-Reply-To: <20120326133028.GA8436@infradead.org>
References: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
	<1331155362-11132-4-git-send-email-miklos@szeredi.hu>
	<20120324141251.GA25980@infradead.org>
	<CAJfpegu8byHvPk3_KM3f1HE0dyaytVtsjZcUH5RB4pfwbQHEYA@mail.gmail.com>
	<20120326133028.GA8436@infradead.org>
Date: Mon, 26 Mar 2012 15:47:07 +0200
Message-ID: <CAJfpegvNKRF1D34K7QLCFcLSfcyRhx8w=G5xkopj1npE__+SAg@mail.gmail.com>
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

On Mon, Mar 26, 2012 at 3:30 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Mon, Mar 26, 2012 at 03:22:09PM +0200, Miklos Szeredi wrote:
>> > I think the O_DIRECT checks should move out of the VFS. ??The direct I/O
>> > method isn't called from the VFS anywhere, but just from the
>> > generic_file_* routines in filemap.c, which suggest doing the O_DIRECT
>> > check in there as well.
>>
>> Returning the error at the earliest opportunity (from open as opposed
>> to read/write) makes sense.  Given that some apps may actually rely on
>> the return value from open to verify O_DIRECT support, it doesn't seem
>> to be a good idea to move the checks to read/write.
>
> I'm fine with keeping it in open, bu it should be in generic_file_open,
> not in the VFS (and yeah, generic_file_open is in open.c not filemap.c
> where it should be, sorry)

Unfortunately a lot of filesystems that use generic_file_aio_foo()
don't actually call generic_file_open() in their ->open method.  And
it would be difficult to enforce.

Thanks,
Miklos
