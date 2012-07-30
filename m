Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102Ab2G3WGO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 18:06:14 -0400
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:61282 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754966Ab2G3WGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 18:06:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:date:message-id:mime-version:content-type; q=dns; s=
	sasl; b=ksOA2e1WnOUDfnOoBnR6IX5COeLCn9+a53YvXT7homvwuR9hfFSKOwm1
	wLFKN+2XRKIvpqSxyVbHwaA2FqlF/lddu92fZMNt362jG16IIDbdn+Dw6Up4fMOE
	dEsH62uRL+PGubB0zGwSCiT5J6liriUwjq86wQG1/VoL98wuQdI=
From: Junio C Hamano <gitster@pobox.com>
To: git@vger.kernel.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [ANNOUNCE] Git v1.7.11.4
Date: Mon, 30 Jul 2012 15:06:08 -0700
Message-ID: <7vfw88q4z3.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: C4DB2FBC-DA92-11E1-8357-01B42E706CDE-77302942!b-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest maintenance release Git v1.7.11.4 is now available at
the usual places.

The release tarballs are found at:

    http://code.google.com/p/git-core/downloads/list

and their SHA-1 checksums are:

36180126eb2048d49b00f6092d83568df4e61c4c  git-1.7.11.4.tar.gz
ceb4b4699a6561719aa07e01601ed5491206c075  git-htmldocs-1.7.11.4.tar.gz
032301a87832d738149925ad2912baa554ae2270  git-manpages-1.7.11.4.tar.gz

Also the following public repositories all have a copy of the v1.7.11.4
tag and the maint branch that the tag points at:

  url = git://repo.or.cz/alt-git.git
  url = https://code.google.com/p/git-core/
  url = git://git.sourceforge.jp/gitroot/git-core/git.git
  url = git://git-core.git.sourceforge.net/gitroot/git-core/git-core
  url = https://github.com/gitster/git

Git v1.7.11.4 Release Notes
===========================

Fixes since v1.7.11.3
---------------------

 * "$GIT_DIR/COMMIT_EDITMSG" file that is used to hold the commit log
   message user edits was not documented.

 * The advise() function did not use varargs correctly to format
   its message.

 * When "git am" failed, old timers knew to check .git/rebase-apply/patch
   to see what went wrong, but we never told the users about it.

 * "git commit-tree" learned a more natural "-p <parent> <tree>" order
   of arguments long time ago, but recently forgot it by mistake.

 * "git diff --no-ext-diff" did not output anything for a typechange
   filepair when GIT_EXTERNAL_DIFF is in effect.

 * In 1.7.9 era, we taught "git rebase" about the raw timestamp format
   but we did not teach the same trick to "filter-branch", which rolled
   a similar logic on its own.

 * When "git submodule add" clones a submodule repository, it can get
   confused where to store the resulting submodule repository in the
   superproject's .git/ directory when there is a symbolic link in the
   path to the current directory.

Also contains minor typofixes and documentation updates.

----------------------------------------------------------------

Changes since v1.7.11.3 are as follows:

Jeff King (3):
      diff: test precedence of external diff drivers
      advice: pass varargs to strbuf_vaddf, not strbuf_addf
      commit: document the temporary commit message file

Jens Lehmann (1):
      submodules: don't stumble over symbolic links when cloning recursively

Junio C Hamano (7):
      filter-branch: do not forget the '@' prefix to force git-timestamp
      date.c: Fix off by one error in object-header date parsing
      t7003: add test to filter a branch with a commit at epoch
      commit-tree: resurrect command line parsing updates
      Revert "git-commit-tree(1): update synopsis"
      diff: correctly disable external_diff with --no-ext-diff
      Git 1.7.11.4

Paul Gortmaker (1):
      am: indicate where a failed patch is to be found

