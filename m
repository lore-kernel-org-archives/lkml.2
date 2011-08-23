Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021Ab1HWTpC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 15:45:02 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44634 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304Ab1HWTo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 15:44:56 -0400
Date: Tue, 23 Aug 2011 21:44:51 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: rjw@sisk.pl, menage@google.com, linux-kernel@vger.kernel.org,
        arnd@arndb.de
Subject: Re: [PATCH 06/16] freezer: make exiting tasks properly unfreezable
Message-ID: <20110823194451.GH2803@mtj.dyndns.org>
References: <1313763382-12341-1-git-send-email-tj@kernel.org>
 <1313763382-12341-7-git-send-email-tj@kernel.org>
 <20110823155221.GB25808@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110823155221.GB25808@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Aug 23, 2011 at 05:52:21PM +0200, Oleg Nesterov wrote:
> > @@ -915,6 +913,12 @@ NORET_TYPE void do_exit(long code)
> >
> >  	ptrace_event(PTRACE_EVENT_EXIT, code);
> >
> > +	/*
> > +	 * With ptrace notification done, there's no point in freezing from
> > +	 * here on.  Disallow freezing.
> > +	 */
> > +	current->flags |= PF_NOFREEZE;
> 
> OK, but what PF_NOFREEZE actually means?
> 
> Apart from "dont try to freeze" it means "no need to freeze", yes?

Yes.

> IOW, try_to_freeze_tasks() can succeed even if we have a lot of
> exitinig task which can make some activity, say, disk i/o. Is this
> correct?

Hmmm... can it cause disk IOs after that point?  I skimmed through and
couldn't spot one (the original code made simliar assumption albeit a
bit later).

Thanks.

-- 
tejun
