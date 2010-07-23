Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757905Ab0GWVS5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 17:18:57 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:58835 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756990Ab0GWVSz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 17:18:55 -0400
MIME-Version: 1.0
Message-ID: <fc254547-5926-4cb9-98e1-7a79f7284e30@default>
Date: Fri, 23 Jul 2010 14:17:31 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: ngupta@vflare.org, akpm@linux-foundation.org,
        Chris Mason <chris.mason@oracle.com>, viro@zeniv.linux.org.uk,
        adilger@sun.com, tytso@mit.edu, mfasheh@suse.com,
        Joel Becker <joel.becker@oracle.com>, matthew@wil.cx,
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
X-CT-RefId: str=0001.0A090202.4C4A06FC.00AE:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
> No, the per-fs opt-in is very sensible; and its design is
> very minimal.

Not to belabor the point, but maybe the right way to think about
this is:

Cleancache is a new optional feature provided by the VFS layer
that potentially dramatically increases page cache effectiveness
for many workloads in many environments at a negligible cost.

Filesystems that are well-behaved and conform to certain restrictions
can utilize cleancache simply by making a call to cleancache_init_fs
at mount time.  Unusual, misbehaving, or poorly layered filesystems
must either add additional hooks and/or undergo extensive additional
testing... or should just not enable the optional cleancache.
