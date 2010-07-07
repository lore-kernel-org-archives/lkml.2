Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671Ab0GGNgT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 09:36:19 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:55652 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755290Ab0GGNgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 09:36:18 -0400
To: "J. Bruce Fields" <bfields@fieldses.org>
CC: miklos@szeredi.hu, neilb@suse.de, david@fromorbit.com,
       aneesh.kumar@linux.vnet.ibm.com, hch@infradead.org,
       viro@zeniv.linux.org.uk, adilger@sun.com, corbet@lwn.net,
       serue@us.ibm.com, hooanon05@yahoo.co.jp, linux-fsdevel@vger.kernel.org,
       sfrench@us.ibm.com, philippe.deniel@CEA.FR,
       linux-kernel@vger.kernel.org
In-reply-to: <20100707131721.GB19872@fieldses.org> (bfields@fieldses.org)
Subject: Re: [PATCH -V14 0/11] Generic name to handle and open by handle
 syscalls
References: <20100702064108.64034561@notabene.brown>
 <87iq4y29a6.fsf@linux.vnet.ibm.com>
 <20100706161002.GD7387@fieldses.org>
 <87eifgfsez.fsf@linux.vnet.ibm.com>
 <20100706232351.GD25018@dastard>
 <20100707093629.10c2feab@notabene.brown>
 <20100707021150.GF25018@dastard>
 <20100707125726.3695587a@notabene.brown>
 <20100707125701.GA19872@fieldses.org>
 <E1OWUOL-0004DM-Ul@pomaz-ex.szeredi.hu> <20100707131721.GB19872@fieldses.org>
Message-Id: <E1OWUn0-0004JI-7F@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 07 Jul 2010 15:35:50 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Jul 2010, J. Bruce Fields wrote:
> > > If you use sys or proc, is it possible to get the uuid from a file
> > > descriptor or pathname without races?
> > 
> > You can do stat/fstat to find out the device number (which is unique,
> > but not persistent)
> 
> Is it really unique over time? (Can't a given st_dev value map to one
> filesystem now, and another later?) 

It's unique at a single point in time.  But if you have a reference
(e.g. open file descriptor) on the mount then that's not a problem.

   fd = open(path, ...);
   fstat(fd, &st);
   search st.st_dev in mountinfo
   close(fd)

is effectively the same as an getuuid(path) syscall (lazy unmounted
filesystems will not be found in mountinfo, but the reference is still
there so st_dev will not be reused for other filesystems).

Thanks,
Miklos
