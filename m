Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562Ab2JHULc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 16:11:32 -0400
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:59676 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752837Ab2JHUL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 16:11:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:date:message-id:mime-version:content-type; q=dns; s=
	sasl; b=BFlO2nZS32s5bk7uX9cRPNeeC7qzbDlRssljh7F4HHyjSSRnRbeXUmtd
	wfO3B2zI1z0uif6GHy2iyLsab3MuDrXsZzzjxm11jnS9l5AK/1Fpvt9h+/z0KbFL
	mY0dfHtlADFCa1lIeK1va0g/RtX6AoZIws5kBGfLy16nPGx7CpQ=
From: Junio C Hamano <gitster@pobox.com>
To: git@vger.kernel.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [ANNOUNCE] Git v1.7.12.3
Date: Mon, 08 Oct 2012 12:53:23 -0700
Message-ID: <7vmwzwk9le.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 57449A32-1184-11E2-8534-BB652E706CDE-77302942!b-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest maintenance release Git v1.7.12.3 is now available at
the usual places.

The release tarballs are found at:

    http://code.google.com/p/git-core/downloads/list

and their SHA-1 checksums are:

a071f03f6aab76b283828db1fdedbedb90085eb5  git-1.7.12.3.tar.gz
6f976c27aab7250f1a35b2b002ac7a07c3266cf4  git-htmldocs-1.7.12.3.tar.gz
49584f0b72e4a13f9a4df771bbde9cf70f25d317  git-manpages-1.7.12.3.tar.gz

Also the following public repositories all have a copy of the v1.7.12.3
tag and the maint branch that the tag points at:

  url = git://repo.or.cz/alt-git.git
  url = https://code.google.com/p/git-core/
  url = git://git.sourceforge.jp/gitroot/git-core/git.git
  url = git://git-core.git.sourceforge.net/gitroot/git-core/git-core
  url = https://github.com/gitster/git

Git 1.7.12.3 Release Notes
==========================

Fixes since v1.7.12.2
---------------------

 * "git am" mishandled a patch attached as application/octet-stream
   (e.g. not text/*); Content-Transfer-Encoding (e.g. base64) was not
   honored correctly.

 * It was unclear in the documentation for "git blame" that it is
   unnecessary for users to use the "--follow" option.

 * A repository created with "git clone --single" had its fetch
   refspecs set up just like a clone without "--single", leading the
   subsequent "git fetch" to slurp all the other branches, defeating
   the whole point of specifying "only this branch".

 * "git fetch" over http had an old workaround for an unlikely server
   misconfiguration; it turns out that this hurts debuggability of the
   configuration in general, and has been reverted.

 * "git fetch" over http advertised that it supports "deflate", which
   is much less common, and did not advertise the more common "gzip" on
   its Accept-Encoding header.

 * "git receive-pack" (the counterpart to "git push") did not give
   progress output while processing objects it received to the puser
   when run over the smart-http protocol.

 * "git status" honored the ignore=dirty settings in .gitmodules but
   "git commit" didn't.

Also contains a handful of documentation updates.

----------------------------------------------------------------

Changes since v1.7.12.2 are as follows:

Jeff King (3):
      receive-pack: redirect unpack-objects stdout to /dev/null
      receive-pack: send pack-processing stderr over sideband
      receive-pack: drop "n/a" on unpacker errors

Junio C Hamano (3):
      git blame: document that it always follows origin across whole-file renames
      Start preparing for 1.7.12.3
      Git 1.7.12.3

Linus Torvalds (1):
      mailinfo: don't require "text" mime type for attachments

Orgad Shaneh (1):
      commit: pay attention to submodule.$name.ignore in .gitmodules

Peter Krefting (1):
      l10n: Fix to Swedish translation

Ralf Thielow (1):
      clone --single: limit the fetch refspec to fetched branch

Ramkumar Ramachandra (1):
      submodule: if $command was not matched, don't parse other args

Shawn O. Pearce (2):
      Revert "retry request without query when info/refs?query fails"
      Enable info/refs gzip decompression in HTTP client

