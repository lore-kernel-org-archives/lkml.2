Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040Ab1HOVhM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 17:37:12 -0400
Received: from c60.cesmail.net ([216.154.195.49]:37505 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752821Ab1HOVhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 17:37:11 -0400
Date: Mon, 15 Aug 2011 17:37:06 -0400
From: Pavel Roskin <proski@gnu.org>
To: linux-kernel@vger.kernel.org
Subject: Suppressing a plus from setlocalversion
Message-ID: <20110815173706.12ccfdd4@mj>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

There is one annoyance in the build system that I cannot work around.
Before I attempt hacking the code, I'd like to make sure I'm not
missing anything obvious.

Suppose that I have a kernel version 3.1-rc2.  I want to test some patch
for some code that is compiled as a module.  I change the code and
create a patch with STGit.  I recompile the modules, install them by
"make module_install", unload the module I patched, load it again
and find that there is no effect from my change.  It turns out that the
modules were installed to "/lib/modules/3.1.0-rc2+" and the plus was
added by scripts/localversion because the source tree is now modified.

So I recompile the whole kernel, reboot and continue working on my
patch.  Many days later, I'm about to send my patch, but I want to
retest the system without it, so I "stg pop" it, recompile the
module, install it and find that the unpatched module behaves just like
the patched one.  Of course, it turns out that the unpatched
module ended up in "/lib/modules/3.1.0-rc2", whereas modprobe keeps
loading the modified module from "/lib/modules/3.1.0-rc2+"

CONFIG_LOCALVERSION_AUTO is unset, but that doesn't stop
scripts/localversion from adding the plus.  Setting CONFIG_LOCALVERSION
doesn't help.  Setting LOCALVERSION on the make command line helps, but
it needs to be done every time, and it's too easy to forget.  I don't
want to write a wrapper around make, it would be too intrusive
(actually, it's my solution for now).

Adding anything to localversion* doesn't suppress the plus.  Keeping
some patch in STGit all the time is quite annoying, I'll eventually end
up sending it to some mailing list by mistake.  STGit cannot hide
applied patches.  Besides, I'll need to be aware of the patch when
switching branches.

File .scmversion is only read from the source directory, so having it
is equivalent to having a modified source all the time, which is what
I'm trying to avoid.  Sure, I can keep .scmversion not in git, but I
risk to clean it up with "git clean" eventually.

If there is no simple solution with the existing code, maybe
non-empty CONFIG_LOCALVERSION should suppress the plus just like
LOCALVERSION?

Or maybe CONFIG_LOCALVERSION_AUTO should be not yes/no, but
full/minimal/no?

-- 
Regards,
Pavel Roskin
