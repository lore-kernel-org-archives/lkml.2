Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932076Ab2DQOsz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 10:48:55 -0400
Received: from p02c12o147.mxlogic.net ([208.65.145.80]:44094 "EHLO
	p02c12o147.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab2DQOsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 10:48:53 -0400
X-MXL-Hash: 4f8d82d45e7d7d29-d38a4364df0d21b95d9ea1232af76f0be957bdef
X-MXL-Hash: 4f8d82d3035510be-0a990d8c08507c672c229a7a38e3b64fdf3d36f6
From: Peter Staubach <pstaubach@exagrid.com>
To: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
CC: Jeff Layton <jlayton@redhat.com>,
        Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>,
        Malahal Naineni <malahal@us.ibm.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "miklos@szeredi.hu" <miklos@szeredi.hu>,
        "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
        "hch@infradead.org" <hch@infradead.org>,
        "michael.brantley@deshaw.com" <michael.brantley@deshaw.com>,
        "sven.breuner@itwm.fraunhofer.de" <sven.breuner@itwm.fraunhofer.de>
Date: Tue, 17 Apr 2012 10:48:42 -0400
Subject: RE: [PATCH RFC] vfs: make fstatat retry on ESTALE errors from
 getattr call
Thread-Topic: [PATCH RFC] vfs: make fstatat retry on ESTALE errors from
 getattr call
Thread-Index: AQHNHAe/WFyXQNvYykq9RVAgdBQu35aeT6UAgAALqQCAACzmAIAA9BwAgAAIOgD//5R3YA==
Message-ID: <FA8A9A935BFD3A4D8F0CDA1C4F611BCC063CF8E132@IT-1874.Isys.com>
References: <1334316311-22331-1-git-send-email-jlayton@redhat.com>
	 <20120413150518.GA1987@us.ibm.com>
	 <20120413114236.0e557e01@tlielax.poochiereds.net>
	 <4F8B1B7B.3040304@itwm.fraunhofer.de>
	 <20120416073655.7cdb90cf@corrin.poochiereds.net>
	 <4F8C3036.2030702@itwm.fraunhofer.de>
	 <20120416134642.1754cd3e@corrin.poochiereds.net>
	 <1334604785.2879.23.camel@lade.trondhjem.org>
	 <20120416154322.0d95e435@corrin.poochiereds.net>
	 <1334607906.2879.36.camel@lade.trondhjem.org>
	 <20120416190548.2463d1d0@corrin.poochiereds.net>
	 <FA8A9A935BFD3A4D8F0CDA1C4F611BCC063CF8E115@IT-1874.Isys.com>
 <1334671736.2963.30.camel@lade.trondhjem.org.localdomain>
In-Reply-To: <1334671736.2963.30.camel@lade.trondhjem.org.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010122901)]
X-MAIL-FROM: <pstaubach@exagrid.com>
X-SOURCE-IP: [69.84.133.248]
X-AnalysisOut: [v=1.0 c=1 a=XjRXyhSzQbsA:10 a=ooaBVg03rvgA:10 a=BLceEmwcHo]
X-AnalysisOut: [wA:10 a=IkcTkHD0fZMA:10 a=YmXeKoonWU0GTmr6cORa5w==:17 a=JD]
X-AnalysisOut: [jsHSkAAAAA:8 a=VwQbUJbxAAAA:8 a=drOt6m5kAAAA:8 a=JfrnYn6hA]
X-AnalysisOut: [AAA:8 a=sHqLhEVXAAAA:8 a=20KFwNOVAAAA:8 a=hTtWbpxnfZdzCUA9]
X-AnalysisOut: [z4IA:9 a=vsqVJXWN0ehg9BL1RAkA:7 a=QEXdDO2ut3YA:10 a=E3ZZfl]
X-AnalysisOut: [hfDMIA:10 a=Hf6muOzgCGQA:10 a=3Rfx1nUSh_UA:10 a=tIBAwYQmwV]
X-AnalysisOut: [gA:10 a=jEp0ucaQiEUA:10 a=PHUxf32QGnf9Q64l:21 a=Qjh5E08SIN]
X-AnalysisOut: [NXngJN:21]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q3HEn2Y3011193

I don't think that the code ends up being all that complex, actually.  I will have to dig out the patches that I had previously to look to see what they did.  I am pretty sure that they handled all of these cases.  I also had some tests which exercised the modified path based system calls and at least, at one point in time, they would run without returning ESTALE to the user level.

Let me see what I can find.  SteveD, you wouldn't have squirrelled away a copy of my stuff from Red Hat, would you?

	Thanx...

		ps


-----Original Message-----
From: Myklebust, Trond [mailto:Trond.Myklebust@netapp.com] 
Sent: Tuesday, April 17, 2012 10:09 AM
To: Peter Staubach
Cc: Jeff Layton; Bernd Schubert; Malahal Naineni; linux-nfs@vger.kernel.org; linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; miklos@szeredi.hu; viro@ZenIV.linux.org.uk; hch@infradead.org; michael.brantley@deshaw.com; sven.breuner@itwm.fraunhofer.de
Subject: RE: [PATCH RFC] vfs: make fstatat retry on ESTALE errors from getattr call

