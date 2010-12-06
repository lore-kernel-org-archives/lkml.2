Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab0LFP2z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 10:28:55 -0500
Received: from a-pb-sasl-sd.pobox.com ([64.74.157.62]:47435 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837Ab0LFP2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 10:28:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=to:subject:from
	:date:in-reply-to:message-id:references:mime-version
	:content-type; q=dns; s=sasl; b=Es4Z9Nu8wWqffVSkCab86eqUGgIDbDXT
	XoDyaiU6piQ6G0k1tjUD2Ncw52wMGqMc59yIMoKyiQgmxHLO/LoALqFaQxyzGZpQ
	U9OYCsHg60AY49KeMKKNQY23v8YdI3goM+ZSd7A23+yIQ4h5fMO80CkGKif5brmv
	Dxq1ODtzOSs=
To: git@vger.kernel.org
Subject: [ANNOUNCE] Git 1.7.3.3
From: Junio C Hamano <gitster@pobox.com>
Date: Mon, 06 Dec 2010 07:28:13 -0800
In-Reply-To: <7vk4jrppeu.fsf@alter.siamese.dyndns.org> (Junio C. Hamano's
 message of "Thu\, 02 Dec 2010 18\:21\:13 -0800")
Message-ID: <7vy682syya.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
References: <7vk4jrppeu.fsf@alter.siamese.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 910969DA-014D-11E0-8469-C4BE9B774584-77302942!a-pb-sasl-sd.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest maintenance release Git 1.7.3.3 is available at the
usual places:

  http://www.kernel.org/pub/software/scm/git/

  git-1.7.3.3.tar.{gz,bz2}			(source tarball)
  git-htmldocs-1.7.3.3.tar.{gz,bz2}		(preformatted docs)
  git-manpages-1.7.3.3.tar.{gz,bz2}		(preformatted docs)

The RPM binary packages for a few architectures are found in:

  RPMS/$arch/git-*-1.7.3.3-1.fc11.$arch.rpm	(RPM)



Git v1.7.3.3 Release Notes
==========================

In addition to the usual fixes, this release also includes support for
the new "add.ignoreErrors" name given to the existing "add.ignore-errors"
configuration variable.

The next version, Git 1.7.4, and future versions, will support both
old and incorrect name and the new corrected name, but without this
backport, users who want to use the new name "add.ignoreErrors" in
their repositories cannot use older versions of Git.

Fixes since v1.7.3.2
--------------------

 * "git apply" segfaulted when a bogus input is fed to it.

 * Running "git cherry-pick --ff" on a root commit segfaulted.

 * "diff", "blame" and friends incorrectly applied textconv filters to
   symlinks.

 * Highlighting of whitespace breakage in "diff" output was showing
   incorrect amount of whitespaces when blank-at-eol is set and the line
   consisted only of whitespaces and a TAB.

 * "diff" was overly inefficient when trying to find the line to use for
   the function header (i.e. equivalent to --show-c-function of GNU diff).

 * "git imap-send" depends on libcrypto but our build rule relied on the
   linker to implicitly link it via libssl, which was wrong.

 * "git merge-file" can be called from within a subdirectory now.

 * "git repack -f" expanded and recompressed non-delta objects in the
   existing pack, which was wasteful.  Use new "-F" option if you really
   want to (e.g. when changing the pack.compression level).

 * "git rev-list --format="...%x00..." incorrectly chopped its output
   at NUL.

 * "git send-email" did not correctly remove duplicate mail addresses from
   the Cc: header that appear on the To: header.

 * The completion script (in contrib/completion) ignored lightweight tags
   in __git_ps1().

 * "git-blame" mode (in contrib/emacs) didn't say (require 'format-spec)
   even though it depends on it; it didn't work with Emacs 22 or older
   unless Gnus is used.

 * "git-p4" (in contrib/) did not correctly handle deleted files.

Other minor fixes and documentation updates are also included.
