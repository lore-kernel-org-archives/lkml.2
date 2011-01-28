Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138Ab1A1JxT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 04:53:19 -0500
Received: from lo.gmane.org ([80.91.229.12]:37370 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982Ab1A1JxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 04:53:18 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: WANG Cong <xiyou.wangcong@gmail.com>
Subject: Re: Syslog-NG Fails as of Kernel 2.6.38-rc1
Date: Fri, 28 Jan 2011 09:53:04 +0000 (UTC)
Message-ID: <ihu3lv$921$4@dough.gmane.org>
References: <513567.89196.qm@web55903.mail.re3.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 60.247.97.98
User-Agent: Pan/0.133 (House of Butterflies)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Jan 2011 04:51:10 -0800, Eugene Markow wrote:

> The following appears in dmesg from kernels 2.6.38-rc1 to
> 2.6.38-rc2-git5 (Not an issue in 2.6.37 stable):
> 
> ----------
> WARNING: at kernel/printk.c:430 do_syslog+0xeb/0x5e0()

Looks like syslog-ng passes a wrong type to sys_syslog():

        if (type == SYSLOG_ACTION_OPEN || !from_file) {
                if (dmesg_restrict && !capable(CAP_SYSLOG))
                        goto warn;

                if ((type != SYSLOG_ACTION_READ_ALL &&
                     type != SYSLOG_ACTION_SIZE_BUFFER) &&
                    !capable(CAP_SYSLOG))
                        goto warn;
        }

...
> 
> Furthermore, during the bootup process, I'm getting:
> 
> 
> ----------
> ::Starting Syslg-NG            [BUSY] Error opening file for reading:
> filename '/proc/kmsg', error='Operation not permitted (1)'
> Error initializing source driver: source='src', id='src#2' Error
> initializing message pipline;
>                     [FAIL]


Hmm, it writes /proc/kmsg... I will look at the code later.


