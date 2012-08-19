Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764Ab2HSUEr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 16:04:47 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:47061 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107Ab2HSUEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 16:04:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v1 2/3] PM / Sleep: introduce dpm_for_each_dev
Date: Sun, 19 Aug 2012 22:10:32 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: Ming Lei <ming.lei@canonical.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
References: <1345212420-1707-1-git-send-email-ming.lei@canonical.com> <201208182249.06296.rjw@sisk.pl> <20120819062011.GC1971@kroah.com>
In-Reply-To: <20120819062011.GC1971@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208192210.33072.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, August 19, 2012, Greg Kroah-Hartman wrote:
> On Sat, Aug 18, 2012 at 10:49:06PM +0200, Rafael J. Wysocki wrote:
> > On Saturday, August 18, 2012, Rafael J. Wysocki wrote:
> > > On Saturday, August 18, 2012, Ming Lei wrote:
> > > > On Sat, Aug 18, 2012 at 9:38 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > > >
> > > > > My question was about the number of current users of it.  Sorry for not
> > > > > being clear.
> > > > 
> > > > Sorry for misunderstanding your question.
> > > > 
> > > > >
> > > > > If there are no more anticipated users than the current only one, please
> > > > > drop the unused (void *) argument.  We can always extend it in the future
> > > > > if need be and for now passing that NULL every time is just pointless.
> > > > 
> > > > One usage is to get statistics info about devices for debug purpose,
> > > > so the parameter is needed to return something.
> > > 
> > > So, what's the name of the _second_ function using dpm_for_each_dev()?
> > > 
> > > I don't see any and device_cache_fw_images() in [3/3] clearly passes
> > > NULL as the first argument.
> > > 
> > > > > And please fold [2/3] into [3/3] in this series.
> > > > 
> > > > IMO, it is better to split them to avoid coupling between fw loader and
> > > > device PM.
> > > > 
> > > > Looks you agreed on the patch,
> > > 
> > > On the idea, not on the actual code.  I told you what I wanted to to change in
> > > it, didn't I?
> > > 
> > > > and Greg has added the
> > > > patch into his driver-core next tree to fix -next build failure, so could
> > > > you just let them be that?
> > > 
> > > -next is not cast in stone, you can replace patches in it with other ones
> > > if need be.
> > 
> > And it actually would be better if you replaced the patches that had introduced
> > the build problems with new fixed ones, because otherwise your whole series
> > has bisection issues potentially.
> > 
> > And since the Greg's patch queue is quilt-based, for what I can tell, that's
> > entirely doable.
> 
> No, my patch queue hasn't been quilt-based for almost 2 years now.  It's
> git-based, and I can revert anything that I need to, including this
> whole series, but I can't rewrite history, sorry.

Well, I was wrong, then, sorry.

Never mind, I'll clean up that mess later. :-)

By the way, that's why I started to use temporary branches that are only
merged into my linux-next branch and don't show up anywhere else for several
days until I'm quite confident they don't introduce silly build issues
for combinations of config options that the patch authors didn't anticipate
(sometimes they are combinations of config options that nobody saner than the
crazy monkey's brother Max whom Linus was talking about some time ago would
ever use in practice; and I honestly doubt that even Max would use some of
them, even on one of his worst days).

Afterward they are just renamed and published if there are no build issues
with them.  Otherwise, I can just nuke them entirely and re-create them from
scratch folding build fixes into the patches that introduced the build
problems.

Thanks,
Rafael
