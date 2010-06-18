Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720Ab0FRGUV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 02:20:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48979 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752975Ab0FRGUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 02:20:20 -0400
Date: Thu, 17 Jun 2010 23:19:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Dan Carpenter <error27@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch] get rid of "cut here" from bug output
Message-Id: <20100617231902.9ce1e33e.akpm@linux-foundation.org>
In-Reply-To: <20100617123637.GA3492@kryptos.osrc.amd.com>
References: <20100617122156.GK5483@bicker>
	<20100617123637.GA3492@kryptos.osrc.amd.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jun 2010 14:36:37 +0200 Borislav Petkov <bp@amd64.org> wrote:

> From: Dan Carpenter <error27@gmail.com>
> Date: Thu, Jun 17, 2010 at 02:21:56PM +0200
> 
> > It's annoying to have chunks of dmesg output instead just the whole
> > output.  A lot of times the very interesting information is before
> > the bug happens.
> > 
> > Signed-off-by: Dan Carpenter <error27@gmail.com>
> > 
> > diff --git a/kernel/panic.c b/kernel/panic.c
> > index 3b16cd9..2db532a 100644
> > --- a/kernel/panic.c
> > +++ b/kernel/panic.c
> > @@ -373,7 +373,7 @@ static void warn_slowpath_common(const char *file, int line, void *caller,
> >  {
> >  	const char *board;
> >  
> > -	printk(KERN_WARNING "------------[ cut here ]------------\n");
> > +	printk(KERN_WARNING "-----[ paste whole dmesg to bugzilla ]-----\n");
> 
> Good idea, we end up requesting the whole dmesg most of the time anyway.
> However not all bugs are reported through bugzilla, and, frankly
> bugzilla is kinda sucky when it comes down to communicating with the bug
> reporter. How about the more generic "send whole dmesg when reporting"
> instead?

And the pestiferous thing wordwraps the dmesg output to death, making
it amazingly hard to read.  s/paste/attach/ maybe.

