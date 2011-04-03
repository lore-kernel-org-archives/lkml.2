Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941Ab1DCIgn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 04:36:43 -0400
Received: from a-pb-sasl-sd.pobox.com ([64.74.157.62]:60945 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab1DCIgj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 04:36:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:subject
	:date:message-id:mime-version:content-type
	:content-transfer-encoding; q=dns; s=sasl; b=V1yAuxkll+2EYhFJv33
	0dHXf06++/ZWTPyTRqgY0aloQOyTD7JKiOH6DLDj77zaJOpwZzndmh/sSOX+sdav
	e6XpJqxMgFxpK3jINqyyjzycWpYPNkN7xevG/qFpYJn3B180gm5ka6OQfyYLldyC
	GJFobrD+S65Ebkhgoxpp6ef4=
From: Junio C Hamano <gitster@pobox.com>
To: git@vger.kernel.org
Subject: [ANNOUNCE] Git 1.7.4.3
Date: Sun, 03 Apr 2011 01:36:24 -0700
Message-ID: <7v4o6fg29j.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Pobox-Relay-ID: BDF4F932-5DCD-11E0-8A5B-E8AB60295C12-77302942!a-pb-sasl-sd.pobox.com
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest maintenance release Git 1.7.4.3 is available at the
usual places:

  http://www.kernel.org/pub/software/scm/git/

  git-1.7.4.3.tar.{gz,bz2}			(source tarball)
  git-htmldocs-1.7.4.3.tar.{gz,bz2}		(preformatted docs)
  git-manpages-1.7.4.3.tar.{gz,bz2}		(preformatted docs)

The RPM binary packages for a few architectures are found in:

  RPMS/$arch/git-*-1.7.4.3-1.fc13.$arch.rpm	(RPM)

Git v1.7.4.3 Release Notes
==========================

Fixes since v1.7.4.2
--------------------

 * "git apply" used to confuse lines updated by previous hunks as lines
   that existed before when applying a hunk, contributing misapplication
   of patches with offsets.

 * "git branch --track" (and "git checkout --track --branch") used to
   allow setting up a random non-branch that does not make sense to follow
   as the "upstream".  The command correctly diagnoses it as an error.

 * "git checkout $other_branch" silently removed untracked symbolic links
   in the working tree that are in the way in order to check out paths
   under it from the named branch.

 * "git cvsimport" did not bail out immediately when the cvs server cannot
   be reached, spewing unnecessary error messages that complain about the
   server response that it never got.

 * "git diff --quiet" did not work very well with the "--diff-filter"
   option.

 * "git grep -n" lacked a long-hand synonym --line-number.

 * "git stash apply" reported the result of its operation by running
   "git status" from the top-level of the working tree; it should (and
   now does) run it from the user's working directory.

And other minor fixes and documentation updates.

----------------------------------------------------------------

Changes since v1.7.4.2 are as follows:

Alex Riesen (1):
      HOME must be set before calling git-init when creating test repositories

Carlos Martín Nieto (1):
      Documentation/config.txt: make truth value of numbers more explicit

Clemens Buchacher (1):
      do not overwrite untracked symlinks

Fabian Keil (1):
      git-cvsimport.perl: Bail out right away when reading from the server fails

Jeff King (1):
      docs: fix filter-branch subdir example for exotic repo names

Joe Ratterman (1):
      grep: Add the option '--line-number'

Johan Herland (1):
      branch/checkout --track: Ensure that upstream branch is indeed a branch

Johannes Sixt (3):
      Demonstrate breakage: checkout overwrites untracked symlink with directory
      stash: fix incorrect quoting in cleanup of temporary files
      stash: copy the index using --index-output instead of cp -p

Junio C Hamano (9):
      checkout: fix bug with ambiguous refs
      apply: do not patch lines that were already patched
      apply -v: show offset count when patch did not apply exactly
      diff --quiet: disable optimization when --diff-filter=X is used
      doc: technical details about the index file format
      t8001: check the exit status of the command being tested
      parse-remote: typofix
      Doc: mention --delta-base-offset is the default for Porcelain commands
      Git 1.7.4.3

Maxin john (1):
      contrib/thunderbird-patch-inline: do not require bash to run the script

Michael J Gruber (2):
      git-bisect.txt: streamline run presentation
      git-bisect.txt: example for bisecting with hot-fix

Michael Witten (3):
      git tag documentation grammar fixes and readability updates
      Typos: t/README
      strbuf.h: remove a tad stale docs-in-comment and reference api-doc instead

Nguyễn Thái Ngọc Duy (1):
      doc: technical details about the index file format

Piotr Krukowiecki (2):
      git stash: show status relative to current directory
      Add test: git stash shows status relative to current dir

Stephen Boyd (2):
      parse-remote: replace unnecessary sed invocation
      git-pack-objects.txt: fix grammatical errors

