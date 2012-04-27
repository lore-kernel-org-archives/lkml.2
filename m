Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398Ab2D0PYi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 11:24:38 -0400
Received: from mx2.netapp.com ([216.240.18.37]:38993 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760567Ab2D0PVd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 11:21:33 -0400
X-IronPort-AV: E=Sophos;i="4.75,491,1330934400"; 
   d="scan'208";a="643868824"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Josh Boyer <jwboyer@redhat.com>
CC: Jim Rees <rees@umich.edu>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] NFSv4: Add modalias for "nfs4"
Thread-Topic: [PATCH] NFSv4: Add modalias for "nfs4"
Thread-Index: AQHNJHcmB5tVtvMMXUiGbvC5SkV+epavLeAAgAAINQCAAACBAIAAAPSAgAACTYCAAANZAIAAAf4A
Date: Fri, 27 Apr 2012 15:21:15 +0000
Message-ID: <1335540074.3910.9.camel@lade.trondhjem.org>
References: <20120427131031.GA13189@zod.bos.redhat.com>
	 <20120427141918.GA15506@umich.edu>
	 <20120427144840.GB13189@zod.bos.redhat.com>
	 <1335538228.3910.1.camel@lade.trondhjem.org>
	 <20120427145352.GC13189@zod.bos.redhat.com>
	 <1335538927.3910.3.camel@lade.trondhjem.org>
	 <20120427151406.GD13189@zod.bos.redhat.com>
In-Reply-To: <20120427151406.GD13189@zod.bos.redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.116]
Content-Type: text/plain; charset="utf-8"
Content-ID: <9B94FBFABB204847A1ACEC42910759C2@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q3RFOnhe022643

On Fri, 2012-04-27 at 11:14 -0400, Josh Boyer wrote:
> On Fri, Apr 27, 2012 at 03:02:07PM +0000, Myklebust, Trond wrote:
> > On Fri, 2012-04-27 at 10:53 -0400, Josh Boyer wrote:
> > > On Fri, Apr 27, 2012 at 02:50:28PM +0000, Myklebust, Trond wrote:
> > > > On Fri, 2012-04-27 at 10:48 -0400, Josh Boyer wrote:
> > > > > On Fri, Apr 27, 2012 at 10:19:18AM -0400, Jim Rees wrote:
> > > > > > Josh Boyer wrote:
> > > > > > 
> > > > > >   When NFSv4 is configured, the support goes into the nfs.ko module.
> > > > > >   However, nfs-utils seems to pass "nfs4" as the fileststem type for
> > > > > >   NFSv4 mounts.
> > > > > > 
> > > > > > Weren't we going to change that to nfs and use nfsvers to select nfs4?
> > > > > 
> > > > > I have, approximately, no idea.  At least the version of nfs-utils found
> > > > > in Fedora 17 and rawhide, it's still using "nfs4".   I believe that is
> > > > > nfs-utils-1.2.6-rc6 based.
> > > > 
> > > > nfs4 is still _supported_ in Fedora 17, rawhide and upstream as a legacy
> > > > feature, but the recommended practice should be to mount -t nfs -overs=4
> > > > (or -overs=4.1).
> > > 
> > > OK.  So either this patch needs to go in, or something needs to add:
> > > 
> > > alias nfs4 nfs
> > > 
> > > to a conf file so modprobe picks it up.  I figured the kernel could add
> > > the alias itself.  Is there a reason not to?
> > 
> > Yes. This is a legacy feature that we want to encourage people to move
> > their systems off...
> 
> So essentially what needs to happen is:
> 
> - Recent distros still ship the modalias in a conf file
> - Upstream nfs-utils starts translating 'mount -t nfs4' into 'mount -t
>   nfs -overs=4' in /sbin/mount.nfs4
> - Upstream releases that
> - Distros drop the alias.
> 
> Right?

No. Really all we need to do is add a printf() to /sbin/mount.nfs4 to
the effect that this is a legacy feature and that '-t nfs -overs=4' is
the recommended mount option. Perhaps the distros can also have their
distro upgrade utilities edit /etc/fstab to upgrade those automatically.

Then the distros can drop the alias whenever they think it is
appropriate.

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
