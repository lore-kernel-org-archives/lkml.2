Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048Ab0JGSlF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 14:41:05 -0400
Received: from cache.dhh-3.de ([62.89.186.8]:51701 "EHLO
	mx01.instandbesetzt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab0JGSlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 14:41:04 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Oct 2010 14:41:03 EDT
Date: Thu, 7 Oct 2010 20:34:19 +0200
From: Andreas Wiese <aw-lkml@meterriblecrew.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Ciaran McCreesh <ciaran.mccreesh@googlemail.com>
Subject: fallocate() on XFS clobbers S*ID-bits
Message-ID: <20101007183418.GC5621@incendiary.meterriblecrew.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-GPG-Key-ID: 0x08709798 (2048/4096bit RSA/RSA)
X-GPG-Fingerprint: F8F1 7E3C 2C24 5189 FC21  61E9 1F99 AEB4 0870 9798
X-Jabber-ID: aw@instandbesetzt.net (w/ GPG)
X-Home: https://www.instandbesetzt.net/
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I (with support from Cc'ed Ciaran) just noticed some odd behaviour with
fallocate() on XFS.  After open()ing some file and setting it S*ID via
fchmod(), S*ID bits vanish after calling fallocate() — as supposed to
for non-root users, but it also happens for root.

Is this intended behaviour or did we spot a bug here?

At least on ext2 it works as expected, thus I guess it's the latter one.

I'm running v2.6.35.7 vanilla-kernel, but diffing fs/xfs to master
doesn't seem to address this issue.

HAND & LG -- aw
-- 
This signature is intentionally left blank.
