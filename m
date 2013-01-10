Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991Ab3AJQfA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 11:35:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36633 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753217Ab3AJQe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 11:34:56 -0500
Message-ID: <1357835679.1342.45.camel@localhost>
Subject: Re: Friendlier EPERM - Request for input
From: Eric Paris <eparis@redhat.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-kernel@vger.kernel.org, dwalsh@redhat.com, dmalcolm@redhat.com,
        sds@tycho.nsa.gov, segoon@openwall.com,
        linux-security-module@vger.kernel.org
Date: Thu, 10 Jan 2013 11:34:39 -0500
In-Reply-To: <201301110014.CDB90164.MFtFHVSQOFOJLO@I-love.SAKURA.ne.jp>
References: <1357747463.2593.28.camel@localhost>
	 <1357760637.2593.55.camel@localhost>
	 <201301110014.CDB90164.MFtFHVSQOFOJLO@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-01-11 at 00:14 +0900, Tetsuo Handa wrote:
> The reason I think is that people turn off LSMs because they are using LSMs
> without understanding "what the current configuration is" and/or "how to change
> configuration". People do not spend (or cannot afford spending) resources for
> understanding LSM's configuration.

This is not the point I am arguing.  This is not about LSMs, how hard
they are to configure, or how to 'fix' them.  It certainly isn't about
how one LSM is better, easier, or superior to another.  This is about
getting more information in userspace when operations fail.  I'll quote
an off list e-mail I received:

Friendlier/more complete error messages would eliminate an awful lot of
digging around trying to figure *what* the problem is, preparatory to
discerning *where* the problem is and *how* to fix it.

There are so many things that might go into fixing problems in an LSM.
That's what you are talking about, but it isn't relevant here.  This is
about knowing WHAT the problem is, maybe helping with where and how.
And this isn't just about LSM.  Heck, LSMs are just a small part of it.
I want extended errno interface to talk about DAC, capabilities, ACLs,
LSMs, everything!

> > The audit log is complete crap from a usability PoV.  If a web admin is
> 
> TOMOYO's audit log is very useful. TOMOYO is a security tool but is also useful
> for education/training/debugging/development/profiling etc.

The TOMOYO audit log is a very poor fit for this as well.  I'm not
trying to be rude, but there is no reasonable way for applications to
use it, it is TOMOYO specific, and it doesn't cover non-LSM errors.  I
want applications like httpd to be able to put what went wrong in its
log message.  I want python to be able to get extended information and
present that up the stack.  Nothing we have today comes close.  My
proposal isn't perfect, it suffers from the same problems as errno
(except even worse because it is harder to save and restore), but at
least it will usually be helpful...

-Eric

