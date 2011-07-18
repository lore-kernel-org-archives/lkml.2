Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892Ab1GRXkR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 19:40:17 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33854 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab1GRXkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 19:40:15 -0400
Date: Tue, 19 Jul 2011 00:40:12 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] vfs: fix race in rcu lookup of pruned dentry
Message-ID: <20110718234012.GL11013@ZenIV.linux.org.uk>
References: <alpine.LSU.2.00.1107181135170.2722@sister.anvils>
 <CA+55aFycZL9zAE_Qvq9LM=HpugiDuKSjdRhKG1zi=H4LnNvhVQ@mail.gmail.com>
 <20110718194703.GI11013@ZenIV.linux.org.uk>
 <CA+55aFzCeXOs9Rj5U5mMWqMZpv+jM14O2VnpFCodMJzaB1hPEg@mail.gmail.com>
 <alpine.LSU.2.00.1107181407060.3530@sister.anvils>
 <CA+55aFxq1KZycxXCwLARv0WOYG_-aim=e9kt=eLcNuymmeoyiA@mail.gmail.com>
 <alpine.LSU.2.00.1107181533590.3909@sister.anvils>
 <20110718231738.GJ11013@ZenIV.linux.org.uk>
 <20110718232114.GK11013@ZenIV.linux.org.uk>
 <CA+55aFzAK52MZXs1ZAdJhnKgnO8OnzUggvS67VUP4mgiYHi5kQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzAK52MZXs1ZAdJhnKgnO8OnzUggvS67VUP4mgiYHi5kQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 18, 2011 at 04:27:53PM -0700, Linus Torvalds wrote:
> On Mon, Jul 18, 2011 at 4:21 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > Linus, are you OK with me slapping your s-o-b on it?
> 
> Yup.
> 
> And it feels so right that I think we should just do it for 3.0.
> 
> I was planning on doing that today, but I guess can delay it too. I'm
> at the Intel tech days tomorrow and the day after, but there's WiFi
> there and I'll have my laptop. The slightly bigger problem is that it
> will move the next merge window even further into my upcoming
> vacation, but I was planning on having the laptop with me there too,
> so whatever...
> 
> I assume I'll get the cifs_get_root() fix at the same time.

Yes.  Maybe btrfs get_default_root() one as well, if it survives beating;
also a missing i_mutex, along with seriously wrong use of d_splice_alias()
(it ignores the return value, for starters, and assumes that inode will
not be found in icache once all dentries pointing to it are off the alias
list)
