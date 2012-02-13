Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293Ab2BMIWl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 03:22:41 -0500
Received: from mail.mnsspb.ru ([84.204.75.2]:47764 "EHLO mail.mnsspb.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978Ab2BMIWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 03:22:40 -0500
Date: Mon, 13 Feb 2012 12:25:39 +0400
From: Kirill Smelkov <kirr@mns.spb.ru>
To: Paul Parsons <lost.distance@yahoo.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Kay Sievers <kay.sievers@vrfy.org>,
        linux-kernel@vger.kernel.org
Subject: Re: No /dev/root with devtmpfs?
Message-ID: <20120213082539.GA5930@tugrik.mns.mnsspb.ru>
References: <20120210090425.GA3997@tugrik.mns.mnsspb.ru>
 <1328879437.80871.YahooMailClassic@web29006.mail.ird.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328879437.80871.YahooMailClassic@web29006.mail.ird.yahoo.com>
Organization: Marine Bridge & Navigation Systems
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 10, 2012 at 01:10:37PM +0000, Paul Parsons wrote:
> --- On Fri, 10/2/12, Kirill Smelkov <kirr@mns.spb.ru> wrote:
> > > Could you simply use /etc/fstab to identify the root
> > partition?
> > 
> > Unfortunately no, because /etc/fstab can't know where the
> > card will be
> > inserted to boot this time - i.e. either in compactflash
> > slot on
> > motherboard, or through usb via cardreader. So root has to
> > be determined
> > at runtime.
> > 
> > Personally I'm ok with no /dev/root symlink as long as there
> > is another
> > way to detect root blkdev reliably. And I'm still confised
> > what's the
> > rationale about why this can't be done for modern
> > filesysems.
> 
> Here's another suggestion: /proc/cmdline
> 
> The bootloader might pass the root partition to the kernel via the
> "root=" kernel parameter; these can be read at /proc/cmdline.
> For example, on an HP iPAQ hx4700: root=/dev/mtdblock2

This does not work universally either, for example for

    root=PARTUUID=00112233-4455-6677-8899-AABBCCDDEEFF


the kernel scans partitions and finds one for root by partition uuid
(see name_to_dev_t() in init/do_mounts.c).

That's exactly my situation - I have universal flash image which can
bee booted via CF slot (on several boards, thus will have different
/dev/hd? or /dev/sd?) and via usb/cardreader (again different /dev/
entry), and root is mounted by partition id.

The kernel has no problem finding root partition and mounting it. I just
needed a sane and robust way to know its choice.


Thanks,
Kirill
