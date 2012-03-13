Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800Ab2CMPLX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 11:11:23 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:65207 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753602Ab2CMPLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 11:11:21 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: "Myklebust\, Trond" <Trond.Myklebust@netapp.com>
Cc: "viro\@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
        "linux-fsdevel\@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch\@infradead.org" <hch@infradead.org>,
        "sfrench\@samba.org" <sfrench@samba.org>,
        "sage\@newdream.net" <sage@newdream.net>,
        "ericvh\@gmail.com" <ericvh@gmail.com>
Subject: Re: [PATCH 04/25] vfs: add i_op->atomic_open()
References: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
	<1331155362-11132-5-git-send-email-miklos@szeredi.hu>
	<1331649485.3419.12.camel@lade.trondhjem.org>
Date: Tue, 13 Mar 2012 16:11:35 +0100
In-Reply-To: <1331649485.3419.12.camel@lade.trondhjem.org> (Trond Myklebust's
	message of "Tue, 13 Mar 2012 14:38:05 +0000")
Message-ID: <87y5r47cyg.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Myklebust, Trond" <Trond.Myklebust@netapp.com> writes:

> On Wed, 2012-03-07 at 22:22 +0100, Miklos Szeredi wrote:
>> +
>> +	if ((nd->flags & LOOKUP_OPEN) && dir_inode->i_op->atomic_open) {
>> +		struct file *filp;
>> +
>> +		filp = atomic_open(nd, dentry, op, want_write, &create_error);
>> +		if (filp) {
>> +			dput(dentry);
>> +			return filp;
>> +		}
>> +		/* fall back to plain lookup */
>> +	}
>
> Would it be possible to allow the filesystem to return a new dentry even
> if it can't complete the actual open? That way we can return the actual
> symlink that caused the open to fail instead of looking it up separately
> (which may be subject to races).

This should be possible, but I'm reluctant to add more arguments to
->atomic_open.  Other possibilites that come to mind:

  return -ELOOKEDUP - caller should retry d_lookup and proceed with the result

  call opendata_set_dentry(od, dentry) and return NULL - caller checks
  opendata for non-NULL dentry and proceeds with that

Thanks,
Miklos
