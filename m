Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758598Ab1EZXfr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 19:35:47 -0400
Received: from a-pb-sasl-sd.pobox.com ([64.74.157.62]:52363 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758352Ab1EZXfq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 19:35:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:subject
	:cc:date:message-id:mime-version:content-type
	:content-transfer-encoding; q=dns; s=sasl; b=P/Buo5bsNWCqPULnkPE
	LMgG08LxPtdAtfAjSKfR7KylkOzFjdJRvq6bgsvibtlkJ/9tbYDc7t+5VcbtB5D2
	VRyVFVGbZfTqQJYTSuAidICCuThpg4cQ4xQz5Met37yBq60681/olUKBNE/eUpGo
	k9ev2rHEpqYC4wyW+4Z6ngJ8=
From: Junio C Hamano <gitster@pobox.com>
To: git@vger.kernel.org
Subject: [ANNOUNCE] Git 1.7.5.3
cc: Linux Kernel <linux-kernel@vger.kernel.org>
Date: Thu, 26 May 2011 16:35:36 -0700
Message-ID: <7vvcwxt4qf.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Pobox-Relay-ID: 2A9016BA-87F1-11E0-BF64-D6B6226F3D4C-77302942!a-pb-sasl-sd.pobox.com
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest maintenance release Git 1.7.5.3 is available at the
usual places:

  http://www.kernel.org/pub/software/scm/git/

  git-1.7.5.3.tar.{gz,bz2}			(source tarball)
  git-htmldocs-1.7.5.3.tar.{gz,bz2}		(preformatted docs)
  git-manpages-1.7.5.3.tar.{gz,bz2}		(preformatted docs)

The RPM binary packages for a few architectures are found in:

  RPMS/$arch/git-*-1.7.5.3-1.fc13.$arch.rpm	(RPM)

Git v1.7.5.3 Release Notes
==========================

Fixes since v1.7.5.2
--------------------

 * The bash completion scripts should correctly work using zsh's bash
   completion emulation layer now.

 * Setting $(prefix) in config.mak did not affect where etc/gitconfig
   file is read from, even though passing it from the command line of
   $(MAKE) did.

 * The logic to handle "&" (expand to UNIX username) in GECOS field
   miscounted the length of the name it formatted.

 * "git cherry-pick -s resolve" failed to cherry-pick a root commit.

 * "git diff --word-diff" misbehaved when diff.suppress-blank-empty was
   in effect.

 * "git log --stdin path" with an input that has additional pathspec
   used to corrupt memory.

 * "git send-pack" (hence "git push") over smalt-HTTP protocol could
   deadlock when the client side pack-object died early.

 * Compressed tarball gitweb generates used to be made with the timestamp
   of the tarball generation; this was bad because snapshot from the same
   tree should result in a same tarball.

And other minor fixes and documentation updates.

----------------------------------------------------------------

Changes since v1.7.5.2 are as follows:

Felipe Contreras (1):
      git-completion: fix regression in zsh support

Fraser Tweedale (1):
      gitweb: supply '-n' to gzip for identical output

Jeff King (8):
      send-pack: unbreak push over stateless rpc
      cherry-pick: handle root commits with external strategies
      revert: allow reverting a root commit
      t3503: test cherry picking and reverting root commits
      connect: treat generic proxy processes like ssh processes
      connect: let callers know if connection is a socket
      send-pack: avoid deadlock on git:// push with failed pack-objects
      test core.gitproxy configuration

Jim Meyering (1):
      do not read beyond end of malloc'd buffer

Johannes Sixt (3):
      Documentation/format-patch: suggest Toggle Word Wrap add-on for Thunderbird
      send-pack: avoid deadlock when pack-object dies early
      Honor $(prefix) set in config.mak* when defining ETC_GIT*

Jonathan Nieder (5):
      Revert "t0081 (line-buffer): add buffering tests"
      Documentation: explain how to check for patch corruption
      Documentation: hints for sending patches inline with Thunderbird
      Documentation: publicize KMail hints for sending patches inline
      Documentation: publicize hints for sending patches with GMail

Junio C Hamano (4):
      Revert "Honor $(prefix) set in config.mak* when defining ETC_GIT* and sysconfdir"
      setup_revisions(): take pathspec from command line and --stdin correctly
      sideband_demux(): fix decl-after-stmt
      Git 1.7.5.3

Kacper Kornet (1):
      Honor $(prefix) set in config.mak* when defining ETC_GIT* and sysconfdir

Michael J Gruber (2):
      config.txt,diff-options.txt: porcelain vs. plumbing for color.diff
      git-svn: Fix git svn log --show-commit

Nguyễn Thái Ngọc Duy (1):
      init/clone: remove short option -L and document --separate-git-dir

Rafael Gieschke (1):
      copy_gecos: fix not adding nlen to len when processing "&"

Stefan Sperling (1):
      remove noise and inaccuracies from git-svn docs

