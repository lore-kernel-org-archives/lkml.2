Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494Ab0IHCfM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 22:35:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3674 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756403Ab0IHCfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 22:35:09 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, oss-security@lists.openwall.com,
        Solar Designer <solar@openwall.com>,
        Kees Cook <kees.cook@canonical.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Neil Horman <nhorman@tuxdriver.com>, linux-fsdevel@vger.kernel.org,
        pageexec@freemail.hu,
        "Brad Spengler <spender@grsecurity.net> Eugene Teo" 
	<eugene@redhat.com>
X-Fcc: ~/Mail/linus
Subject: [PATCH 0/3] execve argument-copying fixes
In-Reply-To: Roland McGrath's message of  Monday, 30 August 2010 03:06:16 -0700 <20100830100616.78971400D9@magilla.sf.frob.com>
References: <20100827220258.GF4703@outflux.net>
	<20100830005648.431B7400D9@magilla.sf.frob.com>
	<20100830032331.GA22773@openwall.com>
	<20100830100616.78971400D9@magilla.sf.frob.com>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20100908023417.8B055401AF@magilla.sf.frob.com>
Date: Tue,  7 Sep 2010 19:34:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is my take on parts of the execve large arguments copying issues
that Kees posted about, and Brad and others have been discussing.
I've only looked at the narrow area of the argument copying code
itself.  I think these are good and necessary fixes.  But I'm not
addressing the whole OOM killer/mm accounting issue, which also needs
to be fixed (and I have the impression others are already looking into that).

The following changes since commit d56557af19867edb8c0e96f8e26399698a08857f:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 (2010-09-07 16:00:17 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frob/linux-2.6-roland.git topic/exec-fixes

Roland McGrath (3):
      setup_arg_pages: diagnose excessive argument size
      execve: improve interactivity with large arguments
      execve: make responsive to SIGKILL with large arguments

 fs/exec.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)


Thanks,
Roland
