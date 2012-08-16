Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757010Ab2HPKI7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 06:08:59 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:62859 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756529Ab2HPKIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 06:08:55 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: NeilBrown <neilb@suse.de>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, viro@ZenIV.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, apw@canonical.com, nbd@openwrt.org,
        jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu, ricwheeler@gmail.com,
        dhowells@redhat.com, hpj@urpla.net, sedat.dilek@googlemail.com,
        penberg@kernel.org, goran.cetusic@gmail.com, romain@orebokech.com
Subject: Re: [PATCH 01/13] vfs: add i_op->open()
References: <1345045700-9062-1-git-send-email-miklos@szeredi.hu>
	<1345045700-9062-2-git-send-email-miklos@szeredi.hu>
	<20120815172150.GA25062@fieldses.org>
	<20120816062832.36a48cb0@notabene.brown>
Date: Thu, 16 Aug 2012 12:10:16 +0200
In-Reply-To: <20120816062832.36a48cb0@notabene.brown> (NeilBrown's message of
	"Thu, 16 Aug 2012 06:28:32 +1000")
Message-ID: <871uj7du5z.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NeilBrown <neilb@suse.de> writes:

> On Wed, 15 Aug 2012 13:21:50 -0400 "J. Bruce Fields" <bfields@fieldses.org>
> wrote:
>
>> On Wed, Aug 15, 2012 at 05:48:08PM +0200, Miklos Szeredi wrote:
>> > From: Miklos Szeredi <mszeredi@suse.cz>
>> > 
>> > Add a new inode operation i_op->open().  This is for stacked
>> 
>> Shouldn't that "->open()" be "->dentry_open()" ?
>> 
>> --b.
>> 
>> > filesystems that want to return a struct file from a different
>> > filesystem.
>> > 
>> > Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
>> > ---
>> >  Documentation/filesystems/Locking |    2 ++
>> >  Documentation/filesystems/vfs.txt |    7 +++++++
>> >  fs/namei.c                        |    9 ++++++---
>> >  fs/open.c                         |   23 +++++++++++++++++++++--
>> >  include/linux/fs.h                |    2 ++
>> >  5 files changed, 38 insertions(+), 5 deletions(-)
>> > 
>> > diff --git a/Documentation/filesystems/Locking b/Documentation/filesystems/Locking
>> > index 0f103e3..d222b6a 100644
>> > --- a/Documentation/filesystems/Locking
>> > +++ b/Documentation/filesystems/Locking
>> > @@ -64,6 +64,7 @@ prototypes:
>> >  	int (*atomic_open)(struct inode *, struct dentry *,
>> >  				struct file *, unsigned open_flag,
>> >  				umode_t create_mode, int *opened);
>> > +	int (*dentry_open)(struct dentry *, struct file *, const struct cred *);
>> >  
>> >  locking rules:
>> >  	all may block
>> > @@ -92,6 +93,7 @@ removexattr:	yes
>> >  fiemap:		no
>> >  update_time:	no
>> >  atomic_open:	yes
>> > +open:		no
>> >  
>
> and that last line should be
>     +dentry_open:       no
> ??

Yes.

Thanks,
Miklos
