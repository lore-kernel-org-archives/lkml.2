Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406Ab1JWL0a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 07:26:30 -0400
Received: from mailq1.tnnet.fi ([217.112.240.127]:45222 "EHLO mailq1.tnnet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754586Ab1JWL03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 07:26:29 -0400
X-Greylist: delayed 543 seconds by postgrey-1.27 at vger.kernel.org; Sun, 23 Oct 2011 07:26:29 EDT
Message-ID: <4EA3F7C0.24E469C5@users.sourceforge.net>
Date: Sun, 23 Oct 2011 14:17:20 +0300
From: Jari Ruusu <jariruusu@users.sourceforge.net>
To: Greg Kroah-Hartman <greg@kroah.com>
CC: linux-kernel@vger.kernel.org
Subject: kernel.org tarball/patch signature files
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed that patch-3.0.7.sign is a detached signature file for
DECOMPRESSED patch-3.0.7.{bz2,gz,xz}. Maybe this is not the best possible
way to sign compressed tarballs/patches. This is because it places hell of
lot of trust on quality/security of decompressor implementation.
Historically decompressor implementations have had bugs and security flaws.
It is stupid to assume that there won't be any more of them.

Wrong order to verify compressed tarball/patch:

(1) Feed potentially maliciously formatted data to decompressor, and exploit
    any undiscovered/unpatched vulnerability in decompressor implementation.
(2) Verify decompressed output.

Much better order would be:

(1) Verify compressed data.
(2) Feed trusted data to decompressor.

So, would it be possible to have multiple signature files like this? Please.

patch-3.X.Y.bz2
patch-3.X.Y.bz2.sign
patch-3.X.Y.gz
patch-3.X.Y.gz.sign
patch-3.X.Y.xz
patch-3.X.Y.xz.sign

-- 
Jari Ruusu  1024R/3A220F51 5B 4B F9 BB D3 3F 52 E9  DB 1D EB E3 24 0E A9 DD
