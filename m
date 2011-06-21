Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757Ab1FUOa4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 10:30:56 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:38853 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756747Ab1FUOay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 10:30:54 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 21 Jun 2011 16:30:40 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: <linux-kernel@vger.kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Subject: 3.0-rc3: new sparse noise on module_param_named: "error: Syntax
 error in unary expression"
Message-ID: <20110621163040.717fd5ed@stein>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

make C=1 in 3.0-rc3 but not in 2.6.39 complains:

  CHECK   drivers/firewire/ohci.c
drivers/firewire/ohci.c:308:1: error: Syntax error in unary expression
drivers/firewire/ohci.c:325:1: error: Syntax error in unary expression
  CC [M]  drivers/firewire/ohci.o
  CHECK   drivers/firewire/sbp2.c
drivers/firewire/sbp2.c:70:1: error: Syntax error in unary expression
drivers/firewire/sbp2.c:116:1: error: Syntax error in unary expression
  CC [M]  drivers/firewire/sbp2.o

These lines are the module_param_named lines of:

static int param_quirks;
module_param_named(quirks, param_quirks, int, 0644);
MODULE_PARM_DESC(quirks, "Chip quirks (default = 0"
[...]
static int param_debug;
module_param_named(debug, param_debug, int, 0644);
MODULE_PARM_DESC(debug, "Verbose logging (default = 0"
[...]

and

static int sbp2_param_exclusive_login = 1;
module_param_named(exclusive_login, sbp2_param_exclusive_login, bool, 0644);
MODULE_PARM_DESC(exclusive_login, "Exclusive login to sbp2 device "
[...]
static int sbp2_param_workarounds;
module_param_named(workarounds, sbp2_param_workarounds, int, 0644);
MODULE_PARM_DESC(workarounds, "Work around device bugs (default = 0"
[...]

Seen with an older version of sparse (perhaps 0.4.2) and the current from
sparse.git (0.4.3 plus 13 commmits).

There is only a single change to the kernel's include/linux/moduleparam.h
after v2.6.39, "module: reorder kparam_array to remove alignment padding
on 64 bit builds", and that one is apparently not the cause of the noise.

Puzzled,
-- 
Stefan Richter
-=====-==-== -==- =-=-=
http://arcgraph.de/sr/
