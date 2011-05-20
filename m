Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933068Ab1ETF7G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 01:59:06 -0400
Received: from a-pb-sasl-sd.pobox.com ([64.74.157.62]:39994 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157Ab1ETF7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 01:59:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:date:message-id:mime-version:content-type; q=dns; s=
	sasl; b=wn7WPvjvsPs9jLMbMc0qmWGRFrzLnR4vDzP/YF1rYcMMxRnxvCaY6+o7
	rRKjSUtkEz4tzSWo2y0PUKVxlfh5rP8xB3w31l3lB+SidtmfWwwa9O3Xug/pCSxB
	pWwOCCXEr+WZkAThBkqcJSxzmtiB3bXcRJNxAiR9UPQqJJr9am4=
From: Junio C Hamano <gitster@pobox.com>
To: git@vger.kernel.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [ANNOUNCE] Git 1.7.5.2
Date: Thu, 19 May 2011 22:58:52 -0700
Message-ID: <7voc2x52w3.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 8CDAC838-82A6-11E0-A1D6-BBB7F5B2FB1A-77302942!a-pb-sasl-sd.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest maintenance release Git 1.7.5.2 is available at the
usual places:

  http://www.kernel.org/pub/software/scm/git/

  git-1.7.5.2.tar.{gz,bz2}			(source tarball)
  git-htmldocs-1.7.5.2.tar.{gz,bz2}		(preformatted docs)
  git-manpages-1.7.5.2.tar.{gz,bz2}		(preformatted docs)

The RPM binary packages for a few architectures are found in:

  RPMS/$arch/git-*-1.7.5.2-1.fc13.$arch.rpm	(RPM)

Git v1.7.5.2 Release Notes
==========================

The release notes to 1.7.5.1 forgot to mention:

 * "git stash -p --no-keep-index" and "git stash --no-keep-index -p" now
   mean the same thing.

 * "git upload-pack" (hence "git push" over git native protocol) had a
   subtle race condition that could lead to a deadlock.

Fixes since v1.7.5.1
--------------------

 * "git add -p" did not work correctly when a hunk is split and then
   one of them was given to the editor.

 * "git add -u" did not resolve a conflict where our history deleted and
   their history modified the same file, and the working tree resolved to
   keep a file.

 * "git cvsimport" did not know that CVSNT stores its password file in a
   location different from the traditional CVS.

 * "git diff-files" did not show the mode information from the working
   tree side of an unmerged path correctly.

 * "git diff -M --cached" used to use unmerged path as a possible rename
   source candidate, which made no sense.

 * The option name parser in "git fast-import" used prefix matches for
   some options where it shouldn't, and accepted non-existent options,
   e.g. "--relative-marksmith" or "--forceps".

 * "git format-patch" did not quote RFC822 special characters in the
   email address (e.g From: Junio C. Hamano <jch@example.com>, not
   From: "Junio C. Hamano" <jch@example.com>).

 * "git format-patch" when run with "--quiet" option used to produce a
   nonsense result that consists of alternating empty output.

 * In "git merge", per-branch branch.<name>.mergeoptions configuration
   variables did not override the fallback default merge.<option>
   configuration variables such as merge.ff, merge.log, etc.

 * "git merge-one-file" did not honor GIT_WORK_TREE settings when
   handling a "both sides added, differently" conflict.

 * "git mergetool" did not handle conflicted submoudules gracefully.

 * "git-p4" (in contrib) used a wrong base image while merge a file that
   was added on both branches differently.

 * "git rebase -i -p" failed to preserve the history when there is a
   redundant merge created with the --no-ff option.

And other minor fixes and documentation updates.
