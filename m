Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227Ab1KUWNe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 17:13:34 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62576 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692Ab1KUWNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 17:13:33 -0500
Date: Mon, 21 Nov 2011 14:13:22 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Christoph Hellwig <hch@infradead.org>
cc: Josef Bacik <josef@redhat.com>, Kay Sievers <kay.sievers@vrfy.org>,
        Cong Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Pekka Enberg <penberg@kernel.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Lennart Poettering <lennart@poettering.net>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org
Subject: Re: [V2 PATCH] tmpfs: add fallocate support
In-Reply-To: <20111121101059.GB17887@infradead.org>
Message-ID: <alpine.LSU.2.00.1111211405121.1879@sister.anvils>
References: <1321612791-4764-1-git-send-email-amwang@redhat.com> <20111119100326.GA27967@infradead.org> <CAPXgP10q8Fba3vr0zf-XBBaRPwjP7MyJ=-QRL45_8WC-vtotOg@mail.gmail.com> <alpine.LSU.2.00.1111201322310.1264@sister.anvils>
 <20111121101059.GB17887@infradead.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Nov 2011, Christoph Hellwig wrote:
> On Sun, Nov 20, 2011 at 01:39:12PM -0800, Hugh Dickins wrote:
> 
> > But since the present situation is that tmpfs has one interface to
> > punching holes, madvise(MADV_REMOVE), that IBM were pushing 5 years ago;
> > but ext4 (and others) now a fallocate(FALLOC_FL_PUNCH_HOLE) interface
> > which IBM have been pushing this year: we do want to normalize that
> > situation and make them all behave the same way.
> 
> FALLOC_FL_PUNCH_HOLE was added by Josef Bacik, who happens to work for
> Red Hat, but I doubt he was pushing any corporate agenda there, he was
> mostly making btrfs catch up with the 15 year old XFS hole punching
> ioctl.

Yeah, my apologies to Josef and to IBM and to XFS
for my regrettable little outburst of snarkiness :(

> 
> 
> > And if tmpfs is going to support fallocate(FALLOC_FL_PUNCH_HOLE),
> > looking at Amerigo's much more attractive V2 patch, it would seem
> > to me perverse to permit the deallocation but fail the allocation.
> 
> Agreed.

Thanks a lot for useful info, and saving me looking up the ENOSPC issue.

Hugh
