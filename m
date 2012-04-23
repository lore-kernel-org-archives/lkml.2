Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab2DWRuc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 13:50:32 -0400
Received: from p02c11o144.mxlogic.net ([208.65.144.77]:46641 "EHLO
	p02c11o144.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056Ab2DWRu2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 13:50:28 -0400
X-MXL-Hash: 4f9596641f4bc3d0-aeea6dfa1a2c605141c1bfdd5cc1fc7276ab1584
X-MXL-Hash: 4f9595383159b6eb-ff3ff0dbee3ac35da46b375ade79f17776c2e379
From: Peter Staubach <pstaubach@exagrid.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Chuck Lever <chuck.lever@oracle.com>
CC: "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@redhat.com>,
        Malahal Naineni <malahal@us.ibm.com>,
        Steve Dickson <SteveD@redhat.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "hch@infradead.org" <hch@infradead.org>,
        "michael.brantley@deshaw.com" <michael.brantley@deshaw.com>,
        "sven.breuner@itwm.fraunhofer.de" <sven.breuner@itwm.fraunhofer.de>,
        "trond.myklebust@fys.uio.no" <trond.myklebust@fys.uio.no>,
        "rees@umich.edu" <rees@umich.edu>
Date: Mon, 23 Apr 2012 13:45:08 -0400
Subject: RE: [PATCH RFC v3] vfs: make fstatat retry once on ESTALE errors
 from getattr call
Thread-Topic: [PATCH RFC v3] vfs: make fstatat retry once on ESTALE errors
 from getattr call
Thread-Index: Ac0hZQ+HoAx5StqJT9yvKkoUWlLaiwAE6E6g
Message-ID: <FA8A9A935BFD3A4D8F0CDA1C4F611BCC063CF8E604@IT-1874.Isys.com>
References: <20120420104055.511e15bc@tlielax.poochiereds.net>
	<4F91C49D.8070908@RedHat.com> <20120420203725.GA3512@us.ibm.com>
	<20120420171314.73801874@corrin.poochiereds.net>
	<CAJfpegt40cgMJQQo3JuNaaS1w957Y2a_NxVoyvx3bmTMj1TGOA@mail.gmail.com>
	<20120423080012.7c23ef24@tlielax.poochiereds.net>
	<20120423130009.GA13681@fieldses.org>
	<20120423091255.00f926c4@tlielax.poochiereds.net>
	<20120423133412.GB13681@fieldses.org>
	<20120423095021.1a91a23b@tlielax.poochiereds.net>
	<20120423135456.GC13681@fieldses.org>
	<87hawasdrb.fsf@tucsk.pomaz.szeredi.hu>
	<9991AAC7-5256-4AFE-9722-7AF1119EE7BE@oracle.com>
 <874nsasc8l.fsf@tucsk.pomaz.szeredi.hu>
In-Reply-To: <874nsasc8l.fsf@tucsk.pomaz.szeredi.hu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010122901)]
X-MAIL-FROM: <pstaubach@exagrid.com>
X-SOURCE-IP: [69.84.133.248]
X-AnalysisOut: [v=1.0 c=1 a=lnpZ504GmfQA:10 a=ooaBVg03rvgA:10 a=BLceEmwcHo]
X-AnalysisOut: [wA:10 a=kj9zAlcOel0A:10 a=YmXeKoonWU0GTmr6cORa5w==:17 a=Vw]
X-AnalysisOut: [QbUJbxAAAA:8 a=drOt6m5kAAAA:8 a=JfrnYn6hAAAA:8 a=sHqLhEVXA]
X-AnalysisOut: [AAA:8 a=yPCof4ZbAAAA:8 a=mJjC6ScEAAAA:8 a=xArGQ6MUFWvTgfh6]
X-AnalysisOut: [KKgA:9 a=8LoMMqNwaQoM5rYJdmEA:7 a=CjuIK1q_8ugA:10 a=3Rfx1n]
X-AnalysisOut: [USh_UA:10 a=tIBAwYQmwVgA:10 a=7DSvI1NPTFQA:10 a=2NEUOfxDfW]
X-AnalysisOut: [4A:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The situation of stale current directories and/or stale root directories for mounted file systems is handled.  In these cases, recovery is not possible and so, are not looped for.

	Thanx...

		ps


-----Original Message-----
From: Miklos Szeredi [mailto:miklos@szeredi.hu] 
Sent: Monday, April 23, 2012 11:24 AM
To: Chuck Lever
Cc: J. Bruce Fields; Jeff Layton; Malahal Naineni; Steve Dickson; linux-fsdevel@vger.kernel.org; linux-nfs@vger.kernel.org; linux-kernel@vger.kernel.org; viro@zeniv.linux.org.uk; hch@infradead.org; michael.brantley@deshaw.com; sven.breuner@itwm.fraunhofer.de; Peter Staubach; trond.myklebust@fys.uio.no; rees@umich.edu
Subject: Re: [PATCH RFC v3] vfs: make fstatat retry once on ESTALE errors from getattr call

Chuck Lever <chuck.lever@oracle.com> writes:

> On Apr 23, 2012, at 10:51 AM, Miklos Szeredi wrote:
>
>> "J. Bruce Fields" <bfields@fieldses.org> writes:
>> 
>>> 
>>> I also wonder whether it would be making too many assumptions about 
>>> the server or filesystem: just because ordinary posix interfaces 
>>> don't allow atomic replacement of a whole directory tree doesn't 
>>> mean the server might not have some way to do it.
>> 
>> Exactly because posix limits the atomic replacement to empty 
>> directories is that this feature is not useful and is why linux can 
>> get away with the dead directory behavior in this case.  And thinking 
>> about fixing this in NFS is completely pointless since no one will 
>> rely on the atomic replacement behavior.  Fixing local filesystems is 
>> also pointless for the same reason.
>> 
>> Atomic replacement of whole directory trees would indeed be more 
>> useful, but it's highly unlikely to be used anywhere since 
>> applications relying on this feature would be limited to special filesystems that allow this.
>
> The cases I can think of have to do with file system restore, file 
> system and block device snapshots, and so on.  This type of use case 
> may not practical on today's Linux server, but they are a reality for 
> anyone using high-end NFS storage.

Problem with this is: if some directory file handles are stale (e.g. due to directories being removed, recreated, moved around) and on the client there are cwd-s referring to these handles, then they are going to become stale no matter what you do, even if the same path does exist after the restore on the server.

Thanks,
Miklos
