Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632Ab1AGH6i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 02:58:38 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:28802 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752506Ab1AGH6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 02:58:37 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAJJWJk15LcNW/2dsb2JhbACkJHS8OoVMBIUj
Date: Fri, 7 Jan 2011 18:58:31 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [announce] vfs-scale git tree update
Message-ID: <20110107075831.GA14915@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Git tree is here:
  
  git://git.kernel.org/pub/scm/linux/kernel/git/npiggin/linux-npiggin.git
  
Branch is: vfs-scale-working

Head is: b3e19d924b6eaf2ca7d22cba99a517c5171007b6

Changes since last posting:
* Implemented Linus' suggestions:
  - Switch the filesystem methods in one hit rather than having _rcu
    variants. This avoids a lot of cruft from core code.
  - Implement filesystem rcu-walk aware conversions in seperate patches
    after the APIs are changed, making bisectability better.
  - Change dentry_memcmp to dentry_cmp
  - Rework the way ->d_revalidate is handled to be simpler.

* Fixed configfs bug caused by switching d_op on live dentry.

* Leave d_revalidate filesystem changes out for now. The sysfs one
  in particular seems to have been causing a funny regression.

* Bit more tweaking of changelogs documentation and comments.

* Passes ltp, xfstests, dbench stressing over nfs, and some of my own
  racer tests on a couple of filesystems. Needs wider testing.

