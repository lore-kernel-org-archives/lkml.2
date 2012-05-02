Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825Ab2EBWol (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 18:44:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43249 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718Ab2EBWok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 18:44:40 -0400
Date: Wed, 2 May 2012 15:44:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasikanth babu <sasikanth.v19@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] debugfs: New debugfs interface for creation of files,
 directory and symlinks
Message-Id: <20120502154438.8b44b5a3.akpm@linux-foundation.org>
In-Reply-To: <20120502223603.GA3103@kroah.com>
References: <1335963054-24750-1-git-send-email-sasikanth.v19@gmail.com>
	<20120502153100.GA2777@kroah.com>
	<CAOJFanXZEUfM4GQS62u4oR-KwywdLGOciOcgzmrM9zW+kOrXkg@mail.gmail.com>
	<20120502220417.GA2667@kroah.com>
	<20120502152003.d7b6aae9.akpm@linux-foundation.org>
	<20120502223603.GA3103@kroah.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 May 2012 15:36:03 -0700
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> > 
> > The API is stupid and wrong, actually.  There is no *advantage* to
> > having done it this way - none at all.
> 
> Yes there is, it makes the caller logic trivial, which was the main goal
> here in getting people to use it over creating new proc files all the
> time for no good reason.
> 
> No one cares about the return value when you create a proc file, either
> it succeeds or not, and you handle things from there, you never change
> the name to try it again.
> 
> Same thing with debugfs, you only care if it works or not, and really,
> you don't even care if it works, as the api lets you continue on if it
> didn't just fine.
> 
> These are debugging files, with no set rules on what they contain.  Yes,
> people have grown to get used to them over the years, but the namespace
> in which they work has worked out for itself, and I have yet to ever
> hear of any two people wanting to create the same file/directory
> anywhere, and have anything fail.
> 
> Or am I missing some subsystem that is having problems like this with
> debugfs?

grr, you appear to have ignored everything I wrote.  Here it is again:

> > That's the whole reason we have errnos: to report on what went wrong,
> > so operators can understand *why* it failed and so that programmers can
> > diagnose and fix bugs.

and

> > If well-written code checks the return value (as it should) and then
> > propagates an error code back to its caller (as it should), the stupid
> > debugfs interface forces that caller to invent an errno from thin air.
> > And if that guessed errno is wrong, it is actively misleading!

I would add that an interface which encourages callers to silently
ignore programming and configuration errors is not a good one.

