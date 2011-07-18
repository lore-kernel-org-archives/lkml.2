Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001Ab1GRTUo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 15:20:44 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54657 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754786Ab1GRTUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 15:20:43 -0400
Date: Mon, 18 Jul 2011 20:20:38 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] vfs: fix race in rcu lookup of pruned dentry
Message-ID: <20110718192038.GG11013@ZenIV.linux.org.uk>
References: <20110717231610.GR11013@ZenIV.linux.org.uk>
 <CA+55aFxEGKgx+_xy+Lnt=84wRzE9TyznL3VCNSqWs7HC_H35_A@mail.gmail.com>
 <alpine.LSU.2.00.1107171641130.1274@sister.anvils>
 <20110718002524.GU11013@ZenIV.linux.org.uk>
 <alpine.LSU.2.00.1107171740260.1327@sister.anvils>
 <20110718020818.GW11013@ZenIV.linux.org.uk>
 <CA+55aFwXgcWxvAz7w1f_HYyzdm9b9EBJfrWhF1FW7EA3zpbJPg@mail.gmail.com>
 <CA+55aFxKRw8NxcHKzsSeCX3ud6eDrcQvAX+LMQOUT4p5TPLp5g@mail.gmail.com>
 <20110718182030.GF11013@ZenIV.linux.org.uk>
 <CA+55aFw+RwscYUocP0WYWTU=F+Udx+AsjMA0i63-D-y3iZKCTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw+RwscYUocP0WYWTU=F+Udx+AsjMA0i63-D-y3iZKCTQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 18, 2011 at 12:08:04PM -0700, Linus Torvalds wrote:

> But I do agree that it's very unlikely to actually cause problems.
> People just don't move mount points around, and the race would seem to
> be ridiculously hard to ever hit even if you tried to create some
> totally artificial load that does nothing but rename mount-points ;)

vfs_rename() will refuse to move mountpoints.  Required by POSIX, among
other things...

> But I think I'm on the same page with Hugh that at this point none of
> these issues are even remotely recent, they are basically impossible
> to hit, and the fixes are likely potentially more dangerous than the
> bugs they fix, so I'll release 3.0 without them and just apply the
> fixes (and cc stable) afterwards.

Hmm...  Could you pull #for-linus (or #for-linus2, for that matter - same
plus cifs_get_root() fix) first?
