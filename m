Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323Ab1HRH7G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 03:59:06 -0400
Received: from wondertoys-mx.wondertoys.net ([206.117.179.246]:49155 "EHLO
	labridge.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755228Ab1HRH7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 03:59:03 -0400
Subject: Re: [PATCH] checkpatch: do not test/warn of leading whitespace
 before signature tags
From: Joe Perches <joe@perches.com>
To: jeffrey.t.kirsher@intel.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Allan, Bruce W" <bruce.w.allan@intel.com>,
        Anish Kumar <anish198519851985@gmail.com>,
        Andy Whitcroft <apw@canonical.com>
In-Reply-To: <1313653632.2128.88.camel@jtkirshe-mobl>
References: <1313650112-17287-1-git-send-email-jeffrey.t.kirsher@intel.com>
	 <1313652390.32547.53.camel@Joe-Laptop>
	 <1313653632.2128.88.camel@jtkirshe-mobl>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Aug 2011 00:59:01 -0700
Message-ID: <1313654341.32547.62.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-18 at 00:47 -0700, Jeff Kirsher wrote:
> On Thu, 2011-08-18 at 00:26 -0700, Joe Perches wrote:
> > On Wed, 2011-08-17 at 23:48 -0700, Jeff Kirsher wrote:
> > > From: Bruce Allan <bruce.w.allan@intel.com>
> > > 
> > > Commit 2011247 introduced additional style checks for signature tags in
> > > patches which is good.  Unfortunately, now whenever patches are checked
> > > by piping the output of 'git show' or 'stg show' through checkpatch it
> > > warns not to use whitespace before all signature tags since these (and the
> > > rest of the patch description) are indented.  Remove this test/warning.
> > 
> > I think this is not a good idea.
> > 
> > checkpatch is meant for patches not git log output.
> > indenting signatures can cause other problems later.
> > 
> > I think you can avoid this easily by using checkpatch
> > option --ignore=BAD_SIGN_OFF when using git log output
> > as input.
> 
> The problem I have with this is that the sign-off's are not bad, they
> are by default indented by 'git show' or 'stg show' so checkpatch.pl
> should handle the "default" formatting of git/stg and if there is
> additional indenting not expected, then the sign-off's should be
> considered bad.

I disagree.

checkpatch should handle the default input of patches
as best it can.

I suppose checkpatch could have a different "--input=git"
or some such to avoid certain things that git might produce
that a patch would not.

Deleting useful checks for patches isn't a good idea.

> If this option is added, then if there were "real"
> problems with the sign-off, it would not be displayed.

So what?

It would also be too late to do anything about
it anyway as it would already be committed.

> > You could also use: 
> > git log --format="commit %H%nAuthor: %an <%ae>%nDate:   %aD%n%n%s%n%n%b"
> > so that you get the current default --format=medium
> > output without indenting the commit log body.
> Even doing this does not resolve the "false" warnings" that
> checkpatch.pl produces regarding the sign-off's.

I tried it.  It works for me.
What about it doesn't work for you?


