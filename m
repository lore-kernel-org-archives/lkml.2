Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759458Ab2IKTyJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 15:54:09 -0400
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:63753 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758675Ab2IKTyF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 15:54:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:date:message-id:mime-version:content-type
	:content-transfer-encoding; q=dns; s=sasl; b=Aa3/NDOVOGTOuZZv4eL
	kZqjggvNOinwwezVPyruH53dvgQ9GHx0j74xaZBiLNuY/9XjFhSrwfWNpk0whxTq
	BGg0h5RpjFfVSl0efEBeBlY7jMKuqigrttQ0Apeu4ZLwjADZrYIpfYpgNjRuwzNU
	WUSs62jfDL1nVtVAOgNOAEOw=
From: Junio C Hamano <gitster@pobox.com>
To: git@vger.kernel.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [ANNOUNCE] Git v1.7.11.6
Date: Tue, 11 Sep 2012 12:54:02 -0700
Message-ID: <7v8vcggwth.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Pobox-Relay-ID: 7030B2C8-FC4A-11E1-A341-BAB72E706CDE-77302942!b-pb-sasl-quonix.pobox.com
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A maintenance release Git v1.7.11.6 is now available at the
usual places.

The release tarballs are found at:

    http://code.google.com/p/git-core/downloads/list

and their SHA-1 checksums are:

f678531535643806733e8c7e87db77386c48738b  git-1.7.11.6.tar.gz
e6ccf6cffa3b69dc5d658f43bb8a10ed70b176f2  git-htmldocs-1.7.11.6.tar.gz
7bbb12429e65184d9462dfc01b104a4780bc67a8  git-manpages-1.7.11.6.tar.gz

Also the following public repositories all have a copy of the v1.7.11.6
tag and the maint-1.7.11 branch that the tag points at:

  ;; url = git://repo.or.cz/alt-git.git
  url = https://code.google.com/p/git-core/
  url = git://git.sourceforge.jp/gitroot/git-core/git.git
  url = git://git-core.git.sourceforge.net/gitroot/git-core/git-core
  url = https://github.com/gitster/git

[repo seems to be having a problem right now]

Git v1.7.11.6 Release Notes
===========================

Fixes since v1.7.11.5
---------------------

 * "ciabot" script (in contrib/) has been updated with extensive
   documentation.

 * "git foo" errored out with "Not a directory" when the user had a
   non-directory on $PATH, and worse yet it masked an alias "foo" from
   running.

 * When the user exports a non-default IFS without HT, scripts that
   rely on being able to parse "ls-files -s | while read a b c..."
   started to fail.  Protect them from such a misconfiguration.

 * When the user gives an argument that can be taken as both a
   revision name and a pathname without disambiguating with "--", we
   used to give a help message "Use '--' to separate".  The message
   has been clarified to show where that '--' goes on the command
   line.

 * Documentation for the configuration file format had a confusing
   example.

 * Older parts of the documentation described as if having a regular
   file in .git/refs/ hierarchy were the only way to have branches and
   tags, which is not true for quite some time.

 * It was generally understood that "--long-option"s to many of our
   subcommands can be abbreviated to the unique prefix, but it was not
   easy to find it described for new readers of the documentation set.

 * The "--topo-order", "--date-order" (and the lack of either means
   the default order) options to "rev-list" and "log" family of
   commands were poorly described in the documentation.

 * "git commit --amend" let the user edit the log message and then
   died when the human-readable committer name was given
   insufficiently by getpwent(3).

 * The exit status code from "git config" was way overspecified while
   being incorrect.  The implementation has been updated to give the
   documented status for a case that was documented, and introduce a
   new code for "all other errors".

 * The output from "git diff -B" for a file that ends with an
   incomplete line did not put "\ No newline..." on a line of its own.

 * "git diff" had a confusion between taking data from a path in the
   working tree and taking data from an object that happens to have
   name 0{40} recorded in a tree.

 * The "--rebase" option to "git pull" can be abbreviated to "-r",
   but we didn't document it.

 * When "git push" triggered the automatic gc on the receiving end, a
   message from "git prune" that said it was removing cruft leaked to
   the standard output, breaking the communication protocol.

 * The reflog entries left by "git rebase" and "git rebase -i" were
   inconsistent (the interactive one gave an abbreviated object name).

 * "git send-email" did not unquote encoded words that appear on the
   header correctly, and lost "_" from strings.

 * "git stash apply/pop" did not trigger "rerere" upon conflicts
   unlike other mergy operations.

 * "git submodule <cmd> path" did not error out when the path to the
   submodule was misspelt.

 * "git submodule update -f" did not update paths in the working tree
   that has local changes.
   (merge 01d4721 sz/submodule-force-update later to maint).

 * "gitweb" when used with PATH_INFO failed to notice directories with
   SP (and other characters that need URL-style quoting) in them.

 * Fallback 'getpass' implementation made unportable use of stdio API.

 * A utility shell function test_seq has been added as a replacement
   for the 'seq' utility found on some platforms.

