Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426Ab2BOUjc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 15:39:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54925 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595Ab2BOUja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 15:39:30 -0500
Date: Wed, 15 Feb 2012 12:39:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Davidlohr Bueso <dave@gnu.org>, Matthew Wilcox <matthew@wil.cx>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] locks: export device name
Message-Id: <20120215123929.6888c867.akpm@linux-foundation.org>
In-Reply-To: <20120215124230.GA11393@fieldses.org>
References: <1328907967.3138.1.camel@offbook>
	<20120213163425.dd9adfde.akpm@linux-foundation.org>
	<20120214190906.GA5115@fieldses.org>
	<1329303162.3356.6.camel@offbook>
	<20120215124230.GA11393@fieldses.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Feb 2012 07:42:30 -0500
"J. Bruce Fields" <bfields@fieldses.org> wrote:

> > > Perhaps safest would be to replace /proc/locks by another interface and
> > > deprecate this one.
> > 
> > If exporting the name in the current /proc/locks file is out of the
> > question, then IMHO I don't think it would be worth adding a new
> > interface just for such a small change.
> 
> OK.
> 
> If you want to just change this over, I guess the thing to do would be
> to stick something in feature-removal-schedule.txt saying "we'll switch
> this in 2 years" (or however long you think before there are
> realistically no more lslk users left), then do it then.
> 
> Switching to a new api would be better as we could warn users of the old
> api then.  Maybe it'd be worth it if there was some other change we'd
> been wanting to make?   Can't think of anything off the top of my head.
> 
> We may be adding more lock types--will lslk and lslocks handle that
> gracefully?

Adding a whole new interface is pretty attractive.  It lets us get it
right this time.  In particular, something which is extensible given
certain simple rules.  As we've learned, the current /proc/locks didn't
get that right!

We can eventually remove the old code - it may take longer than two
years, but whatever.  If we go this way, we should arrange for the
kernel to emit a warning (printk_once) into the logs the first time
someone accesses the old file.  This will help to prompt people to
migrate off the deprecated interface.  After a while, we can add a
config option to make the old interface go away.  Distros will start to
disable the feature.  Later, we zap it altogether.

