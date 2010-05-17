Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848Ab0EQJEV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 05:04:21 -0400
Received: from submit1.sa.ew.hu ([212.108.200.71]:43815 "EHLO submit1.sa.ew.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754197Ab0EQJEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 05:04:20 -0400
X-Greylist: delayed 621 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 May 2010 05:04:20 EDT
Message-ID: <4BF10420.5040707@dunaweb.hu>
Date: Mon, 17 May 2010 10:53:52 +0200
From: Zoltan Boszormenyi <zboszor@dunaweb.hu>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCHSET] libata: implement ->set_capacity()
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> On Thu, May 13 2010, Tejun Heo wrote:
> > Hello,
> > 
> > On 05/13/2010 06:06 PM, James Bottomley wrote:
> > > I'm not sure this is such a good interface ... it sounds very error
> > > prone for what is effectively a binary lock/unlock.
> > 
> > Well, the original block interface was like that.  It has been used as
> > binary switch tho.  The requested capacity is always ~0ULL and return
> > value smaller than the current capacity is ignored.  I'm all for
> > dropping the capacity parameter and the return value from
> > ->set_capacity() so that it just unlocks native capacity and directly
> > sets the new capacity.  Jens?
>
> Is there a valid case for setting the capacity less than the unlocked
> capacity? I would think the unlock/lock bool api is saner.
>
> -- 
> Jens Axboe
>   

I heard about a so called "short stroking", that limits a larger capacity
harddisk to say one third or one fourth of the capacity but the gains are
increased average throughput and decreased seek time. Is it possible
under Linux ATM, or do we need the patch series to correctly do it?

I know I can partition the harddisk to only use the beginning of it
to have the same gains, but I still have a question: as I read on e.g.
tomshardware.com, this is done by instructing the harddisk, not via
partitioning. Does this "short stroking" change the amount of spare
sectors available internally to SATA disks? I suppose it would and
so the harddisk would only lose some speed not actual data when
the disk starts aging. I would have more time to discover the
problem and replace the disk, no? I am only asking...

Best regards,
Zoltán Böszörményi

