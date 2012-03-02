Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965509Ab2CBO1B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 09:27:01 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:22988 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964853Ab2CBO06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 09:26:58 -0500
Date: Fri, 2 Mar 2012 09:26:51 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Jacek Luczak <difrost.kernel@gmail.com>
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org
Subject: Re: getdents - ext4 vs btrfs performance
Message-ID: <20120302142651.GH5054@shiny>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Jacek Luczak <difrost.kernel@gmail.com>,
	Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org
References: <CADDYkjS5VJeYyHzqumazQ0qKg+HwA6GO+zYSJj7rkHNZFwjcoQ@mail.gmail.com>
 <E15A491F-62E2-4518-939F-07B3AB4C3E65@mit.edu>
 <20120301143859.GX5054@shiny>
 <CADDYkjQ8jgWUo7=eAeMjve0iRmVZMcrjjbqnvPq0SchE5W9Fqg@mail.gmail.com>
 <20120302140038.GD5054@shiny>
 <CADDYkjT8apYQpdZqr1gZKiHbm9xfTaLr=8GEJF0VKF9neHwgOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADDYkjT8apYQpdZqr1gZKiHbm9xfTaLr=8GEJF0VKF9neHwgOg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090206.4F50D8B0.0076,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2012 at 03:16:12PM +0100, Jacek Luczak wrote:
> 2012/3/2 Chris Mason <chris.mason@oracle.com>:
> > On Fri, Mar 02, 2012 at 11:05:56AM +0100, Jacek Luczak wrote:
> >>
> >> I've took both on tests. The subject is acp and spd_readdir used with
> >> tar, all on ext4:
> >> 1) acp: http://91.234.146.107/~difrost/seekwatcher/acp_ext4.png
> >> 2) spd_readdir: http://91.234.146.107/~difrost/seekwatcher/tar_ext4_readir.png
> >> 3) both: http://91.234.146.107/~difrost/seekwatcher/acp_vs_spd_ext4.png
> >>
> >> The acp looks much better than spd_readdir but directory copy with
> >> spd_readdir decreased to 52m 39sec (30 min less).
> >
> > Do you have stats on how big these files are, and how fragmented they
> > are?  For acp and spd to give us this, I think something has gone wrong
> > at writeback time (creating individual fragmented files).
> 
> How big? Which files?

All the files you're reading ;)

filefrag will tell you how many extents each file has, any file with
more than one extent is interesting.  (The ext4 crowd may have better
suggestions on measuring fragmentation).

Since you mention this is a compile farm, I'm guessing there are a bunch
of .o files created by parallel builds.  There are a lot of chances for
delalloc and the kernel writeback code to do the wrong thing here.

-chris

