Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101Ab0IJXKJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 19:10:09 -0400
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:46525 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991Ab0IJXKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 19:10:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=to:subject:from
	:date:message-id:mime-version:content-type; q=dns; s=sasl; b=w0O
	rhrsV22cQOcTytg2c1v81un2t+htu17hZzISaNp007u4JKy+1G7E520MQ5/5G9I4
	ABzEOTCNRTYDr94vBjSHobKyrqQ8Rv9K2qq+XdwPInKiGC+X/ArhFl5i2KXU3KTu
	5prJMclolUwh3yDsEWz4MJziuJMe+mfvwj2CYNWg=
To: git@vger.kernel.org
Subject: [ANNOUNCE] Git 1.7.3.rc1
From: Junio C Hamano <gitster@pobox.com>
Date: Fri, 10 Sep 2010 16:09:59 -0700
Message-ID: <7vvd6dfb5k.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 8BCE9E56-BD30-11DF-8697-030CEE7EF46B-77302942!a-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A release candidate Git 1.7.3.rc1 is available at the usual places
for testing:

  http://www.kernel.org/pub/software/scm/git/

  git-1.7.3.rc1.tar.{gz,bz2}			(source tarball)
  git-htmldocs-1.7.3.rc1.tar.{gz,bz2}		(preformatted docs)
  git-manpages-1.7.3.rc1.tar.{gz,bz2}		(preformatted docs)

The RPM binary packages for a few architectures are found in:

  testing/git-*-1.7.3.rc1-1.fc11.$arch.rpm	(RPM)



Git v1.7.3 Release Notes (draft)
================================

Updates since v1.7.2
--------------------

 * git-gui got various updates and a new maintainer, Pat Thoyts.

 * Gitweb allows its configuration to change per each request; it used to
   read the configuration once upon startup.

 * When git finds a corrupt object, it now reports the file that contains
   it.

 * "git checkout -B <it>" is a shorter way to say "git branch -f <it>"
   followed by "git checkout <it>".

 * When "git checkout" or "git merge" refuse to proceed in order to
   protect local modification to your working tree, they used to stop
   after showing just one path that might be lost.  They now show all,
   in a format that is easier to read.

 * "git clean" learned "-e" ("--exclude") option.

 * Hunk headers produced for C# files by "git diff" and friends show more
   relevant context than before.

 * diff.ignoresubmodules configuration variable can be used to squelch the
   differences in submodules reported when running commands (e.g. "diff",
   "status", etc.) at the superproject level.

 * http.useragent configuration can be used to lie who you are to your
   restrictive firewall.

 * "git rebase --strategy <s>" learned "-X" option to pass extra options
   that are understood by the chosen merge strategy.

 * "git rebase -i" learned "exec" that you can insert into the insn sheet
   to run a command between its steps.

 * "git rebase" between branches that have many binary changes that do
   not conflict should be faster.

 * "git rebase -i" peeks into rebase.autosquash configuration and acts as
   if you gave --autosquash from the command line.


Also contains various documentation updates.


Fixes since v1.7.2
------------------

All of the fixes in v1.7.2.X maintenance series are included in this
release, unless otherwise noted.

 * "git merge -s recursive" (which is the default) did not handle cases
   where a directory becomes a file (or vice versa) very well.

 * "git fetch" and friends were accidentally broken for url with "+" in
   its path, e.g. "git://git.gnome.org/gtk+".

 * "git fetch $url" (i.e. without refspecs) was broken for quite some
   time, if the current branch happen to be tracking some remote.

 * "git note remove" created unnecessary extra commit when named object
   did not have any note to begin with.

 * "git -c foo=bar subcmd" did not work well for subcmd that is not
   implemented as a built-in command.
