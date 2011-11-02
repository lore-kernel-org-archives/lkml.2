Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200Ab1KBBXu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 21:23:50 -0400
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:50690 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752443Ab1KBBXr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 21:23:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:subject
	:cc:date:message-id:mime-version:content-type
	:content-transfer-encoding; q=dns; s=sasl; b=roPaRrj6QmyIrXj7NOC
	YgQCGbQbk1u3nkzrxAVBVBU2O1ETJvYYzHFiAS7N73p7RSnAznyKq7adeXeo7eFE
	vGy+lMMiblJ2cFDeR52c5nTI0NsBbbvGcYUo2XdRDbDhMdQpH4EQlI5EGZELYfcH
	erhY9lL8A99G4XfmSv+DKfGQ=
From: Junio C Hamano <gitster@pobox.com>
To: git@vger.kernel.org
Subject: [ANNOUNCE] Git 1.7.7.2
cc: Linux Kernel <linux-kernel@vger.kernel.org>
Date: Tue, 01 Nov 2011 18:23:43 -0700
Message-ID: <7v7h3jl3kw.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Pobox-Relay-ID: 4ED5F724-04F1-11E1-B09E-9DB42E706CDE-77302942!b-pb-sasl-quonix.pobox.com
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest maintenance release Git 1.7.7.2 is available.

The release tarballs are found at:

    http://code.google.com/p/git-core/downloads/list

and their SHA-1 checksums are:

be5be63fbab63517fcccf5c876749c61b0019d14  git-1.7.7.2.tar.gz
8f0eb6f1150ea8c6922343aa4c3ee6cf37e8a091  git-htmldocs-1.7.7.2.tar.gz
07e0887315224ac83c61ed60602c345c32a5d658  git-manpages-1.7.7.2.tar.gz

Also the following public repositories all have a copy of the v1.7.7.2
tag and the maint branch that the tag points at:

  url = git://repo.or.cz/alt-git.git
  url = https://code.google.com/p/git-core/
  url = git://git.sourceforge.jp/gitroot/git-core/git.git
  url = git://git-core.git.sourceforge.net/gitroot/git-core/git-core
  url = https://github.com/gitster/git

Git v1.7.7.2 Release Notes
==========================

Fixes since v1.7.7.1
--------------------

 * We used to drop error messages from libcurl on certain kinds of
   errors.

 * Error report from smart HTTP transport, when the connection was
   broken in the middle of a transfer, showed a useless message on
   a corrupt packet.

 * "git fetch --prune" was unsafe when used with refspecs from the
   command line.

 * The attribute mechanism did not use case insensitive match when
   core.ignorecase was set.

 * "git bisect" did not notice when it failed to update the working tree
   to the next commit to be tested.

 * "git config --bool --get-regexp" failed to separate the variable name
   and its value "true" when the variable is defined without "= true".

 * "git remote rename $a $b" were not careful to match the remote name
   against $a (i.e. source side of the remote nickname).

 * "git mergetool" did not use its arguments as pathspec, but as a path to
   the file that may not even have any conflict.

 * "git diff --[num]stat" used to use the number of lines of context
   different from the default, potentially giving different results from
   "git diff | diffstat" and confusing the users.

 * "git pull" and "git rebase" did not work well even when GIT_WORK_TREE is
   set correctly with GIT_DIR if the current directory is outside the working
   tree.

 * "git send-email" did not honor the configured hostname when restarting
   the HELO/EHLO exchange after switching TLS on.

 * "gitweb" used to produce a non-working link while showing the contents
   of a blob, when JavaScript actions are enabled.

----------------------------------------------------------------

Changes since v1.7.7.1 are as follows:

Brandon Casey (4):
      attr.c: avoid inappropriate access to strbuf "buf" member
      cleanup: use internal memory allocation wrapper functions everywhere
      builtin/mv.c: plug miniscule memory leak
      attr.c: respect core.ignorecase when matching attribute patterns

Carlos Martín Nieto (6):
      Remove 'working copy' from the documentation and C code
      fetch: free all the additional refspecs
      t5510: add tests for fetch --prune
      remote: separate out the remote_find_tracking logic into query_refspecs
      fetch: honor the user-provided refspecs when pruning refs
      fetch: treat --tags like refs/tags/*:refs/tags/* when pruning

Christian Couder (1):
      bisect: fix exiting when checkout failed in bisect_start()

Haitao Li (1):
      date.c: Support iso8601 timezone formats

Jakub Narebski (1):
      gitweb: Strip non-printable characters from syntax highlighter output

Jeff King (8):
      add sha1_array API docs
      quote.h: fix bogus comment
      refactor argv_array into generic code
      quote: provide sq_dequote_to_argv_array
      bisect: use argv_array API
      checkout: use argv_array API
      run_hook: use argv_array API
      pull,rebase: handle GIT_WORK_TREE better

Jim Meyering (1):
      make the sample pre-commit hook script reject names with newlines, too

Jonathan Nieder (2):
      http: remove extra newline in error message
      http: avoid empty error messages for some curl errors

Jonathon Mah (1):
      mergetool: Use args as pathspec to unmerged files

Junio C Hamano (5):
      refactor run_receive_hook()
      diff: teach --stat/--numstat to honor -U$num
      mergetool: no longer need to save standard input
      attr: read core.attributesfile from git_default_core_config
      Git 1.7.7.2

Martin von Zweigbergk (4):
      remote: write correct fetch spec when renaming remote 'remote'
      remote: "rename o foo" should not rename ref "origin/bar"
      remote rename: warn when refspec was not updated
      remote: only update remote-tracking branch if updating refspec

Matthew Daley (1):
      send-email: Honour SMTP domain when using TLS

Michael Haggerty (1):
      notes_merge_commit(): do not pass temporary buffer to other function

Michael J Gruber (3):
      unpack-trees: print "Aborting" to stderr
      git-read-tree.txt: language and typography fixes
      git-read-tree.txt: correct sparse-checkout and skip-worktree description

Nguyễn Thái Ngọc Duy (2):
      git-read-tree.txt: update sparse checkout examples
      Reindent closing bracket using tab instead of spaces

Pat Thoyts (1):
      t7511: avoid use of reserved filename on Windows.

Peter Stuge (1):
      gitweb: Fix links to lines in blobs when javascript-actions are enabled

Ramsay Allan Jones (1):
      t9159-*.sh: skip for mergeinfo test for svn <= 1.4

René Scharfe (1):
      read-cache.c: fix index memory allocation

Richard Hartmann (1):
      clone: Quote user supplied path in a single quote pair

Shawn O. Pearce (1):
      remote-curl: Fix warning after HTTP failure

Stefan Naewe (1):
      Documentation/git-update-index: refer to 'ls-files'

Thomas Rast (1):
      Documentation: basic configuration of notes.rewriteRef

