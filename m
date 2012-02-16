Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197Ab2BPWhU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 17:37:20 -0500
Received: from caiajhbdcahe.dreamhost.com ([208.97.132.74]:60092 "EHLO
	homiemail-a7.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751708Ab2BPWhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 17:37:16 -0500
X-Greylist: delayed 128670 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Feb 2012 17:37:16 EST
Subject: Re: [PATCH] locks: export device name
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Matthew Wilcox <matthew@wil.cx>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20120215123929.6888c867.akpm@linux-foundation.org>
References: <1328907967.3138.1.camel@offbook>
	 <20120213163425.dd9adfde.akpm@linux-foundation.org>
	 <20120214190906.GA5115@fieldses.org> <1329303162.3356.6.camel@offbook>
	 <20120215124230.GA11393@fieldses.org>
	 <20120215123929.6888c867.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Organization: GNU
Date: Thu, 16 Feb 2012 23:37:11 +0100
Message-ID: <1329431831.2753.3.camel@offbook>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-15 at 12:39 -0800, Andrew Morton wrote:
> On Wed, 15 Feb 2012 07:42:30 -0500
> "J. Bruce Fields" <bfields@fieldses.org> wrote:
> 
> > > > Perhaps safest would be to replace /proc/locks by another interface and
> > > > deprecate this one.
> > > 
> > > If exporting the name in the current /proc/locks file is out of the
> > > question, then IMHO I don't think it would be worth adding a new
> > > interface just for such a small change.
> > 
> > OK.
> > 
> > If you want to just change this over, I guess the thing to do would be
> > to stick something in feature-removal-schedule.txt saying "we'll switch
> > this in 2 years" (or however long you think before there are
> > realistically no more lslk users left), then do it then.
> > 
> > Switching to a new api would be better as we could warn users of the old
> > api then.  Maybe it'd be worth it if there was some other change we'd
> > been wanting to make?   Can't think of anything off the top of my head.
> > 
> > We may be adding more lock types--will lslk and lslocks handle that
> > gracefully?
> 
> Adding a whole new interface is pretty attractive.  It lets us get it
> right this time.  In particular, something which is extensible given
> certain simple rules.  As we've learned, the current /proc/locks didn't
> get that right!

Ok, however I'm a bit confused on what you mean by extensible; since
what we decide to export to userspace is pretty much permanent, how can
we change (extend) it later? We'd pretty much be running into
the /proc/locks situation now.

> 
> We can eventually remove the old code - it may take longer than two
> years, but whatever.  If we go this way, we should arrange for the
> kernel to emit a warning (printk_once) into the logs the first time
> someone accesses the old file.  This will help to prompt people to
> migrate off the deprecated interface.  After a while, we can add a
> config option to make the old interface go away.  Distros will start to
> disable the feature.  Later, we zap it altogether.

Kind if like what was done with the /proc/x/oom_adj interface.