----------------------------------------------------------------

Changes since v1.7.11.5 are as follows:

Adam Butcher (1):
      Fix '\ No newline...' annotation in rewrite diffs

Ben Walton (1):
      Enable HAVE_DEV_TTY for Solaris

Brandon Casey (1):
      t/t5400: demonstrate breakage caused by informational message from prune

Eric S. Raymond (3):
      contrib/ciabot: Get ciabot configuration from git variables
      Improved documentation for the ciabot scripts.
      Make the ciabot scripts completely self-configuring in the normal case.

Heiko Voigt (2):
      Let submodule command exit with error status if path does not exist
      Documentation/CodingGuidelines: spell out more shell guidelines

Jay Soffian (1):
      gitweb: URL-decode $my_url/$my_uri when stripping PATH_INFO

Jeff King (6):
      commit: check committer identity more strictly
      diff: do not use null sha1 as a sentinel value
      do not write null sha1s to on-disk index
      fsck: detect null sha1 in tree entries
      terminal: seek when switching between reading and writing
      docs: monospace listings in docbook output

Junio C Hamano (13):
      config: "git config baa" should exit with status 1
      t7406: fix misleading "rev-parse --max-count=1 HEAD"
      sane_execvp(): ignore non-directory on $PATH
      Documentation: do not mention .git/refs/* directories
      receive-pack: do not leak output from auto-gc to standard output
      sh-setup: protect from exported IFS
      rev-list docs: clarify --topo-order description
      gitcli: describe abbreviation of long options
      git-config doc: unconfuse an example
      mergetool: style fixes
      Prepare for 1.7.11.6
      Almost 1.7.11.6
      Git 1.7.11.6

Luka Perkov (1):
      builtin.h: remove unused cmd_<foo> declarations

Martin von Zweigbergk (1):
      add tests for 'git rebase --keep-empty'

Matthieu Moy (1):
      setup: clarify error messages for file/revisions ambiguity

Michael Haggerty (1):
      git-config.txt: fix example

Michael J Gruber (1):
      rebase -i: use full onto sha1 in reflog

Michał Kiedrowicz (1):
      tests: Introduce test_seq

Miklos Vajna (1):
      man: git pull -r is a short for --rebase

Nguyễn Thái Ngọc Duy (1):
      read_index_from: remove bogus errno assignments

Paul Gortmaker (1):
      apply: delete unused deflate_origlen from patch struct

Phil Hord (2):
      test: git-stash conflict sets up rerere
      stash: invoke rerere in case of conflict

Stefan Zager (1):
      Make 'git submodule update --force' always check out submodules.

Thomas Rast (3):
      send-email: improve RFC2047 quote parsing
      diff_setup_done(): return void
      merge-recursive: eliminate flush_buffer() in favor of write_in_full()

