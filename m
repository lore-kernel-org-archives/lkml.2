Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111Ab1AaPov (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 10:44:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55439 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756063Ab1AaPou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 10:44:50 -0500
Date: Mon, 31 Jan 2011 16:36:53 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Daniel Lezcano <daniel.lezcano@free.fr>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
        ebiederm@xmission.com, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, clg@fr.ibm.com
Subject: Re: [PATCH 4/4] pidns: Use task_active_pid_ns where appropriate
Message-ID: <20110131153653.GA32392@redhat.com>
References: <1296469525-30111-1-git-send-email-daniel.lezcano@free.fr> <1296469525-30111-5-git-send-email-daniel.lezcano@free.fr> <AANLkTikjcou-0b4NejpY66qXeZuzsC-M+oNTyHk=OE-Z@mail.gmail.com> <4D46CB9E.1090802@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D46CB9E.1090802@free.fr>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31, Daniel Lezcano wrote:
>
> On 01/31/2011 12:26 PM, Alexey Dobriyan wrote:
>>
>> This task_active_pid_ns() is misnamed(?) because it does matter only
>> for dead tasks?
>
> Actually this function is later used, for the unshare, to get the pid_ns
> of a specific task, not the current one.

Well, it is already used to get the pid_ns of !current task.

> http://kerneltrap.org/mailarchive/linux-kernel/2010/6/20/4585095

The actual need for this change is that you are going to complicate
the things so that current->proxy->pid_ns != task_active_pid_ns().
This makes me cry ;)

Please don't forget, this patch is buggy, iirc...

Oleg.

