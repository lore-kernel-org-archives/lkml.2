Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195Ab0DEC7e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 22:59:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:40881 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754035Ab0DEC72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 22:59:28 -0400
Message-ID: <4BB951FE.3090402@kernel.org>
Date: Mon, 05 Apr 2010 11:59:10 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: [GIT PULL] percpu fixes for 2.6.34-rc3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 05 Apr 2010 02:59:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Please pull from the following percpu branch.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-linus

lockdep was hardcoding conditions to determine whether an address
belongs to percpu area.  With recent percpu allocator changes, the
logic no longer is correct triggering bogus warning messages.  The
above branch implements is_kernel/module_percpu_address() and makes
lockdep use them instead.

Has been tested in linux-next and pulls cleanly into
db217dece3003df0841bacf9556b5c06aa097dae.

Thanks.

Randy Dunlap (1):
      module: add stub for is_module_percpu_address

Tejun Heo (2):
      module: encapsulate percpu handling better and record percpu_size
      percpu, module: implement and use is_kernel/module_percpu_address()

 include/linux/module.h |   11 +++++-
 include/linux/percpu.h |    7 +++
 kernel/lockdep.c       |   21 ++-------
 kernel/module.c        |  104 +++++++++++++++++++++++++++++++++--------------
 mm/percpu.c            |   26 ++++++++++++
 5 files changed, 121 insertions(+), 48 deletions(-)

--
tejun
