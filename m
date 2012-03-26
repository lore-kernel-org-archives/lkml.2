Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269Ab2CZU6H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 16:58:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39353 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752255Ab2CZU6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 16:58:06 -0400
Date: Mon, 26 Mar 2012 22:58:04 +0200
From: Michal Marek <mmarek@suse.cz>
To: Roland Dreier <roland@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] setlocalversion: Use "grep -q" instead of piping output
 to "read dummy"
Message-ID: <20120326205804.GE10259@sepie.suse.cz>
References: <1332520947-22172-1-git-send-email-roland@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332520947-22172-1-git-send-email-roland@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2012 at 09:42:27AM -0700, Roland Dreier wrote:
> From: Roland Dreier <roland@purestorage.com>
> 
> In some circumstances (eg when running a build in an emacs shell
> buffer), I get a spew of messages like
> 
>     grep: writing output: Broken pipe
> 
> from setlocalversion, because the "read" subshell apparently exits as
> soon as it reads one line and gives EPIPE to grep.  It's not clear to
> me why this way of writing the check was used instead of just using
> grep -q to suppress output, but unless there is some deep reason I
> don't know, this way looks cleaner to me anyway, and gets rid of the
> ugly message spew.

I guess the author was used to write it this way, because ancient grep
versions did not have -q.


> (I double checked at http://pubs.opengroup.org/onlinepubs/009604499/utilities/grep.html
> and "grep -q" is specified in POSIX / SuS, so hopefully even people
> cross-compiling the kernel on some bizarre host OS can't complain
> about this change)

Yeah, I think it's safe. Thanks for double-checking.

Applied to kbuild.git#kbuild now.

Michal
