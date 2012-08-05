Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301Ab2HEXQi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 19:16:38 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38266 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755207Ab2HEXQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 19:16:37 -0400
Message-ID: <501EFED2.1070901@jp.fujitsu.com>
Date: Mon, 06 Aug 2012 08:16:34 +0900
From: Seiichi Ikarashi <s.ikarashi@jp.fujitsu.com>
Organization: Fujitsu Limited
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:12.0) Gecko/20120420 Thunderbird/12.0
MIME-Version: 1.0
To: Manfred Spraul <manfred@colorfullife.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipc/sem.c: prevent ENOMEM in semop() w/ SEM_UNDO flag
References: <501BC8BE.6000405@jp.fujitsu.com> <501C0CB6.7070409@colorfullife.com>
In-Reply-To: <501C0CB6.7070409@colorfullife.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Manfred,

(2012-08-04 02:39), Manfred Spraul wrote:
> Hi Seiichi,
> 
> On 08/03/2012 02:49 PM, Seiichi Ikarashi wrote:
>> semop() with SEM_UNDO sem_flg can result in ENOMEM even after
>> succeeding semget() with large nsems.
> How large is nsems, what is the use case?
> Which kind of operations are performed?
> Only simple semop(,,1) calls?

A real case was as follows.
  semget(IPC_PRIVATE, 70000, IPC_CREAT | IPC_EXCL);
  sops[0].sem_num = 0;
  sops[0].sem_op  = 1;
  sops[0].sem_flg = SEM_UNDO;
  semop(semid, sops, 1);

> 
> <linux/sem.h> still documents ~8000 as the upper limit, I'm not sure if

Ah, I did not know it.

#define SEMMSL  250             /* <= 8 000 max num of semaphores per id */

Thanks,
Seiichi

