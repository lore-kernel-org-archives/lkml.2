Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186Ab1G0WKo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 18:10:44 -0400
Received: from mail.perches.com ([173.55.12.10]:4337 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755494Ab1G0WKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 18:10:40 -0400
Subject: Re: [U-Boot] [RFC PATCH] checkpatch.pl: Add ability to ignore
 various messages
From: Joe Perches <joe@perches.com>
To: Wolfgang Denk <wd@denx.de>
Cc: Andy Whitcroft <apw@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Graeme Russ <graeme.russ@gmail.com>,
        U-Boot Users <u-boot@lists.denx.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20110727211707.139ED15794C3@gemini.denx.de>
References: <1303713156.1745.38.camel@Joe-Laptop>
	 <b41636a5e5756917b07e50a4b8309dbb092b0a17.1303778411.git.joe@perches.com>
	 <20110727211707.139ED15794C3@gemini.denx.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Jul 2011 15:10:39 -0700
Message-ID: <1311804639.21169.22.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-07-27 at 23:17 +0200, Wolfgang Denk wrote:
> Dear Joe,
> In message <b41636a5e5756917b07e50a4b8309dbb092b0a17.1303778411.git.joe@perches.com> you wrote:
> > Some users would like the ability to not emit some of the
> > messages that checkpatch produces.
> > Add command line option to "--ignore" various message types.
> > Add .checkpatch.conf file to store a default set of "ignore" flags
> > Categorize all ERROR, WARN and CHK types with flags.
> > Signed-off-by: Joe Perches <joe@perches.com>
> > ---
> >  scripts/checkpatch.pl |  456 +++++++++++++++++++++++++++++++++++--------------
> >  1 files changed, 327 insertions(+), 129 deletions(-)
> Did you receive any feedback for your proposal, especially from Andrew
> Morton?
> This feature would be really useful for us, but I'd rather see this in
> mainline than starting a fork.

A better version is in Linus' current 3.0+ as of a couple of days ago.
It's not in 3.0.

commit 000d1cc1829f938c87402fc2fd4bb5e8daed6b52
Author: Joe Perches <joe@perches.com>
Date:   Mon Jul 25 17:13:25 2011 -0700

    checkpatch.pl: add ability to ignore various messages
    
    Some users would like the ability to not emit some of the messages that
    checkpatch produces.  This can make it easier to use checkpatch in other
    projects and integrate into scm hook scripts.
    
    Add command line option to "--ignore" various message types.  Add option
    --show-types to emit the "type" of each message.  Categorize all ERROR,
    WARN and CHK messages with types.
    
    Add optional .checkpatch.conf file to store default options.
    3 paths are searched for .checkpatch.conf
        .             customized per-tree configurations
        $HOME         user global configuration when per-tree configs don't exis
        ./scripts     lk defaults to override script
    The .conf file can contain any valid command-line argument and
    the contents are prepended to any additional command line arguments.
    Multiple lines may be used, blank lines are ignored, # is a comment.
    
    Update "false positive" output for readability.
    
    Update version to 0.32
    
    Signed-off-by: Joe Perches <joe@perches.com>
    Acked-by: Mike Frysinger <vapier@gentoo.org>
    Cc: Andy Whitcroft <apw@canonical.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>



