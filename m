Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993Ab1BXRZv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 12:25:51 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:46647 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab1BXRZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 12:25:49 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=7fdJUjABhSQA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=HEr5SfK6YBcQWHrNMk0A:9 a=zh0BxKUPrMeEAGqn5NXcFjcUgV8A:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 1/2] staging: remove null checks before kfree
From: Steven Rostedt <rostedt@goodmis.org>
To: Greg KH <gregkh@suse.de>
Cc: Ilia Mirkin <imirkin@alum.mit.edu>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110224170619.GA7925@suse.de>
References: <1298364821-18915-1-git-send-email-imirkin@alum.mit.edu>
	 <20110224160828.GA888@home.goodmis.org>  <20110224170619.GA7925@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 24 Feb 2011 12:25:47 -0500
Message-ID: <1298568347.6376.3.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-24 at 09:06 -0800, Greg KH wrote:
> On Thu, Feb 24, 2011 at 11:08:29AM -0500, Steven Rostedt wrote:
> > On Tue, Feb 22, 2011 at 03:53:40AM -0500, Ilia Mirkin wrote:
> > > This patch was created with the following semantic patch:
> > > 
> > > // <smpl>
> > > @@
> > > expression E;
> > > @@
> > > 
> > > - if (E != NULL) kfree(E);
> > > + kfree(E);
> > > // </smpl>
> > 
> > OK, so when will we be removing the unlikely() from the implementations
> > of kfree()?
> > 
> > 	if (unlikely(ZERO_OR_NULL_PTR(block)))
> > 			return;
> 
> Have you run the tool that checks for unlikely being true here?  Odds
> are, even with all of these changes, the large majority of the time
> kfree is called, it has a valid pointer.

Crap, all my saved output files were in the /tmp directory and has since
been purged. I can reboot into the unlikely tracing kernel again, but
that may have to wait. I usually just do that at end of year as a
cleanup.

I can't remember exactly where kfree came in, but IIRC it was on the
list. Maybe not that high though.

-- Steve


