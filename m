Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760292Ab2BNT2v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 14:28:51 -0500
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:47675 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757126Ab2BNT2s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 14:28:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:subject
	:cc:date:message-id:mime-version:content-type
	:content-transfer-encoding; q=dns; s=sasl; b=JKIQmyAGTH7lGbSGeXs
	jsp39EcTRhFrjHvHD8ETn0+tF4htI6Xfxyj+GPqennyRL+0aYSYBB8kLXFVnnPvy
	lDWN8zGgLJIIySr1l+e5qsdazaVh5N9et84AbFxvQDcowPKmD3HDISrcbms8fqt+
	FYVT3K4VrqTuYokz/EPQ61+4=
From: Junio C Hamano <gitster@pobox.com>
To: git@vger.kernel.org
Subject: [ANNOUNCE] Git 1.7.9.1
cc: Linux Kernel <linux-kernel@vger.kernel.org>
Date: Tue, 14 Feb 2012 11:28:46 -0800
Message-ID: <7vk43p6wpd.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Pobox-Relay-ID: 1DA9EF86-5742-11E1-AEA0-9DB42E706CDE-77302942!b-pb-sasl-quonix.pobox.com
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest maintenance release Git 1.7.9.1 is now available at the usual
places.  This is primarily to fix various user experience kinks in the new
feature added in 1.7.9 release, so that there no longer is an excuse for
users to hold on to older releases.

The release tarballs are found at:

    http://code.google.com/p/git-core/downloads/list

and their SHA-1 checksums are:

bd85327627f96c4e98071a4d1d32c30f210aa54a  git-1.7.9.1.tar.gz
de5ad73499cfdb08e261bc481c84a75f11b7ff0f  git-htmldocs-1.7.9.1.tar.gz
8c6ee031b39da5c5e53f927952838796e0959ce9  git-manpages-1.7.9.1.tar.gz

Also the following public repositories all have a copy of the v1.7.9.1
tag and the maint branch that the tag points at:

  url = git://repo.or.cz/alt-git.git
  url = https://code.google.com/p/git-core/
  url = git://git.sourceforge.jp/gitroot/git-core/git.git
  url = git://git-core.git.sourceforge.net/gitroot/git-core/git-core
  url = https://github.com/gitster/git

Have fun.
----------------------------------------------------------------

Git v1.7.9.1 Release Notes
==========================

Fixes since v1.7.9
------------------

 * The makefile allowed environment variable X seep into it result in
   command names suffixed with unnecessary strings.

 * The set of included header files in compat/inet-{ntop,pton}
   wrappers was updated for Windows some time ago, but in a way that
   broke Solaris build.

 * rpmbuild noticed an unpackaged but installed *.mo file and failed.

 * Subprocesses spawned from various git programs were often left running
   to completion even when the top-level process was killed.

 * "git add -e" learned not to show a diff for an otherwise unmodified
   submodule that only has uncommitted local changes in the patch
   prepared by for the user to edit.

 * Typo in "git branch --edit-description my-tpoic" was not diagnosed.

 * Using "git grep -l/-L" together with options -W or --break may not
   make much sense as the output is to only count the number of hits
   and there is no place for file breaks, but the latter options made
   "-l/-L" to miscount the hits.

 * "git log --first-parent $pathspec" did not stay on the first parent
   chain and veered into side branch from which the whole change to the
   specified paths came.

 * "git merge --no-edit $tag" failed to honor the --no-edit option.

 * "git merge --ff-only $tag" failed because it cannot record the
   required mergetag without creating a merge, but this is so common
   operation for branch that is used _only_ to follow the upstream, so
   it was changed to allow fast-forwarding without recording the mergetag.

 * "git mergetool" now gives an empty file as the common base version
   to the backend when dealing with the "both sides added, differently"
   case.

 * "git push -q" was not sufficiently quiet.

 * When "git push" fails to update any refs, the client side did not
   report an error correctly to the end user.

 * "rebase" and "commit --amend" failed to work on commits with ancient
   timestamps near year 1970.

 * When asking for a tag to be pulled, "request-pull" did not show the
   name of the tag prefixed with "tags/", which would have helped older
   clients.

 * "git submodule add $path" forgot to recompute the name to be stored
   in .gitmodules when the submodule at $path was once added to the
   superproject and already initialized.

 * Many small corner case bugs on "git tag -n" was corrected.

Also contains minor fixes and documentation updates.

----------------------------------------------------------------

Changes since v1.7.9 are as follows:

Adrian Weimann (1):
      completion: --edit and --no-edit for git-merge

Albert Yale (1):
      grep: fix -l/-L interaction with decoration lines

Ben Walton (1):
      Drop system includes from inet_pton/inet_ntop compatibility wrappers

Clemens Buchacher (2):
      fix push --quiet: add 'quiet' capability to receive-pack
      dashed externals: kill children on exit

David Aguilar (1):
      mergetool: Provide an empty file when needed

Jakub Narebski (1):
      git.spec: Workaround localized messages not put in any RPM

Jeff King (4):
      run-command: optionally kill children on exit
      imap-send: remove dead code
      tag: fix output of "tag -n" when errors occur
      tag: die when listing missing or corrupt objects

Jens Lehmann (1):
      submodule add: fix breakage when re-adding a deep submodule

Johannes Schindelin (1):
      add -e: do not show difference in a submodule that is merely dirty

Junio C Hamano (15):
      server_supports(): parse feature list more carefully
      Making pathspec limited log play nicer with --first-parent
      request-pull: explicitly ask tags/$name to be pulled
      tests: add write_script helper function
      parse_date(): allow ancient git-timestamp
      parse_date(): '@' prefix forces git-timestamp
      merge: do not create a signed tag merge under --ff-only option
      branch --edit-description: protect against mistyped branch name
      Git 1.7.6.6
      Prepare for 1.7.9.1
      tag: do not show non-tag contents with "-n"
      merge: do not launch an editor on "--no-edit $tag"
      Update draft release notes to 1.7.9.1
      Update draft release notes to 1.7.9.1
      Git 1.7.9.1

Michael J Gruber (1):
      t5541: avoid TAP test miscounting

Michael Palimaka (1):
      Explicitly set X to avoid potential build breakage

Shawn O. Pearce (1):
      remote-curl: Fix push status report when all branches fail

Ævar Arnfjörð Bjarmason (3):
      Makefile: Change the default compiler from "gcc" to "cc"
      Remove Git's support for smoke testing
      t: use sane_unset instead of unset

