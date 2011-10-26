Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab1JZXOs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 19:14:48 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:38522 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753181Ab1JZXOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 19:14:47 -0400
Message-ID: <1319670886.21924.22.camel@Joe-Laptop>
Subject: Re: [PATCH] checkpatch: improve error message for p1-check
From: Joe Perches <joe@perches.com>
To: David Rientjes <rientjes@google.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>, linux-kernel@vger.kernel.org,
        Jonathan Cameron <jic23@cam.ac.uk>, Andy Whitcroft <apw@canonical.com>
Date: Wed, 26 Oct 2011 16:14:46 -0700
In-Reply-To: <alpine.DEB.2.00.1110261607150.6982@chino.kir.corp.google.com>
References: <1319027583-17842-1-git-send-email-w.sang@pengutronix.de>
	 <alpine.DEB.2.00.1110261329240.23111@chino.kir.corp.google.com>
	 <1319669467.21924.18.camel@Joe-Laptop>
	 <alpine.DEB.2.00.1110261607150.6982@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-10-26 at 16:08 -0700, David Rientjes wrote:
> On Wed, 26 Oct 2011, Joe Perches wrote:
> > > > The old error message was not precise. State now explicitly that the
> > > > prefix exists as a file/directory. Also change the conclusion ("appears
> > > > to be") into an instruction ("make sure").
> > > Why can't we suppress this warning unless both prefixes appear as files or 
> > > directories in the cwd?  ('a' and 'b' if using git format-patch)
> > I sent a suggested patch that checked $root/$patched_file
> > https://lkml.org/lkml/2011/10/19/257
> So we need a combination of the two approaches then, it makes sense to 
> only emit the warning if the patched file exists in both prefixes.

I don't think so.  What about something like:

$ diff -urN kernel/foo~ kernel/foo > patch

I think we should only care about the patched file,.

