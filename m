Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002Ab1AFUxr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 15:53:47 -0500
Received: from cantor.suse.de ([195.135.220.2]:54069 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753349Ab1AFUxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 15:53:46 -0500
Date: Thu, 6 Jan 2011 12:52:59 -0800
From: Greg KH <gregkh@suse.de>
To: Ferenc Wagner <wferi@niif.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Replace the dangerous to_root_device macro with an
 inline function
Message-ID: <20110106205259.GA28326@suse.de>
References: <44482f820e5700f952825c9b5ec6a9f080975d79.1294326889.git.wferi@niif.hu>
 <20110106162032.GA10189@suse.de>
 <87zkrd3gkz.fsf@tac.ki.iif.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zkrd3gkz.fsf@tac.ki.iif.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 06, 2011 at 09:47:08PM +0100, Ferenc Wagner wrote:
> Greg KH <gregkh@suse.de> writes:
> 
> > On Thu, Jan 06, 2011 at 04:24:24PM +0100, Ferenc Wagner wrote:
> >
> >> The original macro worked only when applied to variables named 'dev'.
> >> While this could have been fixed by simply renaming the macro argument,
> >> a more type-safe replacement is preferred.
> >
> > Preferred for what?  This is a local macro, not exported to anything
> > else, is it causing problems today within this single file?
> 
> No, it isn't a problem currently, because this macro is applied to
> variables named 'dev' exclusively.  But the macro definition is wrong,
> as it uses 'dev' (the macro argument) in two places, of which the second
> probably isn't intentional, as the third argument of the container_of
> macro is a structure member name, which should stay fixed to the literal
> string 'dev' in this case, not replaced by the actual macro argument.

No, it was intentional :)

> So you've got the choice of leaving things as they are and happen to
> work for the moment, fixing the definition of the to_root_device macro
> to use some other token as the name of the free variable instead of
> 'dev', or to replace the macro with a function, which provides some
> type-checking advantages during compilation as well.  I thought this was
> a general reason for preferring inline functions over preprocessor
> macros in the kernel codebase, but maybe I was wrong.

No, you are correct, but as this is a macro that is limited to a single
file, and there's no problem with it as-is today, the need to change it
is quite low.

I'll take this as a general "clean up" patch, if you resend it with the
2/2 removed.  But note that it will not get added to my trees until
after the .38-rc1 merge happens.

thanks,

greg k-h
