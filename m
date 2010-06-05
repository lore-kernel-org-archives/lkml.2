Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446Ab0FETUe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 15:20:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55129 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719Ab0FETUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 15:20:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [linux-pm] [SUSPECTED SPAM] Re: Proposal for a new algorithm 
 =?utf-8?q?for=09reading_=26_writing_a_hibernation?= image.
Date: Sat, 5 Jun 2010 21:21:45 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.35-rc1-rjw; KDE/4.3.5; x86_64; ; )
Cc: Nigel Cunningham <ncunningham@crca.org.au>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "TuxOnIce-devel" <tuxonice-devel@tuxonice.net>
References: <9rpccea67yy402c975fqru8r.1275576653521@email.android.com> <201006052045.19889.rjw@sisk.pl> <1275765021.12828.2.camel@maxim-laptop>
In-Reply-To: <1275765021.12828.2.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201006052121.45816.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 05 June 2010, Maxim Levitsky wrote:
> On Sat, 2010-06-05 at 20:45 +0200, Rafael J. Wysocki wrote: 
> > On Saturday 05 June 2010, Nigel Cunningham wrote:
> > > Hi again.
> > > 
> > > As I think about this more, I reckon we could run into problems at 
> > > resume time with reloading the image. Even if some bits aren't modified 
> > > as we're writing the image, they still might need to be atomically 
> > > restored. If we make the atomic restore part too small, we might not be 
> > > able to do that.
> > > 
> > > So perhaps the best thing would be to stick with the way TuxOnIce splits 
> > > the image at the moment (page cache / process pages vs 'rest'), but 
> > > using this faulting mechanism to ensure we do get all the pages that are 
> > > changed while writing the first part of the image.
> > 
> > I still don't quite understand why you insist on saving the page cache data
> > upfront and re-using the memory occupied by them for another purpose.  If you
> > dropped that requirement, I'd really have much less of a problem with the
> > TuxOnIce's approach.
> Because its the biggest advantage?

It isn't in fact.

> Really saving whole memory makes huge difference.

You don't have to save the _whole_ memory to get the same speed (you don't
do that anyway, but the amount of data you don't put into the image with
TuxOnIce is smaller).  Something like 80% would be just sufficient IMO and
then (a) the level of complications involved would drop significantly and (2)
you'd be able to use the image-reading code already in the kernel without
any modifications.  It really looks like a win-win to me, doesn't it?

Rafael
