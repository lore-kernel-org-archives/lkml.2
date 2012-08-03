Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746Ab2HCRjL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 13:39:11 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49726 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483Ab2HCRjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 13:39:08 -0400
Message-ID: <501C0CB6.7070409@colorfullife.com>
Date: Fri, 03 Aug 2012 19:39:02 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Seiichi Ikarashi <s.ikarashi@jp.fujitsu.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipc/sem.c: prevent ENOMEM in semop() w/ SEM_UNDO flag
References: <501BC8BE.6000405@jp.fujitsu.com>
In-Reply-To: <501BC8BE.6000405@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Seiichi,

On 08/03/2012 02:49 PM, Seiichi Ikarashi wrote:
> semop() with SEM_UNDO sem_flg can result in ENOMEM even after
> succeeding semget() with large nsems.
How large is nsems, what is the use case?
Which kind of operations are performed?
Only simple semop(,,1) calls?

<linux/sem.h> still documents ~8000 as the upper limit, I'm not sure if
there are other codepaths that might fail as well.
If all are fixed, then the documentation should be updated as well.

>  This is because
> semop() uses kzalloc() via find_alloc_undo() though
> semget() uses vmalloc() via ipc_rcu_alloc().
> This patch makes semop() be able to use vmalloc() via ipc_alloc().
>
> Signed-off-by: Seiichi Ikarashi <s.ikarashi@jp.fujitsu.com>

--
Manfred
