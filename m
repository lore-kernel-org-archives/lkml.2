Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753Ab0DKSmf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 14:42:35 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34578 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387Ab0DKSmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 14:42:33 -0400
Date: Sun, 11 Apr 2010 20:42:27 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Avi Kivity <avi@redhat.com>, Ben Gamari <bgamari.foss@gmail.com>,
       Andi Kleen <andi@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, tytso@mit.edu, npiggin@suse.de,
       Ingo Molnar <mingo@elte.hu>, Ruald Andreae <ruald.a@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>, Olly Betts <olly@survex.com>,
       martin f krafft <madduck@madduck.net>
Subject: Re: Poor interactive performance with I/O loads with fsync()ing
Message-ID: <20100411184227.GL18855@one.firstfloor.org>
References: <4b9fa440.12135e0a.7fc8.ffffe745@mx.google.com> <4baeaee5.c5c2f10a.7187.2688@mx.google.com> <20100327204233.0d84542a@infradead.org> <4baf624c.48c3f10a.16d0.ffffccb8@mx.google.com> <87y6hcyu85.fsf@basil.nowhere.org> <4bbf401e.a3b9e70a.13f3.4460@mx.google.com> <4BC1E4A4.1070103@redhat.com> <alpine.LFD.2.00.1004112014520.18009@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1004112014520.18009@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> XFS does not do much better. Just moved my VM images back to ext for
> that reason.

Did you move from XFS to ext3?  ext3 defaults to barriers off, XFS on,
which can make a big difference depending on the disk. You can
disable them on XFS too of course, with the known drawbacks.

XFS also typically needs some tuning to get reasonable log sizes.

My point was merely (before people chime in with counter examples) 
that XFS/btrfs/jfs don't suffer from the "need to sync all transactions for
every fsync" issue. There can (and will be) still other issues.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
