Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651Ab1IVQgu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 12:36:50 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:22838 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886Ab1IVQgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 12:36:49 -0400
Date: Thu, 22 Sep 2011 11:54:49 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Li Dongyang <lidongyang@novell.com>
Cc: Christoph Hellwig <hch@infradead.org>, "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jaxboe@fusionio.com" <jaxboe@fusionio.com>,
        "joe.jin@oracle.com" <joe.jin@oracle.com>
Subject: Re: [GIT PULL] (xen) stable/for-jens-3.2 - blkback and blkfront
 patches for 3.2
Message-ID: <20110922155449.GA16401@phenom.oracle.com>
References: <20110921150955.GH541@phenom.oracle.com>
 <20110921151732.GA28043@infradead.org>
 <20110921153537.GB1512@phenom.oracle.com>
 <CAKH3R4_yAhmRE3Lg73gE3iKD_Dcp0u_hr8rHekSyRJVQ02KbGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKH3R4_yAhmRE3Lg73gE3iKD_Dcp0u_hr8rHekSyRJVQ02KbGw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4E7B6416.01C0:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 09:05:17PM +1000, Li Dongyang wrote:
> On Thursday, September 22, 2011, Konrad Rzeszutek Wilk <
> konrad.wilk@oracle.com> wrote:
> > On Wed, Sep 21, 2011 at 11:17:32AM -0400, Christoph Hellwig wrote:
> >> On Wed, Sep 21, 2011 at 11:09:55AM -0400, Konrad Rzeszutek Wilk wrote:
> >> > Hey Jens,
> >> >
> >> > Please pull the following git tree in your 3.2 drivers tree:
> >> >
> >> >  git pull git://oss.oracle.com/git/kwilk/xen.git stable/for-jens-3.2
> >> >
> >> > which has an exciting new feature - the discard ('feature-discard')
> >> > aka TRIM/UNMAP. Now they can be passed from the guest to the backend.
> >>
> >> What is the design of them?  Do you provide the 'discard zeroes data'
> >> flag (mandatory for any kind of relible operation) and 'discard
> >
> > Hmm, not sure what that is. Is that REQ_SECURE, err BLKDEV_DISCARD_SECURE?
> > If so then not in this patchset - but it does not seem like it would
> dificult
> > to add that in? Li, what do you think?
> We deal the discard with 2 ways in the backend depend on what the guest is
> using:
> punch the hole on the image, to save some disk usage,
> or redirect the discard request to phy device.
> for the hole punching case, we are already DISCARD_SECURE,
> for the phy dev case, we could add the flag and pass it from blkfront to
> blkback, and yes
> That's not difficult, could be added later.

Li, could you implement it please  - on top of the 'stable/for-jens-3.2' patch queue ?
If it would not be too much trouble of course.

> >
> >> granularity / alignment' tunables (very useful)?
> >
> > The discard granularity/alignment are certainly there. But they are just
> > one way (backend tells the guest what they are). Should they be
> > more tunable (frontend tells the backend what the values ought to be?)
> >
> Yes, plz tell more about tunable granularity and alignment, and we can add
> that later,
> Thanks a lot
> > Li, did I miss anything in my response?
> >
