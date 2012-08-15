Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245Ab2HOXTR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 19:19:17 -0400
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:55661 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850Ab2HOXTQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 19:19:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:date:message-id:mime-version:content-type
	:content-transfer-encoding; q=dns; s=sasl; b=yWrni/KjVRJEt0qfFBB
	HDgW8ywbpAp1k+2DW2cc4Ffwlx8LxAXNVMVz2SppofDshMYO+3bmGPJ9q2ZdrMjZ
	ZMzDIu6sKzVWxIZ4s/HCj7gXCNVjkioap/s96BlG6nneSTWIXfZ80AKkbBJTyJoZ
	42LQVIPyDponN1G8WjYcqxqY=
From: Junio C Hamano <gitster@pobox.com>
To: git@vger.kernel.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [ANNOUNCE] Git v1.7.11.5
Date: Wed, 15 Aug 2012 16:19:13 -0700
Message-ID: <7v628j4uby.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Pobox-Relay-ID: A103A976-E72F-11E1-A7CF-01B42E706CDE-77302942!b-pb-sasl-quonix.pobox.com
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest maintenance release Git v1.7.11.5 is now available at
the usual places.

The release tarballs are found at:

    http://code.google.com/p/git-core/downloads/list

and their SHA-1 checksums are:

44013d9418ef23dd8bb67e80b27c9327356bfae8  git-1.7.11.5.tar.gz
8e19f56b2f484dc3327f1e8316c114dbe0ee2743  git-htmldocs-1.7.11.5.tar.gz
d328241c130bbe38b12adf5702568c1edfff8623  git-manpages-1.7.11.5.tar.gz

Also the following public repositories all have a copy of the v1.7.11.5
tag and the maint branch that the tag points at:

  url = git://repo.or.cz/alt-git.git
  url = https://code.google.com/p/git-core/
  url = git://git.sourceforge.jp/gitroot/git-core/git.git
  url = git://git-core.git.sourceforge.net/gitroot/git-core/git-core
  url = https://github.com/gitster/git

Git v1.7.11.5 Release Notes
===========================

Fixes since v1.7.11.4
---------------------

 * The Makefile rule to create assembly output (primarily for
   debugging purposes) did not create it next to the source.

 * The code to avoid mistaken attempt to add the object directory
   itself as its own alternate could read beyond end of a string while
   comparison.

 * On some architectures, "block-sha1" did not compile correctly
   when compilers inferred alignment guarantees from our source we
   did not intend to make.

 * When talking to a remote running ssh on IPv6 enabled host, whose
   address is spelled as "[HOST]:PORT", we did not parse the address
   correctly and failed to connect.

 * git-blame.el (in compat/) have been updated to use Elisp more
   correctly.

 * "git checkout <branchname>" to come back from a detached HEAD state
   incorrectly computed reachability of the detached HEAD, resulting
   in unnecessary warnings.

 * "git mergetool" did not support --tool-help option to give the list
   of supported backends, like "git difftool" does.

 * "git grep" stopped spawning an external "grep" long time ago, but a
   duplicated test to check internal and external "grep" was left
   behind.

Also contains minor typofixes and documentation updates.

----------------------------------------------------------------

Changes since v1.7.11.4 are as follows:

Heiko Voigt (1):
      link_alt_odb_entry: fix read over array bounds reported by valgrind

Jeff King (1):
      checkout: don't confuse ref and object flags

Jonathan Nieder (4):
      block-sha1: avoid pointer conversion that violates alignment constraints
      block-sha1: put expanded macro parameters in parentheses
      Makefile: fix location of listing produced by "make subdir/foo.s"
      Makefile: BLK_SHA1 does not require fast htonl() and unaligned loads

Junio C Hamano (4):
      mergetool: support --tool-help option like difftool does
      Enumerate revision range specifiers in the documentation
      Prepare for 1.7.11.5
      Git 1.7.11.5

Lawrence Mitchell (2):
      git-blame.el: Use with-current-buffer where appropriate
      git-blame.el: Do not use bare 0 to mean (point-min)

Max Horn (1):
      Make <refname> documentation more consistent.

Michael Schubert (1):
      Documentation/git-daemon: add missing word

Ramkumar Ramachandra (1):
      commit: document a couple of options

Ramsay Allan Jones (1):
      t7810-*.sh: Remove redundant test

René Scharfe (1):
      git: Wrong parsing of ssh urls with IPv6 literals ignores port

Rüdiger Sonderfeld (2):
      git-blame.el: use mapc instead of mapcar
      git-blame.el: Do not use goto-line in lisp code

Štěpán Němec (1):
      doc: A few minor copy edits.

