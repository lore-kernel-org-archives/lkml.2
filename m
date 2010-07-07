Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab0GGNRo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 09:17:44 -0400
Received: from fieldses.org ([174.143.236.118]:37556 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179Ab0GGNRn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 09:17:43 -0400
Date: Wed, 7 Jul 2010 09:17:21 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: neilb@suse.de, david@fromorbit.com, aneesh.kumar@linux.vnet.ibm.com,
       hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
       corbet@lwn.net, serue@us.ibm.com, hooanon05@yahoo.co.jp,
       linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com,
       philippe.deniel@CEA.FR, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V14 0/11] Generic name to handle and open by handle
 syscalls
Message-ID: <20100707131721.GB19872@fieldses.org>
References: <20100702064108.64034561@notabene.brown>
 <87iq4y29a6.fsf@linux.vnet.ibm.com>
 <20100706161002.GD7387@fieldses.org>
 <87eifgfsez.fsf@linux.vnet.ibm.com>
 <20100706232351.GD25018@dastard>
 <20100707093629.10c2feab@notabene.brown>
 <20100707021150.GF25018@dastard>
 <20100707125726.3695587a@notabene.brown>
 <20100707125701.GA19872@fieldses.org>
 <E1OWUOL-0004DM-Ul@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1OWUOL-0004DM-Ul@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 07, 2010 at 03:10:21PM +0200, Miklos Szeredi wrote:
> On Wed, 7 Jul 2010, J. Bruce Fields wrote:
> > On Wed, Jul 07, 2010 at 12:57:26PM +1000, Neil Brown wrote:
> > > The trouble with /proc/mounts is that it is somewhat clumsy to parse
> > > (remember to handle \0ctal escapes) and doesn't include major/minor number
> > > which is the primary key for identifying filesystems in Linux
> > > (see /sys/class/bdi/MAJOR:MINOR which is e.g. the best place to configure
> > > read-ahead for a filesystem).
> > > 
> > > So /proc/mounts could work (and would probably be better than a new syscall)
> > > but I would really rather see something sane in /sys for
> > > inspecting/configuring filesystems (rather than each filesystem doing their
> > > own independent thing in /sys/fs).
> > 
> > If you use sys or proc, is it possible to get the uuid from a file
> > descriptor or pathname without races?
> 
> You can do stat/fstat to find out the device number (which is unique,
> but not persistent)

Is it really unique over time? (Can't a given st_dev value map to one
filesystem now, and another later?)  And it must also have the same
problems as libblkid (e.g. btrfs subvolumes share the same st_dev).

--b.

> then look for the major:minor calculated from
> st_dev in /proc/self/mountinfo.
> 
> Thanks,
> Miklos
