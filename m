Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825Ab1HII4F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 04:56:05 -0400
Received: from mga14.intel.com ([143.182.124.37]:53349 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751097Ab1HII4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 04:56:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,342,1309762800"; 
   d="scan'208";a="36598595"
Subject: Re: [PATCH ] printk: add module parameter console_suspend to
 control console_suspend_enabled
From: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Reply-To: yanmin_zhang@linux.intel.com
To: Dave Young <hidave.darkstar@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <CABqxG0dMcZUw9PVdfpz=V6d05=o+UcWKD_0PyoKir+4i08S+sA@mail.gmail.com>
References: <1312859345.1743.9.camel@ymzhang>
	 <CABqxG0dMcZUw9PVdfpz=V6d05=o+UcWKD_0PyoKir+4i08S+sA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: UMG
Date: Tue, 09 Aug 2011 16:55:09 +0800
Message-ID: <1312880109.1743.26.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-09 at 16:01 +0800, Dave Young wrote:
> On Tue, Aug 9, 2011 at 11:09 AM, Yanmin Zhang
> <yanmin_zhang@linux.intel.com> wrote:
> > We are enabling some power features on medfield. To test suspend-2-RAM
> > conveniently, we need turn on/off console_suspend_enabled frequently.
> >
> > Below patch adds a module parameter, so users could change it by:
> > /sys/module/printk/parameters/console_suspend_enabled
> 
> What about change name to no_console_suspend? Or it will be weird if
> boot kernel with both no_console_suspend and
> printk.console_suspend_enabled set.
Thanks for the comments. How about changing the name to console_suspend?
If changing it to no_console_suspend, we can't map the input to console_suspend_enabled
directly.

Below is the new patch.

---

We are enabling some power features on medfield. To test suspend-2-RAM
conveniently, we need turn on/off console_suspend_enabled frequently.

Below patch adds a module parameter, so users could change it by:
/sys/module/printk/parameters/console_suspend

Signed-off-by: Yanmin Zhang <yanmin_zhang@linux.intel.com>

---
 kernel/printk.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 37dff34..1decef6 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1106,6 +1106,8 @@ static int __init console_suspend_disable(char *str)
 	return 1;
 }
 __setup("no_console_suspend", console_suspend_disable);
+module_param_named(console_suspend, console_suspend_enabled,
+		bool, S_IRUGO | S_IWUSR);
 
 /**
  * suspend_console - suspend the console subsystem
-- 
1.7.1



