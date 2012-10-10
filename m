Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984Ab2JJPoR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 11:44:17 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51040 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220Ab2JJPoQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 11:44:16 -0400
From: Simon Klinkert <simon.klinkert@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: Meaningless load?
Date: Wed, 10 Oct 2012 17:44:11 +0200
Message-Id: <98F2F644-D531-42FE-B080-9561142D71C8@gmail.com>
Cc: mingo@redhat.com, peterz@infradead.org, Trond.Myklebust@netapp.com
To: LKML <linux-kernel@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
X-Mailer: Apple Mail (2.1499)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi folks,

I have a linux machine (2.6.32-220.7.1.el6.x86_64) with 500 processes 'working' on one nfs4 mountpoint. As I can see with ps and top, only one process is in the 'R' state and really working. The other 499 processes are in the 'D' state and probably waiting for this one process.

But now let's take a look at top one more time:

top - 14:33:57 up  4:27,  4 users,  load average: 501.16, 403.98, 205.52
Tasks: 766 total,   1 running, 765 sleeping,   0 stopped,   0 zombie
Cpu(s):  0.8%us,  2.1%sy,  0.0%ni, 94.9%id,  0.8%wa,  0.0%hi,  1.4%si,  0.0%st
Mem:  32872392k total,   768488k used, 32103904k free,    30608k buffers
Swap: 35094520k total,        0k used, 35094520k free,    97624k cached

Wow, a load of 501.16 and the CPUs are up to 97% idle.

I'm just wondering if the 'load' is really meaningful in this scenario. The machine is the whole time fully responsive and looks fine to me but maybe I didn't understand correctly what the load should mean. Is there any sensible interpretation of the load?

Thanks,
Simon