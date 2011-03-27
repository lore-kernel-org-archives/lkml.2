Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257Ab1C0Hsg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 03:48:36 -0400
Received: from a-pb-sasl-sd.pobox.com ([64.74.157.62]:62619 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962Ab1C0Hsf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 03:48:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:subject
	:date:message-id:mime-version:content-type
	:content-transfer-encoding; q=dns; s=sasl; b=KMRuyGimaHQ1xm8cSwo
	2hRlkFB/ChxZkOqDOmE9+OLXx3ablm58KCrFoeCY6LT/6u2bfLwe8CxRNIJSSf3w
	dp9AklKC5Qt6o3zZgmozKGVnUrHqAKVDXMtTL2SSZj/SIcl4Y4tQ6ioN+BiyIto0
	UegFhsROTDFAglF6qzvlD5bE=
From: Junio C Hamano <gitster@pobox.com>
To: git@vger.kernel.org
Subject: [ANNOUNCE] Git 1.7.4.2
Date: Sun, 27 Mar 2011 00:48:24 -0700
Message-ID: <7vd3ld2ed3.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Pobox-Relay-ID: D99AE3AE-5846-11E0-B92E-E8AB60295C12-77302942!a-pb-sasl-sd.pobox.com
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest maintenance release Git 1.7.4.2 is available at the
usual places:

  http://www.kernel.org/pub/software/scm/git/

  git-1.7.4.2.tar.{gz,bz2}			(source tarball)
  git-htmldocs-1.7.4.2.tar.{gz,bz2}		(preformatted docs)
  git-manpages-1.7.4.2.tar.{gz,bz2}		(preformatted docs)

The RPM binary packages for a few architectures are found in:

  RPMS/$arch/git-*-1.7.4.2-1.fc13.$arch.rpm	(RPM)


Git v1.7.4.2 Release Notes
==========================

Fixes since v1.7.4.1
--------------------

 * Many documentation updates to match "git cmd -h" output and the
   git-cmd manual page.

 * We used to keep one file descriptor open for each and every packfile
   that we have a mmap window on it (read: "in use"), even when for very
   tiny packfiles.  We now close the file descriptor early when the entire
   packfile fits inside one mmap window.

 * "git bisect visualize" tried to run "gitk" in windowing
   environments even when "gitk" is not installed, resulting in a
   strange error message.

 * "git clone /no/such/path" did not fail correctly.

 * "git commit" did not correctly error out when the user asked to use a
   non existent file as the commit message template.

 * "git diff --stat -B" ran on binary files counted the changes in lines,
   which was nonsensical.

 * "git diff -M" opportunistically detected copies, which was not
   necessarily a good thing, especially when it is internally run by
   recursive merge.

 * "git difftool" didn't tell (g)vimdiff that the files it is reading are
   to be opened read-only.

 * "git merge" didn't pay attention to prepare-commit-msg hook, even
   though if a merge is conflicted and manually resolved, the subsequent
   "git commit" would have triggered the hook, which was inconsistent.

 * "git patch-id" (and commands like "format-patch --ignore-in-upstream"
   that use it as their internal logic) handled changes to files that end
   with incomplete lines incorrectly.

 * The official value to tell "git push" to push the current branch back
   to update the upstream branch it forked from is now called "upstream".
   The old name "tracking" is and will be supported.

 * "git submodule update" used to honor the --merge/--rebase option (or
   corresponding configuration variables) even for a newly cloned
   subproject, which made no sense (so/submodule-no-update-first-time).

 * gitweb's "highlight" interface mishandled tabs.

 * gitweb didn't understand timezones with GMT offset that is not
   multiple of a whole hour.

 * gitweb had a few forward-incompatible syntactic constructs and
   also used incorrect variable when showing the file mode in a diff.

And other minor fixes and documentation updates.


----------------------------------------------------------------

Changes since v1.7.4.1 are as follows:

Adam Monsen (1):
      diff format documentation: clarify --cc and -c

Alexei Sholik (3):
      Documentation: remove redundant colons in git-for-each-ref.txt
      Add Author and Documentation sections to git-for-each-ref.txt
      docs: fix grammar in gitattributes.txt

Arnout Engelen (1):
      Improve error messages when temporary file creation fails

Ben Walton (1):
      Work around broken ln on solaris as used in t8006

Carlos Martín Nieto (3):
      valgrind: ignore SSE-based strlen invalid reads
      make_absolute_path: return the input path if it points to our buffer
      t/README: Add a note about running commands under valgrind

Clemens Buchacher (1):
      Documentation: clarify -u<mode> option defaults

Eric Hanchrow (1):
      branch_merged: fix grammar in warning

Erik Faye-Lund (1):
      mingw: add minimum getrlimit() compatibility stub

Jakub Narebski (2):
      gitweb: Always call parse_date with timezone parameter
      gitweb: Fix handling of fractional timezones in parse_date

Jay Soffian (1):
      merge: honor prepare-commit-msg hook

Jeff King (5):
      string_list_append: always set util pointer to NULL
      clone: die when trying to clone missing local path
      diff: handle diffstat of rewritten binary files
      diff: don't retrieve binary blobs for diffstat
      bisect: visualize with git-log if gitk is unavailable

Johan Herland (1):
      push.default: Rename 'tracking' to 'upstream'

Jonathan Nieder (9):
      correct type of EMPTY_TREE_SHA1_BIN
      tests: skip terminal output tests on OS X
      commit: error out for missing commit message template
      enums: omit trailing comma for portability
      compat: make gcc bswap an inline function
      standardize brace placement in struct definitions
      branch: split off function that writes tracking info and commit subject
      cherry: split off function to print output lines
      diff --submodule: split into bite-sized pieces

Junio C Hamano (8):
      CodingGuidelines: downcase placeholders in usage messages
      verify-pack: add --stat-only to the synopsis section
      SubmittingPatches: clarify the expected commit log description
      Revert "core.abbrevguard: Ensure short object names stay unique a bit longer"
      Prepare draft release notes to 1.7.4.2
      bisect: explain the rationale behind 125
      Update draft release notes to 1.7.4.2
      Git 1.7.4.2

Kevin Cernekee (1):
      gitweb: highlight: replace tabs with spaces

Linus Torvalds (3):
      for_each_hash: allow passing a 'void *data' pointer to callback
      diffcore-rename: properly honor the difference between -M and -C
      diffcore-rename: improve estimate_similarity() heuristics

Masatake Osanai (1):
      perl: command_bidi_pipe() method should set-up git environmens

Mathias Lafeldt (1):
      Fix typo in t/README

Michael J Gruber (16):
      commit,tag: use same wording for -F
      commit,status: describe --porcelain just like push
      clone,init: describe --template using the same wording
      commit,merge,tag: describe -m likewise
      add: describe --patch like checkout, reset
      commit,status: describe -u likewise
      git-tag.txt: list all modes in the description
      pull: do not display fetch usage on --help-all
      Make <identifier> lowercase as per CodingGuidelines
      Make <identifier> lowercase as per CodingGuidelines
      Make <identifier> lowercase as per CodingGuidelines
      Make <identifier> lowercase in Documentation
      git-patch-id: test for "no newline" markers
      git-patch-id: do not trip over "no newline" markers
      mergetool-lib: call vim in readonly mode for diffs
      rev-list-options.txt: typo fix

Michal Rokos (2):
      Makefile: add NO_FNMATCH_CASEFOLD to HP-UX section
      git-compat-util.h: Honor HP C's noreturn attribute

Michał Kiedrowicz (1):
      Documentation: fix a typo in git-apply.txt

Nguyễn Thái Ngọc Duy (2):
      parse_tag_buffer(): do not prefixcmp() out of range
      init: remove unnecessary check

Piotr Krukowiecki (1):
      ls-remote documentation: <refs> argument is optional

Ralf Wildenhues (1):
      configure: use AC_LANG_PROGRAM consistently

SZEDER Gábor (1):
      git-am.txt: advertise 'git am --abort' instead of 'rm .git/rebase-apply'

Shawn O. Pearce (2):
      Limit file descriptors used by packs
      sha1_file.c: Don't retain open fds on small packs

Spencer E. Olson (2):
      submodule: no [--merge|--rebase] when newly cloned
      t7406: "git submodule update {--merge|--rebase]" with new submodules

Ævar Arnfjörð Bjarmason (4):
      gitweb/gitweb.perl: remove use of qw(...) as parentheses
      gitweb/gitweb.perl: don't call S_ISREG() with undef
      t/gitweb-lib.sh: Ensure that errors are shown for --debug --immediate
      t/t7500-commit.sh: use test_cmp instead of test

