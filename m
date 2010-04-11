Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108Ab0DKV4W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 17:56:22 -0400
Received: from www.tglx.de ([62.245.132.106]:60060 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753021Ab0DKV4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 17:56:21 -0400
Date: Sun, 11 Apr 2010 23:54:34 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: Avi Kivity <avi@redhat.com>, Ben Gamari <bgamari.foss@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, tytso@mit.edu, npiggin@suse.de,
       Ingo Molnar <mingo@elte.hu>, Ruald Andreae <ruald.a@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>, Olly Betts <olly@survex.com>,
       martin f krafft <madduck@madduck.net>
Subject: Re: Poor interactive performance with I/O loads with fsync()ing
In-Reply-To: <20100411184227.GL18855@one.firstfloor.org>
Message-ID: <alpine.LFD.2.00.1004112332380.18009@localhost.localdomain>
References: <4b9fa440.12135e0a.7fc8.ffffe745@mx.google.com> <4baeaee5.c5c2f10a.7187.2688@mx.google.com> <20100327204233.0d84542a@infradead.org> <4baf624c.48c3f10a.16d0.ffffccb8@mx.google.com> <87y6hcyu85.fsf@basil.nowhere.org> <4bbf401e.a3b9e70a.13f3.4460@mx.google.com>
 <4BC1E4A4.1070103@redhat.com> <alpine.LFD.2.00.1004112014520.18009@localhost.localdomain> <20100411184227.GL18855@one.firstfloor.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Apr 2010, Andi Kleen wrote:

> > XFS does not do much better. Just moved my VM images back to ext for
> > that reason.
> 
> Did you move from XFS to ext3?  ext3 defaults to barriers off, XFS on,
> which can make a big difference depending on the disk. You can
> disable them on XFS too of course, with the known drawbacks.
> 
> XFS also typically needs some tuning to get reasonable log sizes.
> 
> My point was merely (before people chime in with counter examples) 
> that XFS/btrfs/jfs don't suffer from the "need to sync all transactions for
> every fsync" issue. There can (and will be) still other issues.

Yes, I moved them back from XFS to ext3 simply because moving them
from ext3 to XFS turned out to be a completely unusable disaster.

I know that I can tweak knobs on XFS (or any other file system), but I
would not have expected that it sucks that much for KVM with the
default settings which are perfectly fine for the other use cases
which made us move to XFS.

Thanks,

	tglx


