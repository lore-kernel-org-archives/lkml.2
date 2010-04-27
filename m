Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141Ab0D0U1h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 16:27:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35891 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754682Ab0D0U1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 16:27:36 -0400
Date: Tue, 27 Apr 2010 13:26:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Christian Kujau <lists@nerdbynature.de>,
       Zhenyu Wang <zhenyuw@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, David.Woodhouse@intel.com,
       dwmw2@infradead.org, eric@anholt.net, ben@decadent.org.uk,
       gregkh@suse.de, Dave Airlie <airlied@linux.ie>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [PATCH] intel-agp.c: Fix crash when accessing nonexistent GTT 
 entries in i915
Message-Id: <20100427132607.49c68196.akpm@linux-foundation.org>
In-Reply-To: <n2tca2dc2821004271306nfc0c9c76o143b796e8af6ced8@mail.gmail.com>
References: <1268258994.2183.14.camel@carter>
	<ca2dc2821003200604m7c8cdea4r64ab8c98e7ec8242@mail.gmail.com>
	<20100321135836.GA11661@zhen-devel.sh.intel.com>
	<ca2dc2821003210830h2025df79r477cca7d81ddd28d@mail.gmail.com>
	<20100322205704.ac4cd9ae.akpm@linux-foundation.org>
	<alpine.DEB.2.01.1003222111070.5493@bogon.housecafe.de>
	<ca2dc2821003230440w3d96612aja0d4e083d3cc8c02@mail.gmail.com>
	<20100324111436.fe5d2906.akpm@linux-foundation.org>
	<ca2dc2821003250955x211ef2f8la16ded9759ccb6ab@mail.gmail.com>
	<20100427105750.1cfe59b9.akpm@linux-foundation.org>
	<n2tca2dc2821004271306nfc0c9c76o143b796e8af6ced8@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Apr 2010 22:06:21 +0200
Miguel Ojeda <miguel.ojeda.sandonis@gmail.com> wrote:

> On Tue, Apr 27, 2010 at 7:57 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > On Thu, 25 Mar 2010 17:55:56 +0100
> > Miguel Ojeda <miguel.ojeda.sandonis@gmail.com> wrote:
> >
> >> On Wed, Mar 24, 2010 at 7:14 PM, Andrew Morton
> >> <akpm@linux-foundation.org> wrote:
> >> > On Tue, 23 Mar 2010 12:40:05 +0100
> >> > Miguel Ojeda <miguel.ojeda.sandonis@gmail.com> wrote:
> >> >
> >> >> On Tue, Mar 23, 2010 at 5:14 AM, Christian Kujau <lists@nerdbynature.de> wrote:
> >> >> > On Mon, 22 Mar 2010 at 20:57, Andrew Morton wrote:
> >> >> >> On Sun, 21 Mar 2010 16:30:20 +0100 Miguel Ojeda <miguel.ojeda.sandonis@gmail.com> wrote:
> >> >> >> > I bisected in order to find the commit 5877960869333e42ebeb733e8d9d5630ff96d350.
> >> >> >
> >> >> > I believe this[0] is fc61901373987ad61851ed001fe971f3ee8d96a3 upstream:
> >> >>
> >> >> Indeed. Also in
> >> >>
> >> >> http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.32.y.git;a=commit;h=fc61901373987ad61851ed001fe971f3ee8d96a3
> >> >
> >> > Does reverting that patch from the current code fix the crash?
> >>
> >> Yes. In addition, applying the patch I provided also fixes it in current code.
> >>
> >
> > Well great. __A whole pile of new stuff has turned up in linux-next's
> > drivers/char/agp/intel-agp.c. __As far as I can tell none of it
> > address the regression which you've reported and your patch no longer
> > applies at all so I have to drop the patch.
> >
> > Perhaps "agp/intel: put back check that we have a driver for the
> > bridge" fixes it, but it isn't tagged for -stable backporting.
> 
> I can try linux-next and see if it works again.

Thanks.

> In addition, I have to test the regression with some newer X version
> yet, as Zhenyu told me.

That would seem to be counter-productive.  If you install a newer X and
the bug goes away, you've just gone and made it harder for yourself to
reproduce the bug.

