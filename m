Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012Ab0H1HDJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 03:03:09 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:37281 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720Ab0H1HDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 03:03:07 -0400
Date: Sat, 28 Aug 2010 09:03:05 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: John Johansen <john.johansen@canonical.com>,
        James Morris <jmorris@namei.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Comments to apparmor Makefile (and security/Makefile)
Message-ID: <20100828070305.GA8842@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John.

I took a closer at security/apparmor/Makefile.

And I got a few comments...

1) You have in the bottom explicit rules for three files:
   capability_names.h, rlim_names.h and af_names.h
   But the altter file is not referenced in any
   apparmor file.
   And there is no cmd_make-af variable defined.
   Looks like a leftover that shall be dropped.

2) clean-files fails to include rlim_names.h

3) The cmd_make-caps line is much too long.
   Please use "\" to break lines in smaller logical parts.
   Same goes with the other cdm_ line.

4) make-rlim delete the symbol AF_MAX - but that does not
  exist in the input file.

5) Two of the sed expressions looks almost equal - should they have been equal?

6) A small comment describing the purpose of each sed expression would be helpfull
   Something like:
# Transform lines from:
# #define FOO 123
# =>
# #define RLIM_FOO 123

7) af_names.h needs to be dropped in .gitignore

8) From security/Makefile:

    obj-$(CONFIG_SECURITY_APPARMOR)         += apparmor/built-in.o
This is _not_ how we do it.

We say just:

    obj-$(CONFIG_SECURITY_APPARMOR)         += apparmor/

[security/Makefile has this issue in several places]

There was a few tings that made me unsafe just providing a patch,
so for now you got a list of comments.

	Sam
