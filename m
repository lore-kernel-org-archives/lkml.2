Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529Ab0G2NfY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 09:35:24 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:60199 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757501Ab0G2NfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 09:35:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Vasiliy Kulikov <segooon@gmail.com>
Subject: Re: [bug] Fixing mutex_lock() under held spinlock
Date: Thu, 29 Jul 2010 15:34:56 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-8-generic; KDE/4.3.2; x86_64; ; )
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Nicolas Pitre <nico@fluxnic.net>,
        "Hans-Christian Egtvedt" <hans-christian.egtvedt@atmel.com>,
        Jiri Slaby <jslaby@suse.cz>, Stefani Seibold <stefani@seibold.net>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <20100729132223.GA19715@albatros>
In-Reply-To: <20100729132223.GA19715@albatros>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007291534.57188.arnd@arndb.de>
X-Provags-ID: V02:K0:KY832APIf5gufQxdmzoy5qmB/cy8jOepx5GEDxCdq0J
 9mnWUJNes+Aeq2JxM18/P+z0GJRN955fIhpnguKTg2NVPH6mUp
 m46u1msixcO6Bmrofi2sbTeKl69JhjP/AezUtJNozr+T/bEeH5
 aThEy7coDo/yDS1+3ObQJGuDrWO8TnGj9Bmzbb6AIPWyOS/Crj
 0zHwYRL0GtXAeiizrS3Wg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 July 2010, Vasiliy Kulikov wrote:
> I've found that cfi_cmdset and lpddr_cmds call mutex_lock() under held
> spinlock(). Maybe it was designed as a special locking scheme, so I
> don't try to fix it as I might create new complex locking problem.

No, it certainly looks like a bug and it seems to have been introduced by
http://linux.derkeiler.com/Mailing-Lists/Kernel/2010-03/msg02798.html

Back in March, Stefani wrote:
| I have analyzed this drivers and IMHO i don't think there will be used
| from irq or atomic contexts. There is no request interrupt and there are
| a lot msleep and add_wait_queues/schedule calls during holding the
| mutex, which are not very useful in a irq or atomic context. But i don't
| know the whole mtd stack. 

It seems you have missed at least two places. It should be possible to
fix this by turning shared->lock into a mutex as well.

	Arnd
