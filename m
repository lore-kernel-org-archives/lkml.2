Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752Ab1GTBkW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 21:40:22 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:37976 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab1GTBkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 21:40:20 -0400
Date: Wed, 20 Jul 2011 02:40:14 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: NeilBrown <neilb@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] vfs: fix race in rcu lookup of pruned dentry
Message-ID: <20110720014014.GV11013@ZenIV.linux.org.uk>
References: <alpine.LSU.2.00.1107181135170.2722@sister.anvils>
 <CA+55aFycZL9zAE_Qvq9LM=HpugiDuKSjdRhKG1zi=H4LnNvhVQ@mail.gmail.com>
 <20110718194703.GI11013@ZenIV.linux.org.uk>
 <CA+55aFzCeXOs9Rj5U5mMWqMZpv+jM14O2VnpFCodMJzaB1hPEg@mail.gmail.com>
 <alpine.LSU.2.00.1107181407060.3530@sister.anvils>
 <CA+55aFxq1KZycxXCwLARv0WOYG_-aim=e9kt=eLcNuymmeoyiA@mail.gmail.com>
 <20110719234550.GR11013@ZenIV.linux.org.uk>
 <20110719235215.GS11013@ZenIV.linux.org.uk>
 <20110719235515.GT11013@ZenIV.linux.org.uk>
 <20110720104721.03a2a2f0@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110720104721.03a2a2f0@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 20, 2011 at 10:47:21AM +1000, NeilBrown wrote:
> > > 
> > > Kudos to neilb for spotting the pointless check, BTW; and no, his theory
> > > that it might be needed since we could race with umount() is wrong - due to
> > > vfsmount_lock being held.
> 
> Thanks.. but that patch seems to introduce an unused variable "seq".
> 
> NeilBrown

Grr...  I can amend and push again, of course, but I've no idea if Linus
has already pulled into his tree ;-/  Still not there in tree on hera,
but that's not saying much.  Linus?
