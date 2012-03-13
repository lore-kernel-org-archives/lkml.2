Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786Ab2CMNjF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 09:39:05 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:46608 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231Ab2CMNjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 09:39:02 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Trond.Myklebust@netapp.com,
        sfrench@samba.org, sage@newdream.net, ericvh@gmail.com
Subject: Re: [PATCH 13/25] cifs: implement i_op->atomic_open() and i_op->atomic_create()
References: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
	<1331155362-11132-14-git-send-email-miklos@szeredi.hu>
	<20120313120649.GB27171@infradead.org>
Date: Tue, 13 Mar 2012 14:39:16 +0100
In-Reply-To: <20120313120649.GB27171@infradead.org> (Christoph Hellwig's
	message of "Tue, 13 Mar 2012 08:06:49 -0400")
Message-ID: <878vj48vsr.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

> On Wed, Mar 07, 2012 at 10:22:30PM +0100, Miklos Szeredi wrote:
>> From: Miklos Szeredi <mszeredi@suse.cz>
>> 
>> Replace CIFS's ->create operation with ->atomic_open and ->atomic_create.  Also
>> move the relevant code from ->lookup into the create function.
>> 
>> CIFS currently only does atomic open for O_CREAT, but it wants to do that as
>> early as possible, without first calling ->lookup, so it uses ->atomic_open,
>> just like NFS.
>
> Why does cifs need to set the created flag from inside ->atomic_open?
>
> It's different from everyone else in that respect.

Apparently CIFS is the only one that can tell whether the file was
created or not.  If the flag is set then notify_create() is called.
Users of NFS doesn't seem to care, it's of dubious value anyway, but why
not use the info when available?

Thanks,
Miklos
