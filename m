Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514Ab2G0VoB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 17:44:01 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:51411 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab2G0VoA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 17:44:00 -0400
MIME-Version: 1.0
Message-ID: <d4656ba5-d6d1-4c36-a6c8-f6ecd193b31d@default>
Date: Fri, 27 Jul 2012 14:42:14 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Konrad Rzeszutek Wilk <konrad@darnok.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: RE: [PATCH 0/4] promote zcache from staging
References: <1343413117-1989-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <b95aec06-5a10-4f83-bdfd-e7f6adabd9df@default>
 <20120727205932.GA12650@localhost.localdomain>
In-Reply-To: <20120727205932.GA12650@localhost.localdomain>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.6  (510070) [OL
 12.0.6661.5003 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Konrad Rzeszutek Wilk [mailto:konrad@darnok.org]
> Sent: Friday, July 27, 2012 3:00 PM
> Subject: Re: [PATCH 0/4] promote zcache from staging
> 
> On Fri, Jul 27, 2012 at 12:21:50PM -0700, Dan Magenheimer wrote:
> > > From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
> > > Subject: [PATCH 0/4] promote zcache from staging
> > >
> > > zcache is the remaining piece of code required to support in-kernel
> > > memory compression.  The other two features, cleancache and frontswap,
> > > have been promoted to mainline in 3.0 and 3.5.  This patchset
> > > promotes zcache from the staging tree to mainline.
> > >
> > > Based on the level of activity and contributions we're seeing from a
> > > diverse set of people and interests, I think zcache has matured to the
> > > point where it makes sense to promote this out of staging.
> >
> > Hi Seth --
> >
> > Per offline communication, I'd like to see this delayed for three
> > reasons:
> >
> > 1) I've completely rewritten zcache and will post the rewrite soon.
> >    The redesigned code fixes many of the weaknesses in zcache that
> >    makes it (IMHO) unsuitable for an enterprise distro.  (Some of
> >    these previously discussed in linux-mm [1].)
> > 2) zcache is truly mm (memory management) code and the fact that
> >    it is in drivers at all was purely for logistical reasons
> >    (e.g. the only in-tree "staging" is in the drivers directory).
> >    My rewrite promotes it to (a subdirectory of) mm where IMHO it
> >    belongs.
> > 3) Ramster heavily duplicates code from zcache.  My rewrite resolves
> >    this.  My soon-to-be-post also places the re-factored ramster
> >    in mm, though with some minor work zcache could go in mm and
> >    ramster could stay in staging.
> >
> > Let's have this discussion, but unless the community decides
> > otherwise, please consider this a NACK.

Hi Konrad --
 
> Hold on, that is rather unfair. The zcache has been in staging
> for quite some time - your code has not been posted. Part of
> "unstaging" a driver is for folks to review the code - and you
> just said "No, mine is better" without showing your goods.

Sorry, I'm not trying to be unfair.  However, I don't see the point
of promoting zcache out of staging unless it is intended to be used
by real users in a real distro.  There's been a lot of discussion,
onlist and offlist, about what needs to be fixed in zcache and not
much visible progress on fixing it.  But fixing it is where I've spent
most of my time over the last couple of months.

If IBM or some other company or distro is eager to ship and support
zcache in its current form, I agree that "promote now, improve later"
is a fine approach.  But promoting zcache out of staging simply because
there is urgency to promote zsmalloc+zram out of staging doesn't
seem wise.  At a minimum, it distracts reviewers/effort from what IMHO
is required to turn zcache into an enterprise-ready kernel feature.

I can post my "goods" anytime.  In its current form it is better
than the zcache in staging (and, please remember, I wrote both so
I think I am in a good position to compare the two).
I have been waiting until I think the new zcache is feature complete
before asking for review, especially since the newest features
should demonstrate clearly why the rewrite is necessary and
beneficial.  But I can post* my current bits if people don't
believe they exist and/or don't mind reviewing non-final code.
(* Or I can put them in a publicly available git tree.)

> There is a third option - which is to continue the promotion
> of zcache from staging, get reviews, work on them ,etc, and
> alongside of that you can work on fixing up (or ripping out)
> zcache1 with zcache2 components as they make sense. Or even
> having two of them - an enterprise and an embedded version
> that will eventually get merged together. There is nothing
> wrong with modifying a driver once it has left staging.

Minchan and Seth can correct me if I am wrong, but I believe
zram+zsmalloc, not zcache, is the target solution for embedded.
The limitations of zsmalloc aren't an issue for zram but they are
for zcache, and this deficiency was one of the catalysts for the
rewrite.  The issues are explained in more detail in [1],
but if any point isn't clear, I'd be happy to explain further.

However, I have limited time for this right now and I'd prefer
to spend it finishing the code. :-}

So, as I said, I am still a NACK, but if there are good reasons
to duplicate effort and pursue the "third option", let's discuss
them.

Thanks,
Dan

[1] http://marc.info/?t=133886706700002&r=1&w=2
