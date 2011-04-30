Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab1D3OS0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 10:18:26 -0400
Received: from legolas.restena.lu ([158.64.1.34]:54084 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548Ab1D3OSY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 10:18:24 -0400
Date: Sat, 30 Apr 2011 16:18:10 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Dave Chinner <david@fromorbit.com>, xfs-masters@oss.sgi.com,
        xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>,
        Alex Elder <aelder@sgi.com>, Dave Chinner <dchinner@redhat.com>,
        linux-kernel@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: 2.6.39-rc3, 2.6.39-rc4: XFS lockup - regression since 2.6.38
Message-ID: <20110430161810.6ccd2c99@neptune.home>
In-Reply-To: <20110429213524.449e003b@neptune.home>
References: <20110423224403.5fd1136a@neptune.home>
	<20110427050850.GG12436@dastard>
	<20110427182622.05a068a2@neptune.home>
	<20110428194528.GA1627@x4.trippels.de>
	<20110429011929.GA13542@dastard>
	<20110429151841.GA893@x4.trippels.de>
	<20110429213524.449e003b@neptune.home>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 April 2011 Bruno Prémont wrote:
> On Fri, 29 April 2011 Markus Trippelsdorf wrote:
> > On 2011.04.29 at 11:19 +1000, Dave Chinner wrote:
> > > OK, so the common elements here appears to be root filesystems
> > > with small log sizes, which means they are tail pushing all the
> > > time metadata operations are in progress. Definitely seems like a
> > > race in the AIL workqueue trigger mechanism. I'll see if I can
> > > reproduce this and cook up a patch to fix it.
> > 
> > Hmm, I'm wondering if this issue is somehow related to the hrtimer bug,
> > that Thomas Gleixner fixed yesterday:
> > http://git.us.kernel.org/?p=linux/kernel/git/tip/linux-2.6-tip.git;a=commit;h=ce31332d3c77532d6ea97ddcb475a2b02dd358b4
> > http://thread.gmane.org/gmane.linux.kernel.mm/61909/
> > 
> > It also looks similar to the issue that James Bottomley reported
> > earlier: http://thread.gmane.org/gmane.linux.kernel.mm/62185/ 
> 
> I'm going to see, I've applied Thomas' fix on the box seeing XFS freeze (without
> other changes to kernel).
> Going to run that kernel for the week-end and beyond if it survives to see what
> happens.

Happened again (after a few hours of uptime), so it definitely is not
caused by hrtimer bug that Thomas Gleixner fixed.

Bruno
