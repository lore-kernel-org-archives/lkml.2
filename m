Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898Ab1AUOnX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 09:43:23 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33584 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734Ab1AUOnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 09:43:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        b=U/QB06mhqyQQGfY3UIww/WjlZwjyi7AGTrjOFAUog18XOp7Q+nRS4mSXq4JcUrDA7t
         Px8ozT36Ao333PMx90kn+PUPlJb3yQpf3O4S1cIkJEtdeWkhxCevw3X67xb+Hyz/2g+0
         Lm2Jb6Us7wEAGsmEeIfK7TthstCWm4OW7wu1U=
Date: Fri, 21 Jan 2011 14:43:14 +0000 (GMT)
From: Stuart Swales <stuart.swales.croftnuisk@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Stuart Swales <stuart.swales.croftnuisk@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] adfs: add hexadecimal filetype suffix option
In-Reply-To: <20110119154915.a0bb2878.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1101211434210.3490@dc5850.croftnuisk.local>
References: <4D2DEDDB.1070605@gmail.com> <20110119154915.a0bb2878.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 19 Jan 2011, Andrew Morton wrote:

> On Wed, 12 Jan 2011 18:07:23 +0000
> Stuart Swales <stuart.swales.croftnuisk@gmail.com> wrote:
>
> > From: Stuart Swales<stuart.swales.croftnuisk@gmail.com>
> >
> > ADFS (FileCore) storage complies with the RISC OS filetype specification
> > (12 bits of file type information is stored in the file load address, rather
> > than using a file extension).  The existing driver largely ignores this
> > information and does not present it to the end user.
> >
> > It is desirable that stored filetypes be made visible to the end user to
> > facilitate a precise copy of data and metadata from a hard disc (or image
> > thereof) into a RISC OS emulator (such as RPCEmu) or to a network share which
> > can be accessed by real Acorn systems.
> >
> > This patch implements a per-mount filetype suffix option (use -o ftsuffix=1)
> > to present any filetype as a ,xyz hexadecimal suffix on each file.  This type
> > suffix is compatible with that used by RISC OS systems that access network
> > servers using NFS client software and by RPCemu's host filing system.
> >
>
> I don't really understand this.  Are you saying that if a file on an
> adfs partition has name "foo", and one does a `mount -o ftsuffix=1'
> then an `ls' would show "foo,ABC"?
>
> If so, that sounds strange but I assume you know what you're doing.

Yes, indeed it would!  This is needed so we can store RISC OS file type
info on non-native systems.  This has been useful in the past to
share files over NFS and will be useful in future when migrating RISC
OS apps and data over onto virtualized systems such as the RISC OS
emulator RPCemu.


> Was `mount -o remount,ftsuffix=1' implemented and tested?

I didn't specifically check it out with remount.  Is that likely to be a
problem?

> Am I correct in assuming that "mount -o remount,ftsuffix=0" turns this
> off again?
>
> I wonder what are the implications of changing filenames on the fly
> with a remount.


> We have a Documentation/filesystems/adfs.txt.  Please update it.

Done.  Thanks for the pointer.


> Again, the patch was mangled by your email client in some fashion and
> generates 100% rejects.
>
> Please pass the diff through scripts/checkpatch.pl and address and
> warnings which you do not disagree with.


I blame icedove again!

Cheers,

Stuart Swales
