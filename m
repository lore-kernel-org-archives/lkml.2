Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441Ab2HSGUU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 02:20:20 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49949 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538Ab2HSGUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 02:20:17 -0400
Date: Sat, 18 Aug 2012 23:20:11 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Ming Lei <ming.lei@canonical.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH v1 2/3] PM / Sleep: introduce dpm_for_each_dev
Message-ID: <20120819062011.GC1971@kroah.com>
References: <1345212420-1707-1-git-send-email-ming.lei@canonical.com>
 <CACVXFVMxGCGJ+a=rfcCAqRuUMLG9OD3X52MMzTcfYOT4cepBGQ@mail.gmail.com>
 <201208182233.37188.rjw@sisk.pl>
 <201208182249.06296.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208182249.06296.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 18, 2012 at 10:49:06PM +0200, Rafael J. Wysocki wrote:
> On Saturday, August 18, 2012, Rafael J. Wysocki wrote:
> > On Saturday, August 18, 2012, Ming Lei wrote:
> > > On Sat, Aug 18, 2012 at 9:38 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > >
> > > > My question was about the number of current users of it.  Sorry for not
> > > > being clear.
> > > 
> > > Sorry for misunderstanding your question.
> > > 
> > > >
> > > > If there are no more anticipated users than the current only one, please
> > > > drop the unused (void *) argument.  We can always extend it in the future
> > > > if need be and for now passing that NULL every time is just pointless.
> > > 
> > > One usage is to get statistics info about devices for debug purpose,
> > > so the parameter is needed to return something.
> > 
> > So, what's the name of the _second_ function using dpm_for_each_dev()?
> > 
> > I don't see any and device_cache_fw_images() in [3/3] clearly passes
> > NULL as the first argument.
> > 
> > > > And please fold [2/3] into [3/3] in this series.
> > > 
> > > IMO, it is better to split them to avoid coupling between fw loader and
> > > device PM.
> > > 
> > > Looks you agreed on the patch,
> > 
> > On the idea, not on the actual code.  I told you what I wanted to to change in
> > it, didn't I?
> > 
> > > and Greg has added the
> > > patch into his driver-core next tree to fix -next build failure, so could
> > > you just let them be that?
> > 
> > -next is not cast in stone, you can replace patches in it with other ones
> > if need be.
> 
> And it actually would be better if you replaced the patches that had introduced
> the build problems with new fixed ones, because otherwise your whole series
> has bisection issues potentially.
> 
> And since the Greg's patch queue is quilt-based, for what I can tell, that's
> entirely doable.

No, my patch queue hasn't been quilt-based for almost 2 years now.  It's
git-based, and I can revert anything that I need to, including this
whole series, but I can't rewrite history, sorry.

greg k-h
