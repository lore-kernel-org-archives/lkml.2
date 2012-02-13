Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176Ab2BMHeV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 02:34:21 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:42616 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752792Ab2BMHeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 02:34:20 -0500
MIME-Version: 1.0
Date: Mon, 13 Feb 2012 15:34:19 +0800
Message-ID: <CANudz+t_yXA621maPO+Cn5hGtsyL-ebn2hzFv+2XxOA9KyL2Fw@mail.gmail.com>
Subject: some questions about container_of and user_struct
From: loody <miloody@gmail.com>
To: kernelnewbies@kernelnewbies.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi all:
I add below function in free_uid to get which task try to free user_struct

struct task_struct *p;
struct cred *c;
c = container_of(up,struct cred, user);
p = container_of(c,struct task_struct,real_cred);
printk("%s user %p, cred->user = %p p->pid = %d\n",__func__,up, c->user,p->pid);

but p->pid is always 0.
I think it is wrong for me to get cred and task by using container_of.

1. from kernel definition below, is it ok that member is pointer?
#define container_of(ptr, type, member)

2. is there already exist macros or functions I can use for #1 above?

3. what is user_struct used for? When and under what circumstances
kernel will try to release it.

4. since user_struct is allocated by kmem_cache_zalloc, is there api
or tool I can monitor it?

Thanks for your help,
