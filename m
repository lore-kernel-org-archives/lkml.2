Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758122Ab2AMNCX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 08:02:23 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:43068 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187Ab2AMNCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 08:02:22 -0500
Date: Fri, 13 Jan 2012 13:02:18 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Ian Kent <raven@themaw.net>
Cc: Dave Airlie <airlied@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Al Viro <viro@ftp.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: autofs4 hung task
Message-ID: <20120113130218.GJ23916@ZenIV.linux.org.uk>
References: <CAPM=9tzbgk=O6iTAM1Vp3SuZLkt7NnaMx0=+wbpW1x+sXk-3zA@mail.gmail.com>
 <1326458657.2219.24.camel@perseus.themaw.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326458657.2219.24.camel@perseus.themaw.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 13, 2012 at 08:44:17PM +0800, Ian Kent wrote:
> On Fri, 2012-01-13 at 10:26 +0000, Dave Airlie wrote:
> > Hi guys,
> > 
> > I booted Linus master kernel this morning (I was being brave and
> > basing some fixes on it), however it hung on boot and the stuck task
> > timer went off in autofs4 waiting on a mutex.
> > 
> > I got a picture with my phone attached.
> 
> Thanks Dave, an obvious mistake I missed in a recent commit by the look
> of it.
> 
> Ian

Grr...  Note to self: do git status *and* git stash show -p before git push.
Nothing like "WTF?  I'd fixed that braino" feeling ;-/

mutex_lock misspelled as mutex_unlock

Buggered-in: commit d668dc56631da067540b2494d2a1f29ff7b5f15a
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/fs/autofs4/waitq.c b/fs/autofs4/waitq.c
index 9ef5b29..da8876d 100644
--- a/fs/autofs4/waitq.c
+++ b/fs/autofs4/waitq.c
@@ -76,7 +76,7 @@ static int autofs4_write(struct autofs_sb_info *sbi,
 		data += wr;
 		bytes -= wr;
 	}
-	mutex_lock(&sbi->pipe_mutex);
+	mutex_unlock(&sbi->pipe_mutex);
 
 	set_fs(fs);
 
