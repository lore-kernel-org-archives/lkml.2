Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758477Ab2BJJB1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 04:01:27 -0500
Received: from mail.mnsspb.ru ([84.204.75.2]:37226 "EHLO mail.mnsspb.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753419Ab2BJJB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 04:01:26 -0500
Date: Fri, 10 Feb 2012 13:04:25 +0400
From: Kirill Smelkov <kirr@mns.spb.ru>
To: Paul Parsons <lost.distance@yahoo.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Kay Sievers <kay.sievers@vrfy.org>,
        linux-kernel@vger.kernel.org
Subject: Re: No /dev/root with devtmpfs?
Message-ID: <20120210090425.GA3997@tugrik.mns.mnsspb.ru>
References: <20120208073559.GA3163@tugrik.mns.mnsspb.ru>
 <1328719440.33661.YahooMailClassic@web29013.mail.ird.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328719440.33661.YahooMailClassic@web29013.mail.ird.yahoo.com>
Organization: Marine Bridge & Navigation Systems
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 08, 2012 at 04:44:00PM +0000, Paul Parsons wrote:
> --- On Wed, 8/2/12, Kirill Smelkov <kirr@mns.spb.ru> wrote:
> > "On what disk/partition was / mounted?" is a well-defined
> > question for
> > cases when backing store is local hdd, so there should be
> > well-defined
> > answer.
> > 
> > Previously it was /dev/root, but if /dev/root is not good
> > there should be
> > some other way for getting the answer. With ext2 I've
> > switched to
> > `mountpoint -d /` and then grepping major/minor in
> > /proc/partitions, but
> > with major=0 case I suspect this won't work.
> > 
> > 
> > My use case is to check md5 sum of mbr + bootloader area +
> > root-partition early right after the boot, to verify whether
> > software is
> > not corrupt, and for doing so it was useful to know / ->
> > root-partition
> > -> whole block device. It's not tivo, just checking for
> > medium damage. (I
> > understand this would be better done in the early bootloader
> > but that
> > part is out of my control)
> 
> Could you simply use /etc/fstab to identify the root partition?

Unfortunately no, because /etc/fstab can't know where the card will be
inserted to boot this time - i.e. either in compactflash slot on
motherboard, or through usb via cardreader. So root has to be determined
at runtime.

Personally I'm ok with no /dev/root symlink as long as there is another
way to detect root blkdev reliably. And I'm still confised what's the
rationale about why this can't be done for modern filesysems.


Thanks,
Kirill
