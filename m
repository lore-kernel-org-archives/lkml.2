Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021Ab0CPM4A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 08:56:00 -0400
Received: from tac.ki.iif.hu ([193.6.222.43]:45380 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470Ab0CPMz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 08:55:59 -0400
From: Ferenc Wagner <wferi@niif.hu>
To: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: CONFIG_MTD_DEBUG vs generic DEBUG support in kernel.h
Date: Tue, 16 Mar 2010 13:55:56 +0100
Message-ID: <878w9swhlv.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

include/linux/mtd/mtd.h contains the following snippet:

#ifdef CONFIG_MTD_DEBUG
#define DEBUG(n, args...)                               \
        do {                                            \
                if (n <= CONFIG_MTD_DEBUG_VERBOSE)      \
                        printk(KERN_INFO args);         \
        } while(0)

which conflicts with the generic debugging support in
include/linux/kernel.h:

#ifdef DEBUG
#define pr_devel(fmt, ...) \
        printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)

(that is, gcc emits redefinition warnings on modules which
#define DEBUG on their own and also include mtd.h)
Unfortunately, the DEBUG macro is used rather heavily under
drivers/mtd.  Should we resolve this somehow or is it better
to just live with it?

(Please keep me on Cc, I'm not subscribed.)
-- 
Thanks,
Feri.
