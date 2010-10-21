Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758041Ab0JUNh5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 09:37:57 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:59769 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756998Ab0JUNhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 09:37:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: Remaining BKL users, what to do
Date: Thu, 21 Oct 2010 15:38:24 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
        Evgeniy Dushistov <dushistov@mail.ru>, Jan Kara <jack@suse.cz>
References: <201009161632.59210.arnd@arndb.de> <20101021124743.GC17654@infradead.org>
In-Reply-To: <20101021124743.GC17654@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010211538.24733.arnd@arndb.de>
X-Provags-ID: V02:K0:FAqivy3Y5shVo0GCbZY6wBsfxd18Rc51v++ypN3LaLi
 JyYOoIEty15fQGiS2Ex2wiWzjZt8ue9CXE/zxV/JTEKvPGLXEo
 u3qY3PTa6rwljQpipbdk9n+iGCf1DgRPTFPSRPCLF2zVPcEXJK
 0JdlFl8/db2EawekGV2JemaSBZftL0UTEvUU4jGqTIH02ktev9
 jffOwUJJFkpWZ5o1Ck+bw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 October 2010, Christoph Hellwig wrote:
> On Thu, Sep 16, 2010 at 04:32:59PM +0200, Arnd Bergmann wrote:
> > fs/freevxfs:
> > 	Uses the BKL in readdir and lookup, should be easy to fix. Christoph?
> 
> Can simply be dropped.  Ditto for ->put_super and the not yet done
> ->get_sb pushdown.  It's a trivial read-only filesystem with no state
> of it's own.

Cool, thanks for looking at it. I'll add a patch to my series.

> > 
> > fs/hpfs:
> > 	Looks fixable, if anyone cares. Maybe it's time for retirement in
> > 	drivers/staging though. The web page only has a Link to the
> > 	linux-2.2 version.
> 
> Di you ping Mikulas?  He's not done too lately but at least ACKed a few
> patches.

He was on Cc on all these mails, maybe he got overwhelmed by the amount
of mail.

> > fs/ncpfs:
> > 	Should be fixable if Petr still cares about it. Otherwise suggest
> > 	moving to drivers/staging if there are no users left.
> 
> Didn't he fix it recently?

Yes, see my update "[v2] Remaining BKL users, what to do". Note that the
mail you just replied to is a month old.

> > fs/qnx4:
> > 	Should be easy to fix, there are only a few places in the code that
> > 	use the BKL. Anders?
> 
> Another trivial read-only fs.  Can be trivially dropped.

ok.

> > fs/ufs:
> > 	Evgeniy Dushistov is maintaining this, I hope he can take care of
> > 	getting rid of the BKL in UFS.
> 
> Did you ping him.  Shouldn't be too hard despite your probably unfixable
> comment that somehow made it to linux-next.

He was on Cc as well. I'll update the comment and others that have become
obsolete now. I didn't realize that this was a read-only fs, which certainly
makes it easier.

Thanks,

	Arnd
