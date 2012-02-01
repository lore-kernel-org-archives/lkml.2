Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272Ab2BABfJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 20:35:09 -0500
Received: from seven.medozas.de ([188.40.89.202]:59408 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752448Ab2BABfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 20:35:08 -0500
Date: Wed, 1 Feb 2012 02:35:06 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] treewide: fix memory corruptions when TASK_COMM_LEN
 != 16
In-Reply-To: <20120131172334.7f26f164.akpm@linux-foundation.org>
Message-ID: <alpine.LNX.2.01.1202010224510.29848@frira.zrqbmnf.qr>
References: <1327183785-27023-1-git-send-email-jengelh@medozas.de> <20120124135443.2772d455.akpm@linux-foundation.org> <alpine.LNX.2.01.1201250121260.20692@frira.zrqbmnf.qr> <20120131172334.7f26f164.akpm@linux-foundation.org>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wednesday 2012-02-01 02:23, Andrew Morton wrote:
>>
>> If there is a piece of kernel code that
>> assumes/requests that userspace use a 16-byte buffer (such as
>> cn_proc as mentioned), then it should use a file-level define or
>> something with a comment above it that this is a fixed user value.
>> 
>> I would therefore say that changing TASK_COMM_LEN is possible without 
>> breaking any userprogram.
>> 
>> (In other words, TASK_COMM_LEN can just remain what it is, and 
>> comm[TASK_COMM_LEN] in struct task_struct could be changed to 
>> e.g. comm[32]. Using sizeof(x.comm) also seems more proof in general.)
>
>Well yes, we could increase the size and provide new and better APIs
>for accessing it, while teaching the old APIs to truncate.  That might
>cause some problems for old-API-using userspace during the transition
>period, but I doubt if they would be large problems.

Did my patch not change the existing code sites using ->comm
to always copy at most min(userbufsize aka 16, sizeof(t->comm)) bytes,
thereby keeping the promise to userspace while at the same time
making TASK_COMM_LEN's value freely choosable?
