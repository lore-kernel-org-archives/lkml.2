Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696Ab1BAKHO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 05:07:14 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:41212 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717Ab1BAKHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 05:07:12 -0500
Message-ID: <4D47DB46.70203@free.fr>
Date: Tue, 01 Feb 2011 11:07:02 +0100
From: Daniel Lezcano <daniel.lezcano@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
        ebiederm@xmission.com, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, clg@fr.ibm.com
Subject: Re: [PATCH 4/4] pidns: Use task_active_pid_ns where appropriate
References: <1296469525-30111-1-git-send-email-daniel.lezcano@free.fr> <1296469525-30111-5-git-send-email-daniel.lezcano@free.fr> <AANLkTikjcou-0b4NejpY66qXeZuzsC-M+oNTyHk=OE-Z@mail.gmail.com> <4D46CB9E.1090802@free.fr> <20110131153653.GA32392@redhat.com>
In-Reply-To: <20110131153653.GA32392@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2011 04:36 PM, Oleg Nesterov wrote:
> On 01/31, Daniel Lezcano wrote:
>> On 01/31/2011 12:26 PM, Alexey Dobriyan wrote:
>>> This task_active_pid_ns() is misnamed(?) because it does matter only
>>> for dead tasks?
>> Actually this function is later used, for the unshare, to get the pid_ns
>> of a specific task, not the current one.
> Well, it is already used to get the pid_ns of !current task.
>
>> http://kerneltrap.org/mailarchive/linux-kernel/2010/6/20/4585095
> The actual need for this change is that you are going to complicate
> the things so that current->proxy->pid_ns != task_active_pid_ns().
> This makes me cry ;)

Mmh, ok that makes sense.

> Please don't forget, this patch is buggy, iirc...

Ok, I will resend the cleanup patchset without this patch.
