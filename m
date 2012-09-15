Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637Ab2IOGMR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 02:12:17 -0400
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:34353 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223Ab2IOGMP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 02:12:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:date:message-id:mime-version:content-type; q=dns; s=
	sasl; b=AOb7RTdUbpZtdRlzzsUnpZMwdE5nF/v+tN9JfnnCJ+Enco4e/o2QldRn
	GCLBlJKX2VvQ6IHJGduNEtfi1+9/a+3qUzDWCsq3QDz8H664PzWsnansjv2pDF+T
	cmZBJWw9NIeDN7RyVZ5JZdXhha6Fn3+OYEEoDbbQe2e/HfEYrQY=
From: Junio C Hamano <gitster@pobox.com>
To: git@vger.kernel.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [ANNOUNCE] Git v1.7.11.7
Date: Fri, 14 Sep 2012 23:12:10 -0700
Message-ID: <7v8vcb24sl.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 49ABC82C-FEFC-11E1-8267-18772E706CDE-77302942!b-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A maintenance release Git v1.7.11.7 is now available at the
usual places.

The release tarballs are found at:

    http://code.google.com/p/git-core/downloads/list

and their SHA-1 checksums are:

30c7aafaa31002ca52bc45dbd0908e63b00015dd  git-1.7.11.7.tar.gz
bdcd5009498bc961757915dae30f5fefd6435c59  git-htmldocs-1.7.11.7.tar.gz
9fb4bb051822168e41424524a4a325207f308507  git-manpages-1.7.11.7.tar.gz

Also the following public repositories all have a copy of the v1.7.11.7
tag and the maint-1.7.11 branch that the tag points at:

  url = git://repo.or.cz/alt-git.git
  url = https://code.google.com/p/git-core/
  url = git://git.sourceforge.jp/gitroot/git-core/git.git
  url = git://git-core.git.sourceforge.net/gitroot/git-core/git-core
  url = https://github.com/gitster/git

Git v1.7.11.7 Release Notes
===========================

Fixes since v1.7.11.6
---------------------

 * The synopsis said "checkout [-B branch]" to make it clear the
   branch name is a parameter to the option, but the heading for the
   option description was "-B::", not "-B branch::", making the
   documentation misleading.

 * Git ships with a fall-back regexp implementation for platforms with
   buggy regexp library, but it was easy for people to keep using their
   platform regexp.  A new test has been added to check this.

 * "git apply -p0" did not parse pathnames on "diff --git" line
   correctly.  This caused patches that had pathnames in no other
   places to be mistakenly rejected (most notably, binary patch that
   does not rename nor change mode).  Textual patches, renames or mode
   changes have preimage and postimage pathnames in different places
   in a form that can be parsed unambiguously and did not suffer from
   this problem.

 * After "gitk" showed the contents of a tag, neither "Reread
   references" nor "Reload" did not update what is shown as the
   contents of it, when the user overwrote the tag with "git tag -f".

 * "git for-each-ref" did not currectly support more than one --sort
   option.

 * "git log .." errored out saying it is both rev range and a path
   when there is no disambiguating "--" is on the command line.
   Update the command line parser to interpret ".." as a path in such
   a case.

 * Pushing to smart HTTP server with recent Git fails without having
   the username in the URL to force authentication, if the server is
   configured to allow GET anonymously, while requiring authentication
   for POST.

 * "git show --format='%ci'" did not give timestamp correctly for
   commits created without human readable name on "committer" line.
   (merge e27ddb6 jc/maint-ident-missing-human-name later to maint).

 * "git show --quiet" ought to be a synonym for "git show -s", but
   wasn't.
