Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935450Ab1ETJ70 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 05:59:26 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64691 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934590Ab1ETJ7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 05:59:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TQkBlc13n1kNq49fuvWoolBcunKQsSRkJnGAAKE3aQyJTfqQmGq0EusPr8/6LyBtal
         ALYK28rsE58dWrMcpX0JPv4mfmVS9QjHKylB9i8lfnL68bN5E4Hf36zP2Dm887/x9PK9
         YZe6S5Z9zGLU/ZXSYT9Utdli20aInWvAx3G24=
Date: Fri, 20 May 2011 13:59:20 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Kees Cook <kees.cook@canonical.com>,
        Eugene Teo <eugeneteo@gmail.com>
Subject: Re: [RFC] add mount options to sysfs
Message-ID: <20110520095920.GA4489@albatros>
References: <20110518163142.GA3367@albatros>
 <20110518163951.GA24143@suse.de>
 <20110518170545.GA4435@albatros>
 <20110518191727.GA26741@suse.de>
 <20110519062622.GA4418@albatros>
 <20110519171227.GB22019@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110519171227.GB22019@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 10:12 -0700, Greg KH wrote:
> On Thu, May 19, 2011 at 10:26:23AM +0400, Vasiliy Kulikov wrote:
> > On Wed, May 18, 2011 at 12:17 -0700, Greg KH wrote:
> > > Maybe, but fixing the file would be the obvious solution.
> > 
> > I mean for a sysadmin, not for a developer.
> 
> And I mean for the developer.
> 
> We have checks in place now to prevent this type of thing from happening
> again in the future.  If it does, and it might, we will fix it, it's
> that simple.

Simple indeed.  But not as fast as simple:

https://lkml.org/lkml/2011/2/4/74
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=49d50fb1c28738ef6bad0c2b87d5355a1653fed5

More than 40 days from the report to the actual commit.  Sometimes it
needs some workaround.

> > What do you mean by "breaking system"?  Root is able to chmod
> > and chown sysfs files already, he may do "chmod -R" or similar.
> > I suggest sane, race free way to globally restrict permissions *IF* root
> > wants it.
> 
> If root wants it, they can do this today with a simple 1 line bash
> command, so I don't see the issue.

The issue is a race condition between the file creation and chmod'ing.

> > Here https://lkml.org/lkml/2011/2/25/300 you, not aware of usefull
> > applications of world-writable debugfs file, agreeded to statically
> > restrict permissions of all files.  I suggest more flexible and
> > configurable in runtime solution.  It doesn't break anything - default
> > behaviour doesn't differ from current one.  What has changed in your
> > mind since 2/25?
> 
> That's debugfs, not sysfs, which we are talking about here, right?

Correct.  So, if I understood you, you are OK with adding mount options
for debugfs, but not sysfs, right?  What is the difference between them
in sense of permissions?


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
