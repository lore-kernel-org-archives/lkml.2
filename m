Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401Ab1HXXv3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 19:51:29 -0400
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:49549 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803Ab1HXXv1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 19:51:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:subject
	:cc:date:message-id:mime-version:content-type
	:content-transfer-encoding; q=dns; s=sasl; b=mJHCW3dRpLB2Ls1yuRN
	aiH6hHZGig62pcJ9sugl4X06h2SMmGLUGGdHWnadVfH3YmTr5vSW2gdKYF76pc16
	+GK4CaXt84MiPJyCJ1Re8BPoNomH/4sUNJxwnte17yhuhomuZX81IIrfKgmT63x2
	eDQQ9WhG/R37ZDP4wr4rnyqc=
From: Junio C Hamano <gitster@pobox.com>
To: git@vger.kernel.org
Subject: [ANNOUNCE] Git 1.7.6.1
cc: Linux Kernel <linux-kernel@vger.kernel.org>
Date: Wed, 24 Aug 2011 16:51:23 -0700
Message-ID: <7vpqjumkqs.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Pobox-Relay-ID: F9F8A3EE-CEAB-11E0-8620-1DC62E706CDE-77302942!b-pb-sasl-quonix.pobox.com
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest maintenance release Git 1.7.6.1 is available at the
usual places:

  http://www.kernel.org/pub/software/scm/git/

  git-1.7.6.1.tar.{gz,bz2}			(source tarball)
  git-htmldocs-1.7.6.1.tar.{gz,bz2}		(preformatted docs)
  git-manpages-1.7.6.1.tar.{gz,bz2}		(preformatted docs)

The RPM binary packages for a few architectures are found in:

  RPMS/$arch/git-*-1.7.6.1-1.fc13.$arch.rpm	(RPM)


Git v1.7.6.1 Release Notes
==========================

Fixes since v1.7.6
------------------

 * Various codepaths that invoked zlib deflate/inflate assumed that these
   functions can compress or uncompress more than 4GB data in one call on
   platforms with 64-bit long, which has been corrected.

 * "git unexecutable" reported that "unexecutable" was not found, even
   though the actual error was that "unexecutable" was found but did
   not have a proper she-bang line to be executed.

 * Error exits from $PAGER were silently ignored.

 * "git checkout -b <branch>" was confused when attempting to create a
   branch whose name ends with "-g" followed by hexadecimal digits,
   and refused to work.

 * "git checkout -b <branch>" sometimes wrote a bogus reflog entry,
   causing later "git checkout -" to fail.

 * "git diff --cc" learned to correctly ignore binary files.

 * "git diff -c/--cc" mishandled a deletion that resolves a conflict, and
   looked in the working tree instead.

 * "git fast-export" forgot to quote pathnames with unsafe characters
   in its output.

 * "git fetch" over smart-http transport used to abort when the
   repository was updated between the initial connection and the
   subsequent object transfer.

 * "git fetch" did not recurse into submodules in subdirectories.

 * "git ls-tree" did not error out when asked to show a corrupt tree.

 * "git pull" without any argument left an extra whitespace after the
   command name in its reflog.

 * "git push --quiet" was not really quiet.

 * "git rebase -i -p" incorrectly dropped commits from side branches.

 * "git reset [<commit>] paths..." did not reset the index entry correctly
   for unmerged paths.

 * "git submodule add" did not allow a relative repository path when
   the superproject did not have any default remote url.

 * "git submodule foreach" failed to correctly give the standard input to
   the user-supplied command it invoked.

 * submodules that the user has never showed interest in by running
   "git submodule init" was incorrectly marked as interesting by "git
   submodule sync".

 * "git submodule update --quiet" was not really quiet.

  * "git tag -l <glob>..." did not take multiple glob patterns from the
   command line.

----------------------------------------------------------------

Changes since v1.7.6 are as follows:

Alex Neronskiy (2):
      Fix documentation of fetch-pack that implies that the client can disconnect after sending wants.
      Document the underlying protocol used by shallow repositories and --depth commands.

Andrew Wong (1):
      rebase -i -p: include non-first-parent commits in todo list

Bert Wesarg (1):
      Documentation: clearly specify what refs are honored by core.logAllRefUpdates

Brandon Casey (2):
      t/t7407: demonstrate that the command called by 'submodule foreach' loses stdin
      git-submodule.sh: preserve stdin for the command spawned by foreach

Brian Harring (1):
      get_indexed_object can return NULL if nothing is in that slot; check for it

Carlos Martín Nieto (1):
      Documentation: clarify the invalidated tree entry format

Clemens Buchacher (3):
      error_routine: use parent's stderr if exec fails
      propagate --quiet to send-pack/receive-pack
      notice error exit from pager

