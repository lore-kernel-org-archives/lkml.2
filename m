Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597Ab1GTAE0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 20:04:26 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38229 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395Ab1GTAEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 20:04:24 -0400
Date: Wed, 20 Jul 2011 01:04:21 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] vfs: fix race in rcu lookup of pruned dentry
Message-ID: <20110720000421.GU11013@ZenIV.linux.org.uk>
References: <CA+55aFwXgcWxvAz7w1f_HYyzdm9b9EBJfrWhF1FW7EA3zpbJPg@mail.gmail.com>
 <CA+55aFxKRw8NxcHKzsSeCX3ud6eDrcQvAX+LMQOUT4p5TPLp5g@mail.gmail.com>
 <alpine.LSU.2.00.1107181135170.2722@sister.anvils>
 <CA+55aFycZL9zAE_Qvq9LM=HpugiDuKSjdRhKG1zi=H4LnNvhVQ@mail.gmail.com>
 <20110718194703.GI11013@ZenIV.linux.org.uk>
 <CA+55aFzCeXOs9Rj5U5mMWqMZpv+jM14O2VnpFCodMJzaB1hPEg@mail.gmail.com>
 <alpine.LSU.2.00.1107181407060.3530@sister.anvils>
 <CA+55aFxq1KZycxXCwLARv0WOYG_-aim=e9kt=eLcNuymmeoyiA@mail.gmail.com>
 <20110719234550.GR11013@ZenIV.linux.org.uk>
 <CA+55aFxLidmg=55kfK7peQxgXuvjp-pn2sU5ivpoZ+dwo1-AeQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxLidmg=55kfK7peQxgXuvjp-pn2sU5ivpoZ+dwo1-AeQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 19, 2011 at 04:56:51PM -0700, Linus Torvalds wrote:
> On Tue, Jul 19, 2011 at 4:45 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > You know what... ?I doubt that you want to mess with ->d_seq checks here.
> 
> I'm ok with doing just the "move *inode setting" patch.
> 
> And if we really don't even allow renames of those mounted things, I
> guess the sequence number isn't required.

See vfs_rename_{dir,other}:

        error = -EBUSY;
        if (d_mountpoint(old_dentry) || d_mountpoint(new_dentry))
                goto out;

in both, before even trying to call the method.  Traditional on all
Unices I've ever seen...
