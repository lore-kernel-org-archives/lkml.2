Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344Ab2DQNj6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 09:39:58 -0400
Received: from p02c12o143.mxlogic.net ([208.65.145.76]:45372 "EHLO
	p02c12o143.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932225Ab2DQNjz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 09:39:55 -0400
X-MXL-Hash: 4f8d72ab2c5db5a4-96a619f0af894aa6bde7ba7a183ec0812b214027
X-MXL-Hash: 4f8d72a06fd002fb-e9b339b4d80b56547b65f5fc77f683c50b01060d
From: Peter Staubach <pstaubach@exagrid.com>
To: Jeff Layton <jlayton@redhat.com>,
        "Myklebust, Trond" <Trond.Myklebust@netapp.com>
CC: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>,
        Malahal Naineni <malahal@us.ibm.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "miklos@szeredi.hu" <miklos@szeredi.hu>,
        "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
        "hch@infradead.org" <hch@infradead.org>,
        "michael.brantley@deshaw.com" <michael.brantley@deshaw.com>,
        "sven.breuner@itwm.fraunhofer.de" <sven.breuner@itwm.fraunhofer.de>
Date: Tue, 17 Apr 2012 09:39:30 -0400
Subject: RE: [PATCH RFC] vfs: make fstatat retry on ESTALE errors from
 getattr call
Thread-Topic: [PATCH RFC] vfs: make fstatat retry on ESTALE errors from
 getattr call
Thread-Index: Ac0cJVzlPerDd83VQbKnNZrnXV/jXwAeabFg
Message-ID: <FA8A9A935BFD3A4D8F0CDA1C4F611BCC063CF8E115@IT-1874.Isys.com>
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
In-Reply-To: <20120416190548.2463d1d0@corrin.poochiereds.net>
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
X-AnalysisOut: [v=1.0 c=1 a=XjRXyhSzQbsA:10 a=ooaBVg03rvgA:10 a=BLceEmwcHo]
X-AnalysisOut: [wA:10 a=kj9zAlcOel0A:10 a=YmXeKoonWU0GTmr6cORa5w==:17 a=20]
X-AnalysisOut: [KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=drOt6m5kAAAA:8 a=JfrnYn6hA]
X-AnalysisOut: [AAA:8 a=sHqLhEVXAAAA:8 a=JDjsHSkAAAAA:8 a=QWEbjZtBf_DZcyZJ]
X-AnalysisOut: [iaYA:9 a=zvrZ7AEj4Wjf5NTQnpIA:7 a=CjuIK1q_8ugA:10 a=jEp0uc]
X-AnalysisOut: [aQiEUA:10 a=3Rfx1nUSh_UA:10 a=tIBAwYQmwVgA:10 a=Hf6muOzgCG]
X-AnalysisOut: [QA:10 a=Y1-FTz3XjMPXy8mn:21 a=H9ui9WHCrJNhwm8M:21]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

There does need to be support in the lookup path to handle stale directories.  During a multi-component lookup, it is possible for one component to be looked up, but then become stale before being used.  The support needs to go into more than just the set of system calls, but also into the lookup code.

I suspect that since the "" case is handled specially anyway, code could be added to do something like issue a GETATTR to verify that the directory is still valid.  Since "" is probably used minimally, the performance impact to the system should be also be minimal.

		ps


-----Original Message-----
From: Jeff Layton [mailto:jlayton@redhat.com] 
Sent: Monday, April 16, 2012 7:06 PM
To: Myklebust, Trond
Cc: Bernd Schubert; Malahal Naineni; linux-nfs@vger.kernel.org; linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; Peter Staubach; miklos@szeredi.hu; viro@ZenIV.linux.org.uk; hch@infradead.org; michael.brantley@deshaw.com; sven.breuner@itwm.fraunhofer.de
Subject: Re: [PATCH RFC] vfs: make fstatat retry on ESTALE errors from getattr call

On Mon, 16 Apr 2012 20:25:06 +0000
"Myklebust, Trond" <Trond.Myklebust@netapp.com> wrote:

> On Mon, 2012-04-16 at 15:43 -0400, Jeff Layton wrote:
> > On Mon, 16 Apr 2012 19:33:05 +0000
> > "Myklebust, Trond" <Trond.Myklebust@netapp.com> wrote:
> > 
> > > On Mon, 2012-04-16 at 13:46 -0400, Jeff Layton wrote:
> > > > The question about looping indefinitely really comes down to:
> > > > 
> > > > 1) is a persistent ESTALE in conjunction with a successful 
> > > > lookup a situation that we expect to be temporary. i.e. will the 
> > > > admin at some point be able to do something about it? If not, 
> > > > then there's no point in continuing to retry. Again, this is a 
> > > > situation that *really* should not happen if the filesystem is doing the right thing.
> > > > 
> > > > 2) If the admin can't do anything about it, is it reasonable to 
> > > > expect that users can send a fatal signal to hung applications 
> > > > if this situation occurs.
> > > > 
> > > > We expect that that's ok in other situations to resolve hung 
> > > > applications, so I'm not sure I understand why it wouldn't be 
> > > > acceptable here...
> > > 
> > > There are definitely potentially persistent pathological 
> > > situations that the filesystem can't do anything about. If the 
> > > point of origin for your pathname (for instance your current 
> > > directory in the case of a relative
> > > pathname) is stale, then no amount of looping is going to help you 
> > > to recover.
> > > 
> > 
> > Ok -- Peter pretty much said something similar. Retrying indefnitely 
> > when the lookup returns ESTALE probably won't help. I'm ok with 
> > basically letting the VFS continue to do what it does there already. 
> > If it gets an ESTALE, it tries again with LOOKUP_REVAL set and then 
> > gives up if that doesn't work.
> > 
> > If however, the operation itself keeps returning ESTALE, are we OK 
> > to retry indefinitely assuming that we'll break out of the loop on 
> > fatal signals?
> >
> > For example, something like the v2 patch I sent a little while ago?
> 
> 
> Won't something like fstatat(AT_FDCWD, "", &stat, AT_EMPTY_PATH) risk 
> looping forever there, or am I missing something?
> 

To make sure I understand, that should be "shortcut" for a lookup of the cwd?

So I guess the concern is that you'd do the above and get a successful lookup since you're just going to get back the cwd. At that point, you'd attempt the getattr and get ESTALE back. Then, you'd redo the lookup with LOOKUP_REVAL set -- but since we're operating on the cwd, we don't have a way to redo the lookup since we don't have a pathname that we can look up again...

So yeah, I guess if you're sitting in a stale directory, something like that could loop eternally.

Do you think the proposed check for fatal_signal_pending is enough to mitigate such a problem? Or do we need to limit the number of retries to address those sorts of loops?

--
Jeff Layton <jlayton@redhat.com>
