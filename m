Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab2BACPx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 21:15:53 -0500
Received: from seven.medozas.de ([188.40.89.202]:59664 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752987Ab2BACPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 21:15:52 -0500
Date: Wed, 1 Feb 2012 03:15:50 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] treewide: fix memory corruptions when TASK_COMM_LEN
 != 16
In-Reply-To: <20120131174914.8ce5291d.akpm@linux-foundation.org>
Message-ID: <alpine.LNX.2.01.1202010257240.29848@frira.zrqbmnf.qr>
References: <1327183785-27023-1-git-send-email-jengelh@medozas.de> <20120124135443.2772d455.akpm@linux-foundation.org> <alpine.LNX.2.01.1201250121260.20692@frira.zrqbmnf.qr> <20120131172334.7f26f164.akpm@linux-foundation.org> <alpine.LNX.2.01.1202010224510.29848@frira.zrqbmnf.qr>
 <20120131174914.8ce5291d.akpm@linux-foundation.org>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wednesday 2012-02-01 02:49, Andrew Morton wrote:
>> 
>> Did my patch not change the existing code sites using ->comm
>> to always copy at most min(userbufsize aka 16, sizeof(t->comm)) bytes,
>> thereby keeping the promise to userspace while at the same time
>> making TASK_COMM_LEN's value freely choosable?
>
>That change is pretty pointless as long as we don't provide APIs to let
>userspace access the expanded size.  And I've explained why we cannot
>alter the existing APIs.

Ah yes, indeed. My reason for augmenting the size of t->comm was so
that `ps afx` could show a more complete name of certain kernel
threads' names. In this case, the kernel delivers the name via
procfs via seq_printf("%s, t->comm), as do a few debug statements
in the fashion of pr_debug("%s/%u ate my CPU", t->comm, t->pid).
So maybe it was not /completely/ pointless.
