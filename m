Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933898Ab0FFAkg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 20:40:36 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:8619 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933768Ab0FFAkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 20:40:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=u0XcfFfz4xV18B4G9p9kMTcGxO4rO+huNccl/Feog5yF+xUlIMgi1a2l2pa6nMmRaT
         s6ce3NqWrD9CqoSTF28UMyIGJpC3uvfnOZZ0QEw8iDt/F3FoR4IYVLTUziQ/c69lVO13
         lQKQ9qRPR7rh3qpFp794LBhNE4ElqU/E16BZA=
Subject: Re: [linux-pm] [SUSPECTED SPAM] Re: Proposal for a new algorithm 
 for	reading & writing a hibernation image.
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Nigel Cunningham <ncunningham@crca.org.au>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       TuxOnIce-devel <tuxonice-devel@tuxonice.net>
In-Reply-To: <201006052121.45816.rjw@sisk.pl>
References: <9rpccea67yy402c975fqru8r.1275576653521@email.android.com>
	 <201006052045.19889.rjw@sisk.pl> <1275765021.12828.2.camel@maxim-laptop>
	 <201006052121.45816.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 06 Jun 2010 03:40:28 +0300
Message-ID: <1275784828.17835.4.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-06-05 at 21:21 +0200, Rafael J. Wysocki wrote: 
> On Saturday 05 June 2010, Maxim Levitsky wrote:
> > On Sat, 2010-06-05 at 20:45 +0200, Rafael J. Wysocki wrote: 
> > > On Saturday 05 June 2010, Nigel Cunningham wrote:
> > > > Hi again.
> > > > 
> > > > As I think about this more, I reckon we could run into problems at 
> > > > resume time with reloading the image. Even if some bits aren't modified 
> > > > as we're writing the image, they still might need to be atomically 
> > > > restored. If we make the atomic restore part too small, we might not be 
> > > > able to do that.
> > > > 
> > > > So perhaps the best thing would be to stick with the way TuxOnIce splits 
> > > > the image at the moment (page cache / process pages vs 'rest'), but 
> > > > using this faulting mechanism to ensure we do get all the pages that are 
> > > > changed while writing the first part of the image.
> > > 
> > > I still don't quite understand why you insist on saving the page cache data
> > > upfront and re-using the memory occupied by them for another purpose.  If you
> > > dropped that requirement, I'd really have much less of a problem with the
> > > TuxOnIce's approach.
> > Because its the biggest advantage?
> 
> It isn't in fact.
> 
> > Really saving whole memory makes huge difference.
> 
> You don't have to save the _whole_ memory to get the same speed (you don't
> do that anyway, but the amount of data you don't put into the image with
> TuxOnIce is smaller).  Something like 80% would be just sufficient IMO and
> then (a) the level of complications involved would drop significantly and (2)
> you'd be able to use the image-reading code already in the kernel without
> any modifications.  It really looks like a win-win to me, doesn't it?


Well, in fact on modern systems its not possible to save 100% of ram
even if we save it all because of video memory.
Look I got 256MB of video ram, and when compiz is used I say most of it
is used, and its isn't going to be magically preserved during suspend.
So system still has to free about 256MB of memory before suspend (which
means around 80% percent of ram is saved in best case :-) )

Best regards,
Maxim Levitsky


