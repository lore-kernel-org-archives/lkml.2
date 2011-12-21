Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308Ab1LUWei (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 17:34:38 -0500
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:33160 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752587Ab1LUWef convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 17:34:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:subject
	:date:message-id:mime-version:content-type
	:content-transfer-encoding; q=dns; s=sasl; b=gl/+ekPjE8J4gZ2J7nw
	zSijwAnsippv3haAGOkRtNd3h7NLYRRgfm4oT16giiVrSn8bEhdiaZPAms8zMkto
	KaW+I0dsMzfrqCVo9lD4xSp4DYwf+dDq5C9qI2heVG9NNKkBUXS3V3xjIOz5mofa
	zFehjYyv3mTroDV1Yo49TazI=
From: Junio C Hamano <gitster@pobox.com>
To: git@vger.kernel.org
Subject: [ANNOUNCE] Git 1.7.8.1
Date: Wed, 21 Dec 2011 14:34:32 -0800
Message-ID: <7v1urxftaf.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Pobox-Relay-ID: F4960808-2C23-11E1-98EA-9DB42E706CDE-77302942!b-pb-sasl-quonix.pobox.com
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest maintenance release Git 1.7.8.1 is available.  Note that this
is not a release with new features (upcoming 1.7.9 is expected to be
released late January next year to include the pulling of signed tags and
other goodies).

The release tarballs are found at:

    http://code.google.com/p/git-core/downloads/list

and their SHA-1 checksums are:

198e23e6e50245331590a6159ccdbdbe1792422c  git-1.7.8.1.tar.gz
8f674dba39d9ae78928abfe9d924b0855e283e98  git-htmldocs-1.7.8.1.tar.gz
b49ce0b4da4f85671693c9b2c6f6a8b8ee65c809  git-manpages-1.7.8.1.tar.gz

Also the following public repositories all have a copy of the v1.7.8.1
tag and the maint branch that the tag points at:

  url = git://repo.or.cz/alt-git.git
  url = https://code.google.com/p/git-core/
  url = git://git.sourceforge.jp/gitroot/git-core/git.git
  url = git://git-core.git.sourceforge.net/gitroot/git-core/git-core
  url = https://github.com/gitster/git


Git v1.7.8.1 Release Notes
==========================

Fixes since v1.7.8
------------------

 * In some codepaths (notably, checkout and merge), the ignore patterns
   recorded in $GIT_DIR/info/exclude were not honored. They now are.

 * "git apply --check" did not error out when given an empty input
   without any patch.

 * "git archive" mistakenly allowed remote clients to ask for commits
   that are not at the tip of any ref.

 * "git checkout" and "git merge" treated in-tree .gitignore and exclude
   file in $GIT_DIR/info/ directory inconsistently when deciding which
   untracked files are ignored and expendable.

 * LF-to-CRLF streaming filter used when checking out a large-ish blob
   fell into an infinite loop with a rare input.

 * The function header pattern for files with "diff=cpp" attribute did
   not consider "type *funcname(type param1,..." as the beginning of a
   function.

 * The error message from "git diff" and "git status" when they fail
   to inspect changes in submodules did not report which submodule they
   had trouble with.

 * After fetching from a remote that has very long refname, the reporting
   output could have corrupted by overrunning a static buffer.

 * "git pack-objects" avoids creating cyclic dependencies among deltas
   when seeing a broken packfile that records the same object in both
   the deflated form and as a delta.

Also contains minor fixes and documentation updates.

----------------------------------------------------------------

Changes since v1.7.8 are as follows:

Brandon Casey (2):
      t/t4131-apply-fake-ancestor.sh: fix broken test
      builtin/apply.c: report error on failure to recognize input

Carlos Martín Nieto (2):
      convert: track state in LF-to-CRLF filter
      clone: the -o option has nothing to do with <branch>

Erik Faye-Lund (1):
      mingw: give waitpid the correct signature

Jack Nagel (1):
      Documentation: fix formatting error in merge-options.txt

Jeff King (5):
      http: drop "local" member from request struct
      archive: don't let remote clients get unreachable commits
      stripspace: fix outdated comment
      fetch: create status table using strbuf
      blame: don't overflow time buffer

Jens Lehmann (1):
      diff/status: print submodule path when looking for changes fails

Junio C Hamano (9):
      get_tree_entry(): do not call find_tree_entry() on an empty tree
      unpack_object_header_buffer(): clear the size field upon error
      receive-pack, fetch-pack: reject bogus pack that records objects twice
      pack-object: tolerate broken packs that have duplicated objects
      Git 1.7.6.5
      Git 1.7.7.5
      Update draft release notes for 1.7.8.1
      lf_to_crlf_filter(): tell the caller we added "\n" when draining
      Git 1.7.8.1

Martin von Zweigbergk (1):
      am: don't persist keepcr flag

Michael Haggerty (1):
      git symbolic-ref: documentation fix

Michael Schubert (2):
      builtin/commit: add missing '/' in help message
      builtin/log: remove redundant initialization

Mika Fischer (3):
      http.c: Use curl_multi_fdset to select on curl fds instead of just sleeping
      http.c: Use timeout suggested by curl instead of fixed 50ms timeout
      http.c: Rely on select instead of tracking whether data was received

Nguyễn Thái Ngọc Duy (5):
      tree-walk.c: do not leak internal structure in tree_entry_len()
      read_directory_recursive: reduce one indentation level
      tree_entry_interesting(): give meaningful names to return values
      tree_entry_interesting: make use of local pointer "item"
      checkout,merge: loosen overwriting untracked file check based on info/exclude

Sebastian Morr (1):
      Add MYMETA.yml to perl/.gitignore

Thomas Rast (1):
      userdiff: allow * between cpp funcname words

Ævar Arnfjörð Bjarmason (3):
      apply: get rid of useless x < 0 comparison on a size_t type
      cast variable in call to free() in builtin/diff.c and submodule.c
      builtin/init-db.c: eliminate -Wformat warning on Solaris

