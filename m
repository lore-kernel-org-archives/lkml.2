Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565Ab0H3MU7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 08:20:59 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:58315 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755534Ab0H3MU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 08:20:58 -0400
To: Neil Brown <neilb@suse.de>
CC: miklos@szeredi.hu, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, vaurora@redhat.com,
        viro@zeniv.linux.org.uk, jblunck@suse.de, hch@infradead.org
In-reply-to: <20100830214027.77e197f5@notabene> (message from Neil Brown on
	Mon, 30 Aug 2010 21:40:27 +1000)
Subject: Re: [PATCH 0/5] hybrid union filesystem prototype
References: <20100826183340.027591901@szeredi.hu>
	<20100827170551.19616048@notabene>
	<E1Ooub5-0007Wh-SQ@pomaz-ex.szeredi.hu>
	<20100827213502.31af4a4c@notabene>
	<E1Op2BV-0008Ut-BR@pomaz-ex.szeredi.hu>
	<20100829144207.4fbf2713@notabene>
	<E1Oq1RL-0003zF-Tw@pomaz-ex.szeredi.hu> <20100830214027.77e197f5@notabene>
Message-Id: <E1Oq3Lz-0004D8-MP@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 30 Aug 2010 14:20:47 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Aug 2010, Neil Brown wrote:

> > You didn't mention one possibility: add limitations that prevent the
> > weird corner cases arising.  I believe this is the simplest option.
> 
> Val has been following that approach and asking if it is possible to make an
> NFS filesystem really-truly read-only. i.e. no changes.
> I don't believe it is.

Perhaps it doesn't matter.  The nasty cases can be prevented by just
disallowing local modification.  For the rest NFS will return ESTALE:
"though luck, why didn't you follow the rules?"

> > I think *notify will work correctly, every modificaton will be
> > notified on both the union fs and the upper fs.  But I haven't tested
> > this yet.
> 
> I tried.  It doesn't.
> To be precise:  directory changes like file creation (even creation of a file
> that already exists) get notified, but purely file-based event like modifying
> the contents of the file don't generate events back to the overlayfs
> directory.
> Because an open (for write) of a file is passed through to the upper
> filesystem, the notifications of modification through that open only go to the
> upper filesystem.

Ah, right.

> > > I think the way to fix this would involve the union-fs putting a
> > > notifier on the upper dir to match whatever is on the
> > > merged-dir.  However the filesystem currently isn't told when
> > > notifiers are attach to an inode.  I think it would be good to
> > > add an inode_operation which is called whenever the notifiers
> > > are changed.  This would also allow a networked filesystem to
> > > report notification if the protocol supported it.  Does that
> > > seem reasonable?

In that light this sounds entirely reasonable.

Thanks,
Miklos
