Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119Ab1BXRMv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 12:12:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47796 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755499Ab1BXRMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 12:12:49 -0500
Date: Thu, 24 Feb 2011 09:06:19 -0800
From: Greg KH <gregkh@suse.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ilia Mirkin <imirkin@alum.mit.edu>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] staging: remove null checks before kfree
Message-ID: <20110224170619.GA7925@suse.de>
References: <1298364821-18915-1-git-send-email-imirkin@alum.mit.edu>
 <20110224160828.GA888@home.goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110224160828.GA888@home.goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 11:08:29AM -0500, Steven Rostedt wrote:
> On Tue, Feb 22, 2011 at 03:53:40AM -0500, Ilia Mirkin wrote:
> > This patch was created with the following semantic patch:
> > 
> > // <smpl>
> > @@
> > expression E;
> > @@
> > 
> > - if (E != NULL) kfree(E);
> > + kfree(E);
> > // </smpl>
> 
> OK, so when will we be removing the unlikely() from the implementations
> of kfree()?
> 
> 	if (unlikely(ZERO_OR_NULL_PTR(block)))
> 			return;

Have you run the tool that checks for unlikely being true here?  Odds
are, even with all of these changes, the large majority of the time
kfree is called, it has a valid pointer.

thanks,

greg k-h
