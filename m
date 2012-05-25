Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933230Ab2EYUyo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 16:54:44 -0400
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:40949 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758812Ab2EYUyl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 16:54:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:subject
	:cc:date:message-id:mime-version:content-type
	:content-transfer-encoding; q=dns; s=sasl; b=ybnQP8Jq6ezOqjnEaRP
	Q5VFTELyo6Ui0VdlfL2GlVF3yyW1C5NLFXsxkzviUTmzDVEKERrpKxZzTY6JAXdb
	2ZBjdWscDsEri/V7OtUWtYDgkMgmg5pzpvS1FtbJ6MbvoqGn35UedZW9qStsOZFd
	j2Q0y8A0/CLhKWbzhowFjH60=
From: Junio C Hamano <gitster@pobox.com>
To: git@vger.kernel.org
Subject: [ANNOUNCE] Git 1.7.10.3
cc: Linux Kernel <linux-kernel@vger.kernel.org>
Date: Fri, 25 May 2012 13:54:39 -0700
Message-ID: <7vhav4q8vk.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Pobox-Relay-ID: D8FACE6E-A6AB-11E1-BB0E-FC762E706CDE-77302942!b-pb-sasl-quonix.pobox.com
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest maintenance release Git 1.7.10.3 is now available at
the usual places.

The release tarballs are found at:

    http://code.google.com/p/git-core/downloads/list

and their SHA-1 checksums are:

172c6ad5a55276213c5e40b83a4c270f6f931b3e  git-1.7.10.3.tar.gz
c75f9dd4e5157b0c0cb53d67a599b1b038b9c708  git-htmldocs-1.7.10.3.tar.gz
4ae4f9f0f0dc42ad5cb2de309049c953841bc413  git-manpages-1.7.10.3.tar.gz

Also the following public repositories all have a copy of the v1.7.10.3
tag and the maint branch that the tag points at:

  url = git://repo.or.cz/alt-git.git
  url = https://code.google.com/p/git-core/
  url = git://git.sourceforge.jp/gitroot/git-core/git.git
  url = git://git-core.git.sourceforge.net/gitroot/git-core/git-core
  url = https://github.com/gitster/git


Git v1.7.10.3 Release Notes
===========================

Fixes since v1.7.10.2
---------------------

 * The message file for German translation has been updated a bit.

 * Running "git checkout" on an unborn branch used to corrupt HEAD.

 * When checking out another commit from an already detached state, we
   used to report all commits that are not reachable from any of the
   refs as lossage, but some of them might be reachable from the new
   HEAD, and there is no need to warn about them.

 * Some time ago, "git clone" lost the progress output for its
   "checkout" phase; when run without any "--quiet" option, it should
   give progress to the lengthy operation.

 * The directory path used in "git diff --no-index", when it recurses
   down, was broken with a recent update after v1.7.10.1 release.

 * "log -z --pretty=tformat:..." did not terminate each record with
   NUL.  The fix is not entirely correct when the output also asks for
   --patch and/or --stat, though.

 * The DWIM behaviour for "log --pretty=format:%gd -g" was somewhat
   broken and gave undue precedence to configured log.date, causing
   "git stash list" to show "stash@{time stamp string}".

 * "git status --porcelain" ignored "--branch" option by mistake.  The
   output for "git status --branch -z" was also incorrect and did not
   terminate the record for the current branch name with NUL as asked.

 * When a submodule repository uses alternate object store mechanism,
   some commands that were started from the superproject did not
   notice it and failed with "No such object" errors.  The subcommands
   of "git submodule" command that recursed into the submodule in a
   separate process were OK; only the ones that cheated and peeked
   directly into the submodule's repository from the primary process
   were affected.

Also contains minor fixes and documentation updates.


----------------------------------------------------------------

Changes since v1.7.10.2 are as follows:

Bobby Powers (2):
      diff --no-index: reset temporary buffer lengths on directory iteration
      diff --no-index: don't leak buffers in queue_diff

Carlos Martín Nieto (1):
      pack-protocol: fix first-want separator in the examples

Erik Faye-Lund (2):
      clone: fix progress-regression
      checkout: do not corrupt HEAD on empty repo

Heiko Voigt (2):
      link to gitmodules page at the beginning of git-submodule documentation
      teach add_submodule_odb() to look for alternates

Jan Krüger (1):
      log-tree: use custom line terminator in line termination mode

Jeff King (10):
      docs: stop using asciidoc no-inline-literal
      t1411: add more selector index/date tests
      log: respect date_mode_explicit with --format:%gd
      reflog-walk: clean up "flag" field of commit_reflog struct
      reflog-walk: always make HEAD@{0} show indexed selectors
      commit: refactor option parsing
      status: refactor null_termination option
      status: fix null termination with "-b"
      status: respect "-b" for porcelain format
      osxkeychain: pull make config from top-level directory

Jens Lehmann (1):
      Consistently use "superproject" instead of "supermodule"

Jiang Xin (4):
      l10n: Update git.pot (1 new messages)
      l10n: zh_CN.po: translate 1 new message
      l10n: Update git.pot (3 new, 2 removed messages)
      l10n: zh_CN.po: translate 3 new messages

Johannes Sixt (3):
      t2020-checkout-detach: check for the number of orphaned commits
      checkout (detached): truncate list of orphaned commits at the new HEAD
      t3404: begin "exchange commits with -p" test with correct preconditions

Jonathan Nieder (1):
      config doc: remove confusion about relative GIT_DIR from FILES section

Junio C Hamano (5):
      log-tree: the previous one is still not quite right
      reflog-walk: tell explicit --date=default from not having --date at all
      Start preparing for 1.7.10.3
      Update draft release notes to 1.7.10.3
      Git 1.7.10.3

Linus Torvalds (1):
      fmt-merge-message: add empty line between tag and signature verification

Ralf Thielow (7):
      l10n: add new members to German translation team
      l10n: de.po: translate "track" as "beobachten"
      l10n: de.po: translate "remote" as "extern"
      l10n: de.po: collection of improvements
      l10n: de.po: unify translation of "ahead" and "behind"
      l10n: de.po: translate one new message
      l10n: de.po: translate 3 new messages

Thomas Rast (4):
      l10n: de.po: translate "bare" as "bloß"
      l10n: de.po: hopefully uncontroversial fixes
      l10n: de.po: translate "bad" as "ungültig" ("invalid")
      l10n: de.po: collection of suggestions

