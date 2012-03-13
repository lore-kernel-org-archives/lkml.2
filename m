Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab2CMN0R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 09:26:17 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:49490 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954Ab2CMN0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 09:26:15 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Trond.Myklebust@netapp.com,
        sfrench@samba.org, sage@newdream.net, ericvh@gmail.com
Subject: Re: [PATCH 06/25] vfs: add i_op->atomic_create()
References: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
	<1331155362-11132-7-git-send-email-miklos@szeredi.hu>
	<20120313093720.GC11797@infradead.org>
	<87lin49259.fsf@tucsk.pomaz.szeredi.hu>
	<20120313115552.GA21043@infradead.org>
Date: Tue, 13 Mar 2012 14:26:28 +0100
In-Reply-To: <20120313115552.GA21043@infradead.org> (Christoph Hellwig's
	message of "Tue, 13 Mar 2012 07:55:52 -0400")
Message-ID: <87haxs8we3.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

> On Tue, Mar 13, 2012 at 12:22:10PM +0100, Miklos Szeredi wrote:
>> Good point.  Yes, ->create is probably worth getting rid of.  Mkdir, I'm
>> not so sure, but I'll look at what filesystems are doing.
>
> Btw, is there any good reason to keep ->atomic_open and ->atomic_create
> separate?  It seems like the instances in general share code anyway.

->atomic_open is called before lookup, ->atomic_create after lookup.

How would we differentiate between the two if they were common?  We
could have a filesystem flag, but for example CEPH does weird things
like using ->atomic_open for !O_CREAT and ->atomic_create for O_CREAT.

Thanks,
Miklos
