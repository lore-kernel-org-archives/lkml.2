Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921Ab1DRQso (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 12:48:44 -0400
Received: from diomedes.noc.ntua.gr ([147.102.222.220]:49496 "EHLO
	diomedes.noc.ntua.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297Ab1DRQsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 12:48:38 -0400
X-Greylist: delayed 553 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Apr 2011 12:48:37 EDT
From: Stratos Psomadakis <psomas@cslab.ece.ntua.gr>
To: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 0/1] ppc64: fix build error when compiling with gcc-4.6.0
Date: Mon, 18 Apr 2011 19:38:58 +0300
Message-Id: <1303144739-4407-1-git-send-email-psomas@cslab.ece.ntua.gr>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (diomedes.noc.ntua.gr [147.102.222.220]); Mon, 18 Apr 2011 19:39:14 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The build error was reported at the Gentoo Bugzilla [1].

When compiling with gcc-4.6.0, a build error occurs: 
"variable ‘old’ set but not used [-Werror=unused-but-set-variable]
cc1: all warnings being treated as errors"

This patch removes the unnecessary assignments to the variable, which cause
the compiler warning (used but not set), and build failure, and removes it
completely.

I think it's ok to do that, since the variable wasn't actually used anywhere
inside those two functions that caused the warning. Right?

[1] https://bugs.gentoo.org/show_bug.cgi?id=363935
