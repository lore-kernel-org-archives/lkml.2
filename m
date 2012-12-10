Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976Ab2LJWRf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 17:17:35 -0500
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:44358 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952Ab2LJWRd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 17:17:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:date:message-id:mime-version:content-type
	:content-transfer-encoding; q=dns; s=sasl; b=BfMM4MNaL1g0DDIFC/j
	9MWfR5sMxZ2I50Ncsyq0KpedbYf2nXr+6WP73P1HmfYZbqfAZgtORHy5NVAJ+qte
	kaYcg+zMM14x/PX17MxS2TohalK8MKYNapbrgvNTdf8TrkYGI0SdKdSB0Zq94XB7
	XrrtuxgYP+9xwh1EByvNovT8=
From: Junio C Hamano <gitster@pobox.com>
To: git@vger.kernel.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [ANNOUNCE] Git v1.8.0.2
Date: Mon, 10 Dec 2012 14:17:30 -0800
Message-ID: <7vzk1l8scl.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Pobox-Relay-ID: 644C3AB8-4317-11E2-9691-995F2E706CDE-77302942!b-pb-sasl-quonix.pobox.com
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest maintenance release Git v1.8.0.2 is now available at
the usual places.

The release tarballs are found at:

    http://code.google.com/p/git-core/downloads/list

and their SHA-1 checksums are:

1e1640794596da40f35194c29a8cc4e41c6b4f6d  git-1.8.0.2.tar.gz
6b9e14c5b19b2e27605014252febd61a700012a3  git-htmldocs-1.8.0.2.tar.gz
ce0673256ce90451269a82a2464eab060adbfec6  git-manpages-1.8.0.2.tar.gz

Also the following public repositories all have a copy of the v1.8.0.2
tag and the maint branch that the tag points at:

  url = git://repo.or.cz/alt-git.git
  url = https://code.google.com/p/git-core/
  url = git://git.sourceforge.jp/gitroot/git-core/git.git
  url = git://git-core.git.sourceforge.net/gitroot/git-core/git-core
  url = https://github.com/gitster/git

Git v1.8.0.2 Release Notes
==========================

Fixes since v1.8.0.1
--------------------

 * Various codepaths have workaround for a common misconfiguration to
   spell "UTF-8" as "utf8", but it was not used uniformly.  Most
   notably, mailinfo (which is used by "git am") lacked this support.

 * We failed to mention a file without any content change but whose
   permission bit was modified, or (worse yet) a new file without any
   content in the "git diff --stat" output.

 * When "--stat-count" hides a diffstat for binary contents, the total
   number of added and removed lines at the bottom was computed
   incorrectly.

 * When "--stat-count" hides a diffstat for unmerged paths, the total
   number of affected files at the bottom of the "diff --stat" output
   was computed incorrectly.

 * "diff --shortstat" miscounted the total number of affected files
   when there were unmerged paths.

 * "git p4" used to try expanding malformed "$keyword$" that spans
   across multiple lines.

 * "git update-ref -d --deref SYM" to delete a ref through a symbolic
   ref that points to it did not remove it correctly.

 * Syntax highlighting in "gitweb" was not quite working.

Also contains other minor fixes and documentation updates.

----------------------------------------------------------------

Changes since v1.8.0.1 are as follows:

Antoine Pelisse (1):
      Fix typo in remote set-head usage

Eric S. Raymond (1):
      doc/fast-import: clarify how content states are built

Johan Herland (2):
      t1400-update-ref: Add test verifying bug with symrefs in delete_ref()
      Fix failure to delete a packed ref through a symref

Junio C Hamano (13):
      reencode_string(): introduce and use same_encoding()
      test: add failing tests for "diff --stat" to t4049
      diff --stat: status of unmodified pair in diff-q is not zero
      diff --stat: use "file" temporary variable to refer to data->files[i]
      diff --stat: move the "total count" logic to the last loop
      diff --stat: do not count "unmerged" entries
      diff --shortstat: do not count "unmerged" entries
      Documentation/git-push.txt: clarify the "push from satellite" workflow
      Start preparing for 1.8.0.2
      t4049: refocus tests
      Update draft release notes to 1.8.0.2
      git(1): remove a defunct link to "list of authors"
      Git 1.8.0.2

Linus Torvalds (1):
      Fix "git diff --stat" for interesting - but empty - file changes

Mark Szepieniec (1):
      Documentation: improve phrasing in git-push.txt

Matthieu Moy (2):
      git-remote-mediawiki: escape ", \, and LF in file names
      git-fast-import.txt: improve documentation for quoted paths

Nguyễn Thái Ngọc Duy (1):
      compat/fnmatch: fix off-by-one character class's length check

Paul Gortmaker (1):
      Makefile: hide stderr of curl-config test

Pete Wyckoff (1):
      git p4: RCS expansion should not span newlines

Ralf Thielow (1):
      completion: add options --single-branch and --branch to "git clone"

Richard Hubbell (1):
      gitweb.perl: fix %highlight_ext mappings

Sébastien Loriot (1):
      Documentation/git-stash.txt: add a missing verb

W. Trevor King (1):
      git-submodule: wrap branch option with "<>" in usage strings.

