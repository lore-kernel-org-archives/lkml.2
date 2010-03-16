Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966192Ab0CPNZO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 09:25:14 -0400
Received: from cantor.suse.de ([195.135.220.2]:59721 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966007Ab0CPNZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 09:25:13 -0400
Subject: Re: ATA 4 KiB sector issues.
From: James Bottomley <James.Bottomley@suse.de>
To: Tejun Heo <tj@kernel.org>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, Arnd Bergmann <arnd@arndb.de>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Jeff Garzik <jeff@garzik.org>,
       Mark Lord <kernel@teksavvy.com>, tytso@mit.edu,
       "H. Peter Anvin" <hpa@zytor.com>, hirofumi@mail.parknet.co.jp,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, aschnell@suse.de, knikanth@suse.de,
       jdelvare@suse.de
In-Reply-To: <4B9F2388.2030803@kernel.org>
References: <4B947393.2050002@kernel.org> <201003100046.24695.arnd@arndb.de>
	 <1158166a1003100114j6ea329fbh84bfad65dcac90bf@mail.gmail.com>
	 <4B9EED55.10201@kernel.org> <1268720060.21384.10.camel@mulgrave.site>
	 <4B9F2388.2030803@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Mar 2010 06:24:57 -0700
Message-ID: <1268745897.21384.14.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-16 at 15:22 +0900, Tejun Heo wrote:
> Hello, James.
> 
> On 03/16/2010 03:14 PM, James Bottomley wrote:
> > So, it is true to say that picking a certain H/S geometry (which is
> > entirely withing the gift of the partitioner) will align msdos label
> > partitions, but will be don't care for all other labels: all other
> > partition labels (like gpt) use block as offset and don't have any truck
> > with the fictitious C/H/S stuff.
> 
> For any modern Linux and Windows, CHS simply doesn't matter.  They
> don't look at it at all.

If they have a msdos label, they do.

> > The big problem is that 99% of the x86 systems out there still use the
> > ancient msdos label for their boot disks, so aligning H/S going forwards
> > will give us a nice "just works" for x86 boxes.
> 
> What I don't get is that how picking up a custom geometry can make
> things work when there is *no* reliable way to determine which
> geometry was used during partitioning once the partitioning is
> complete.

For msdos labels, it's embedded in the label ... for all other labels,
it's made up on the spot.

>   Most BIOSs these days will simply report the geometry as
> being 255/63 regardless of the geometry used during partitioning.  So,
> how can using a custom geometry give that nice "just works" for x86
> boxes when nobody knows what geometry is in use?

Because the msdos label can only partition in units of cylinders.  If
you're using an msdos label, picking the right H/S gets you alignment.

James


