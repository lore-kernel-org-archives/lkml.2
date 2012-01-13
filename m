Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758939Ab2AMTzX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 14:55:23 -0500
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:44678 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758977Ab2AMTzU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 14:55:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:subject
	:cc:date:message-id:mime-version:content-type
	:content-transfer-encoding; q=dns; s=sasl; b=BYbE594h7gnt1NuvYGE
	9iwVazphDERlXItzfhoonTZpG3dRrUzKHTo7lv6VYGCNkTt2HuhZKAo0TilvJgvp
	fxKI40pK9t/demE1yEORFpaxVQ387XGD+HY6AnCz4f077KWOT+KtgmNhvXU4ulds
	B5yF22RA75yMzY1cY2PgfMK0=
From: Junio C Hamano <gitster@pobox.com>
To: git@vger.kernel.org
Subject: [ANNOUNCE] Git 1.7.9.rc1
cc: Linux Kernel <linux-kernel@vger.kernel.org>
Date: Fri, 13 Jan 2012 11:55:16 -0800
Message-ID: <7vpqenxtqz.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Pobox-Relay-ID: 846996EE-3E20-11E1-B89B-9DB42E706CDE-77302942!b-pb-sasl-quonix.pobox.com
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A release candidate Git 1.7.9.rc1 is available for testing.

The release tarballs are found at:

    http://code.google.com/p/git-core/downloads/list

and their SHA-1 checksums are:

b97f10508f16b4117499cdfc4df9b19c725027d5  git-1.7.9.rc1.tar.gz
3064fc295a46440a91ca3f5fa622f5f1d40d3ba4  git-htmldocs-1.7.9.rc1.tar.gz
332e12061823d8def0fb823fa7798093bbe41279  git-manpages-1.7.9.rc1.tar.gz

Also the following public repositories all have a copy of the v1.7.9.rc1
tag and the master branch that the tag points at:

  url = git://repo.or.cz/alt-git.git
  url = https://code.google.com/p/git-core/
  url = git://git.sourceforge.jp/gitroot/git-core/git.git
  url = git://git-core.git.sourceforge.net/gitroot/git-core/git-core
  url = https://github.com/gitster/git

Git v1.7.9 Release Notes (draft)
========================

Updates since v1.7.8
--------------------

 * gitk updates accumulated since early 2011.

 * git-gui updated to 0.16.0.

 * git-p4 (in contrib/) updates.

 * Git uses gettext to translate its most common interface messages
   into the user's language if translations are available and the
   locale is appropriately set. Distributors can drop in new PO files
   in po/ to add new translations.

 * The code to handle username/password for HTTP transaction used in
   "git push" & "git fetch" learned to talk "credential API" to
   external programs to cache or store them, to allow integration with
   platform native keychain mechanisms.

 * The prompted input in the terminal use our own getpass() replacement
   when possible. HTTP transactions used to ask username without echoing
   back what was typed, but with this change you will see it as you type.

 * The internal of "revert/cherry-pick" has been tweaked to prepare
   building more generic "sequencer" on top of the implementation that
   drives them.

 * "git rev-parse FETCH_HEAD" after "git fetch" without specifying
   what to fetch from the command line will now show the commit that
   would be merged if the command were "git pull".

 * "git add" learned to stream large files directly into a packfile
   instead of writing them into individual loose object files.

 * "git checkout -B <current branch> <elsewhere>" is a more intuitive
   way to spell "git reset --keep <elsewhere>".

 * "git checkout" and "git merge" learned "--no-overwrite-ignore" option
   to tell Git that untracked and ignored files are not expendable.

 * "git commit --amend" learned "--no-edit" option to say that the
   user is amending the tree being recorded, without updating the
   commit log message.

 * "git commit" and "git reset" re-learned the optimization to prime
   the cache-tree information in the index, which makes it faster to
   write a tree object out after the index entries are updated.

 * "git commit" detects and rejects an attempt to stuff NUL byte in
   the commit log message.

 * "git commit" learned "-S" to GPG-sign the commit; this can be shown
   with the "--show-signature" option to "git log".

 * fsck and prune are relatively lengthy operations that still go
   silent while making the end-user wait. They learned to give progress
   output like other slow operations.

 * The set of built-in function-header patterns for various languages
   knows MATLAB.

 * "git log --format='<format>'" learned new %g[nNeE] specifiers to
   show information from the reflog entries when warlking the reflog
   (i.e. with "-g").

 * "git pull" can be used to fetch and merge an annotated/signed tag,
   instead of the tip of a topic branch. The GPG signature from the
   signed tag is recorded in the resulting merge commit for later
   auditing.

 * "git log" learned "--show-signature" option to show the signed tag
   that was merged that is embedded in the merge commit. It also can
   show the signature made on the commit with "git commit -S".

 * "git branch --edit-description" can be used to add descriptive text
   to explain what a topic branch is about.

 * "git fmt-merge-msg" learned to take the branch description into
   account when preparing a merge summary that "git merge" records
   when merging a local branch.

 * "git request-pull" has been updated to convey more information
   useful for integrators to decide if a topic is worth merging and
   what is pulled is indeed what the requestor asked to pull,
   including:

   - the tip of the branch being requested to be merged;
   - the branch description describing what the topic is about;
   - the contents of the annotated tag, when requesting to pull a tag.

 * "git pull" learned to notice 'pull.rebase' configuration variable,
   which serves as a global fallback for setting 'branch.<name>.rebase'
   configuration variable per branch.

 * "git tag" learned "--cleanup" option to control how the whitespaces
   and empty lines in tag message are cleaned up.

 * "gitweb" learned to show side-by-side diff.

Also contains minor documentation updates and code clean-ups.


Fixes since v1.7.8
------------------

Unless otherwise noted, all the fixes since v1.7.8 in the maintenance
releases are contained in this release (see release notes to them for
details).

----------------------------------------------------------------

Changes since v1.7.9-rc0 are as follows:

Ben Walton (1):
      Use perl instead of sed for t8006-blame-textconv test

Carlos Martín Nieto (1):
      archive: re-allow HEAD:Documentation on a remote invocation

Clemens Buchacher (1):
      credentials: unable to connect to cache daemon

Jeff King (5):
      send-email: multiedit is a boolean config option
      attr: don't confuse prefixes with leading directories
      attr: drop misguided defensive coding
      attr: fix leak in free_attr_elem
      thin-pack: try harder to use preferred base objects as base

Junio C Hamano (11):
      attr.c: make bootstrap_attr_stack() leave early
      attr.c: clarify the logic to pop attr_stack
      Documentation: rerere's rr-cache auto-creation and rerere.enabled
      Prepare for 1.7.6.6
      Prepare for 1.7.7.6
      Prepare for 1.7.8.4
      request-pull: use the real fork point when preparing the message
      Update draft release notes to 1.7.6.6
      Update draft release notes to 1.7.7.6
      Update draft release notes to 1.7.8.4
      Git 1.7.9-rc1

Matthieu Moy (1):
      gitweb: accept trailing "/" in $project_list

Michael Haggerty (3):
      receive-pack: move more work into write_head_info()
      show_ref(): remove unused "flag" and "cb_data" arguments
      write_head_info(): handle "extra refs" locally

Nguyễn Thái Ngọc Duy (1):
      t2203: fix wrong commit command

Sebastian Schuberth (2):
      t9200: On MSYS, do not pass Windows-style paths to CVS
      git-cvsexportcommit: Fix calling Perl's rel2abs() on MSYS

Thomas Rast (1):
      mailinfo documentation: accurately describe non -k case