Dmitry Ivankov (1):
      doc/fast-import: clarify notemodify command

Emilio G. Cota (2):
      Documentation: ignore *.pdf files
      Documentation/Makefile: add *.pdf to `clean' target

Erik Faye-Lund (1):
      connect: correctly number ipv6 network adapter

Fredrik Kuivinen (1):
      Makefile: Track changes to LDFLAGS and relink when necessary

Heiko Voigt (2):
      add gitignore entry to description about how to write a builtin
      add technical documentation about ref iteration

Jack Nagel (1):
      Documentation: minor grammatical fix in rev-list-options.txt

Jakub Narebski (2):
      gitweb: Serve text/* 'blob_plain' as text/plain with $prevent_xss
      gitweb: Serve */*+xml 'blob_plain' as text/plain with $prevent_xss

Jeff King (10):
      combine-diff: split header printing into its own function
      combine-diff: calculate mode_differs earlier
      combine-diff: handle binary files as binary
      refactor get_textconv to not require diff_filespec
      combine-diff: respect textconv attributes
      tag: accept multiple patterns for --list
      docs: document --textconv diff option
      t7400: fix bogus test failure with symlinked trash
      fast-export: quote paths in output
      am: refresh the index at start and --resolved

Jens Lehmann (7):
      submodule add: test failure when url is not configured in superproject
      submodule add: allow relative repository path even when no url is set
      submodule add: clean up duplicated code
      fetch: Also fetch submodules in subdirectories in on-demand mode
      submodule add: always initialize .git/config entry
      tests: print failed test numbers at the end of the test run
      submodule: update and add must honor --quiet flag

Johannes Schindelin (1):
      get_pwd_cwd(): Do not trust st_dev/st_ino blindly

Jon Seymour (2):
      Add a test to check that git ls-tree sets non-zero exit code on error.
      Ensure git ls-tree exits with a non-zero exit code if read_tree_recursive fails.

Julian Phillips (1):
      remote-curl: Add a format check to parsing of info/refs

Junio C Hamano (29):
      diff-index --quiet: learn the "stop feeding the backend early" logic
      checkout -b <name>: correctly detect existing branch
      sha1_file.c: "legacy" is really the current format
      zlib wrapper: refactor error message formatter
      zlib: wrap remaining calls to direct inflate/inflateEnd
      zlib: wrap inflateInit2 used to accept only for gzip format
      zlib: wrap deflate side of the API
      zlib: wrap deflateBound() too
      zlib: zlib can only process 4GB at a time
      zlib: allow feeding more than 4GB in one go
      t/gitweb-lib.sh: skip gitweb tests when perl dependencies are not met
      cygwin: trust executable bit by default
      git-remote.txt: avoid sounding as if loose refs are the only ones in the world
      check-ref-format doc: de-emphasize the implementation detail of a ref
      git.txt: de-emphasize the implementation detail of a ref
      glossary: update description of "tag"
      glossary: update description of head and ref
      glossary: clarify description of HEAD
      submodule sync: do not auto-vivify uninteresting submodule
      "branch -d" can remove more than one branches
      test: skip clean-up when running under --immediate mode
      checkout: do not write bogus reflog entry out
      reset [<commit>] paths...: do not mishandle unmerged paths
      diff -c/--cc: do not mistake "resolved as deletion" as "use working tree"
      receive-pack: do not overstep command line argument array
      helping smart-http/stateless-rpc fetch race
      Prepare for 1.7.6.1
      Update draft release notes for 1.7.6.1
      Git 1.7.6.1

Martin von Zweigbergk (2):
      Documentation: use [verse] for SYNOPSIS sections
      rebase: clarify "restore the original branch"

Michael Haggerty (6):
      git-svn: Demonstrate a bug with root commits in mergeinfo ranges
      git-svn: Disambiguate rev-list arguments to improve error message
      git-svn: Correctly handle root commits in mergeinfo ranges
      gitattributes: Clarify discussion of attribute macros
      gitattributes: Reword "attribute macro" to "macro attribute"
      Do not use C++-style comments

Michael Schubert (1):
      help_unknown_cmd: do not propose an "unknown" cmd

Michael Witten (1):
      filter-branch: Export variable `workdir' for --commit-filter

Namhyung Kim (1):
      git-remote.txt: fix wrong remote refspec

Nguyễn Thái Ngọc Duy (3):
      Break down no-lstat() condition checks in verify_uptodate()
      checkout-index: remove obsolete comment
      fetch-pack: check for valid commit from server

Ori Avtalion (1):
      pull: remove extra space from reflog message

Pavan Kumar Sunkara (1):
      git-config: Remove extra whitespaces

Peter Collingbourne (1):
      Documentation: git-filter-branch honors replacement refs

