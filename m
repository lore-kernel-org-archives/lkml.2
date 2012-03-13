Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248Ab2CMLV6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 07:21:58 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:39849 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288Ab2CMLV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 07:21:56 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Trond.Myklebust@netapp.com,
        sfrench@samba.org, sage@newdream.net, ericvh@gmail.com
Subject: Re: [PATCH 06/25] vfs: add i_op->atomic_create()
References: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
	<1331155362-11132-7-git-send-email-miklos@szeredi.hu>
	<20120313093720.GC11797@infradead.org>
Date: Tue, 13 Mar 2012 12:22:10 +0100
In-Reply-To: <20120313093720.GC11797@infradead.org> (Christoph Hellwig's
	message of "Tue, 13 Mar 2012 05:37:20 -0400")
Message-ID: <87lin49259.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

> On Wed, Mar 07, 2012 at 10:22:23PM +0100, Miklos Szeredi wrote:
>> From: Miklos Szeredi <mszeredi@suse.cz>
>> 
>> Add a new inode operation which is called on regular file create.  This is a
>> replacement for ->create() which allows the file to be opened atomically with
>> creation.
>> 
>> This function is also called for non-open creates (mknod(2)) with a NULL file
>> argument.  Only one of ->create or ->atomic_create will be called, implementing
>> both makes no sense.
>> 
>> The functionality of this method partially overlaps that of ->atomic_open().
>> FUSE and 9P only use ->atomic_create, NFS, CIFS and CEPH use both.
>
> I really don't like the special casing of the mknod handling in every
> atomic_create instance.  Either we should keep ->create for it, or do a
> cleanup pass before to always make that pass go through ->mknod - in
> fact most filesystems handle the two in common code anyway so we might
> be able to get rid of one of them, possible mkdir as well.

Good point.  Yes, ->create is probably worth getting rid of.  Mkdir, I'm
not so sure, but I'll look at what filesystems are doing.

Thanks,
Miklos