On Tue, 2012-04-17 at 09:39 -0400, Peter Staubach wrote:
> Hi.
> 
> There does need to be support in the lookup path to handle stale directories.  During a multi-component lookup, it is possible for one component to be looked up, but then become stale before being used.  The support needs to go into more than just the set of system calls, but also into the lookup code.
> 
> I suspect that since the "" case is handled specially anyway, code could be added to do something like issue a GETATTR to verify that the directory is still valid.  Since "" is probably used minimally, the performance impact to the system should be also be minimal.

The problem with that is that even if your current directory is stale, a path of the form "../../../blah" can still be valid. I suspect that any code that tries to loop forever can quickly get very complicated as we start adding all these corner cases.

The thing about stat() is that in 99.99% of cases when the path revalidation code works, then the NFS client won't have to actually issue a GETATTR in the call to vfs_getstat() since the LOOKUP of that final path component will revalidate those attributes anyway.

The only exception to that rule will be the 'noac' mounts, which really can end up looping forever.

Cheers
  Trond

> 		ps
> 
> 
> -----Original Message-----
> From: Jeff Layton [mailto:jlayton@redhat.com]
> Sent: Monday, April 16, 2012 7:06 PM
> To: Myklebust, Trond
> Cc: Bernd Schubert; Malahal Naineni; linux-nfs@vger.kernel.org; 
> linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; Peter 
> Staubach; miklos@szeredi.hu; viro@ZenIV.linux.org.uk; 
> hch@infradead.org; michael.brantley@deshaw.com; 
> sven.breuner@itwm.fraunhofer.de
> Subject: Re: [PATCH RFC] vfs: make fstatat retry on ESTALE errors from 
> getattr call
> 
> On Mon, 16 Apr 2012 20:25:06 +0000
> "Myklebust, Trond" <Trond.Myklebust@netapp.com> wrote:
> 
> > On Mon, 2012-04-16 at 15:43 -0400, Jeff Layton wrote:
> > > On Mon, 16 Apr 2012 19:33:05 +0000 "Myklebust, Trond" 
> > > <Trond.Myklebust@netapp.com> wrote:
> > > 
> > > > On Mon, 2012-04-16 at 13:46 -0400, Jeff Layton wrote:
> > > > > The question about looping indefinitely really comes down to:
> > > > > 
> > > > > 1) is a persistent ESTALE in conjunction with a successful 
> > > > > lookup a situation that we expect to be temporary. i.e. will 
> > > > > the admin at some point be able to do something about it? If 
> > > > > not, then there's no point in continuing to retry. Again, this 
> > > > > is a situation that *really* should not happen if the filesystem is doing the right thing.
> > > > > 
> > > > > 2) If the admin can't do anything about it, is it reasonable 
> > > > > to expect that users can send a fatal signal to hung 
> > > > > applications if this situation occurs.
> > > > > 
> > > > > We expect that that's ok in other situations to resolve hung 
> > > > > applications, so I'm not sure I understand why it wouldn't be 
> > > > > acceptable here...
> > > > 
> > > > There are definitely potentially persistent pathological 
> > > > situations that the filesystem can't do anything about. If the 
> > > > point of origin for your pathname (for instance your current 
> > > > directory in the case of a relative
> > > > pathname) is stale, then no amount of looping is going to help 
> > > > you to recover.
> > > > 
> > > 
> > > Ok -- Peter pretty much said something similar. Retrying 
> > > indefnitely when the lookup returns ESTALE probably won't help. 
> > > I'm ok with basically letting the VFS continue to do what it does there already.
> > > If it gets an ESTALE, it tries again with LOOKUP_REVAL set and 
> > > then gives up if that doesn't work.
> > > 
> > > If however, the operation itself keeps returning ESTALE, are we OK 
> > > to retry indefinitely assuming that we'll break out of the loop on 
> > > fatal signals?
> > >
> > > For example, something like the v2 patch I sent a little while ago?
> > 
> > 
> > Won't something like fstatat(AT_FDCWD, "", &stat, AT_EMPTY_PATH) 
> > risk looping forever there, or am I missing something?
> > 
> 
> To make sure I understand, that should be "shortcut" for a lookup of the cwd?
> 
> So I guess the concern is that you'd do the above and get a successful lookup since you're just going to get back the cwd. At that point, you'd attempt the getattr and get ESTALE back. Then, you'd redo the lookup with LOOKUP_REVAL set -- but since we're operating on the cwd, we don't have a way to redo the lookup since we don't have a pathname that we can look up again...
> 
> So yeah, I guess if you're sitting in a stale directory, something like that could loop eternally.
> 
> Do you think the proposed check for fatal_signal_pending is enough to mitigate such a problem? Or do we need to limit the number of retries to address those sorts of loops?
> 
> --
> Jeff Layton <jlayton@redhat.com>

--
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
