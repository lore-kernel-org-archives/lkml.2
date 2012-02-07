Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079Ab2BGGsN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 01:48:13 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48877 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070Ab2BGGsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 01:48:12 -0500
Date: Tue, 7 Feb 2012 10:48:09 +0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Frysinger <vapier@gentoo.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Richard Weinberger <richard@nod.at>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/8] Fixes for common mistakes w/ for_each_process and
 task->mm
Message-ID: <20120207064809.GA29061@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While working on lowmemorykiller driver, I stumbled upon several places
where we traverse the tasklist in an unsafe manner, plus there are a
few cases of unsafe access to task->mm.

Note that some patches were not tested (e.g. sh, blackfin), so please
take a closer look if there's silly mistakes. Also special attention
needed for patch 7/8 (UML specific).

Oleg,

For sysrq case I kept the force_sig() usage, this is because in sysrq
case I belive we do want to kill PID namespace init processes. If using
force_sig() is still a bad idea, I guess we should fix it somehow
else.

Thanks.

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
