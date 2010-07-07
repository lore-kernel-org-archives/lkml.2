Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab0GGNLQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 09:11:16 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:51891 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408Ab0GGNLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 09:11:15 -0400
To: "J. Bruce Fields" <bfields@fieldses.org>
CC: neilb@suse.de, david@fromorbit.com, aneesh.kumar@linux.vnet.ibm.com,
       hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
       corbet@lwn.net, serue@us.ibm.com, hooanon05@yahoo.co.jp,
       linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com,
       philippe.deniel@CEA.FR, linux-kernel@vger.kernel.org
In-reply-to: <20100707125701.GA19872@fieldses.org> (bfields@fieldses.org)
Subject: Re: [PATCH -V14 0/11] Generic name to handle and open by handle
 syscalls
References: <1276621981-2774-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <871vbn2mk9.fsf@linux.vnet.ibm.com>
 <20100702064108.64034561@notabene.brown>
 <87iq4y29a6.fsf@linux.vnet.ibm.com>
 <20100706161002.GD7387@fieldses.org>
 <87eifgfsez.fsf@linux.vnet.ibm.com>
 <20100706232351.GD25018@dastard>
 <20100707093629.10c2feab@notabene.brown>
 <20100707021150.GF25018@dastard>
 <20100707125726.3695587a@notabene.brown> <20100707125701.GA19872@fieldses.org>
Message-Id: <E1OWUOL-0004DM-Ul@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 07 Jul 2010 15:10:21 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Jul 2010, J. Bruce Fields wrote:
> On Wed, Jul 07, 2010 at 12:57:26PM +1000, Neil Brown wrote:
> > The trouble with /proc/mounts is that it is somewhat clumsy to parse
> > (remember to handle \0ctal escapes) and doesn't include major/minor number
> > which is the primary key for identifying filesystems in Linux
> > (see /sys/class/bdi/MAJOR:MINOR which is e.g. the best place to configure
> > read-ahead for a filesystem).
> > 
> > So /proc/mounts could work (and would probably be better than a new syscall)
> > but I would really rather see something sane in /sys for
> > inspecting/configuring filesystems (rather than each filesystem doing their
> > own independent thing in /sys/fs).
> 
> If you use sys or proc, is it possible to get the uuid from a file
> descriptor or pathname without races?

You can do stat/fstat to find out the device number (which is unique,
but not persistent) then look for the major:minor calculated from
st_dev in /proc/self/mountinfo.

Thanks,
Miklos
