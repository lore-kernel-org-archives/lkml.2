Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757170Ab0GWRjD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 13:39:03 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:38517 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756647Ab0GWRjA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 13:39:00 -0400
MIME-Version: 1.0
Message-ID: <c979fa45-8878-4e40-9060-c3e929eebbab@default>
Date: Fri, 23 Jul 2010 10:37:51 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Christoph Hellwig <hch@infradead.org>, ngupta@vflare.org
Cc: akpm@linux-foundation.org, Chris Mason <chris.mason@oracle.com>,
        viro@zeniv.linux.org.uk, adilger@sun.com, tytso@mit.edu,
        mfasheh@suse.com, Joel Becker <joel.becker@oracle.com>, matthew@wil.cx,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        ocfs2-devel@oss.oracle.com, linux-mm@kvack.org, jeremy@goop.org,
        JBeulich@novell.com, Kurt Hackel <kurt.hackel@oracle.com>,
        npiggin@suse.de, Dave Mccracken <dave.mccracken@oracle.com>,
        riel@redhat.com, avi@redhat.com, Konrad Wilk <konrad.wilk@oracle.com>
Subject: RE: [PATCH V3 0/8] Cleancache: overview
References: <20100621231809.GA11111@ca-server1.us.oracle.com4C49468B.40307@vflare.org>
 <840b32ff-a303-468e-9d4e-30fc92f629f8@default
 20100723140440.GA12423@infradead.org
 364c83bd-ccb2-48cc-920d-ffcf9ca7df19@default>
In-Reply-To: <364c83bd-ccb2-48cc-920d-ffcf9ca7df19@default>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.2.1.2  (406224) [OL
 12.0.6535.5005]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4C49D395.006F:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Dan Magenheimer
> Subject: RE: [PATCH V3 0/8] Cleancache: overview
> 
> > From: Christoph Hellwig [mailto:hch@infradead.org]
> > Subject: Re: [PATCH V3 0/8] Cleancache: overview
> >
> > On Fri, Jul 23, 2010 at 06:58:03AM -0700, Dan Magenheimer wrote:
> > > CHRISTOPH AND ANDREW, if you disagree and your concerns have
> > > not been resolved, please speak up.
> 
> Hi Christoph --
> 
> Thanks very much for the quick (instantaneous?) reply!
> 
> > Anything that need modification of a normal non-shared fs is utterly
> > broken and you'll get a clear NAK, so the propsal before is a good
> > one.
> 
> Unless/until all filesystems are 100% built on top of VFS,
> I have to disagree.  Abstractions (e.g. VFS) are never perfect.

After thinking about this some more, I can see a way
to enforce "opt-in" in the cleancache backend without
any changes to non-generic fs code.   I think it's a horrible
hack and we can try it, but I expect fs maintainers
would prefer the explicit one-line-patch opt-in.

1) Cleancache backend maintains a list of "known working"
   filesystems (those that have been tested).

2) Nitin's proposed changes pass the *sb as a parameter.
  The string name of the filesystem type is available via
  sb->s_type->name.  This can be compared against
  the "known working" list.

Using the sb pointer as a "handle" requires an extra
table search on every cleancache get/put/flush,
and fs/super.c changes are required for fs unmount
notification anyway (e.g. to call cleancache_flush_fs)
so I'd prefer to keep the cleancache_poolid addition
to the sb.  I'll assume this is OK since this is in generic
fs code.

Dan
