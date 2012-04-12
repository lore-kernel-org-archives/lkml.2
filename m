Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934235Ab2DLNWk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 09:22:40 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:44223 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933904Ab2DLNWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 09:22:38 -0400
Message-ID: <4F86D702.30209@gmail.com>
Date: Thu, 12 Apr 2012 21:22:10 +0800
From: Cong Wang <xiyou.wangcong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Cong Wang <xiyou.wangcong@gmail.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Alexey Dobriyan <adobriyan@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Vasiliy Kulikov <segoon@openwall.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 5/6] proc: use task_access_lock() instead of ptrace_may_access()
References: <1334123976-11681-1-git-send-email-xiyou.wangcong@gmail.com> <1334123976-11681-5-git-send-email-xiyou.wangcong@gmail.com>
In-Reply-To: <1334123976-11681-5-git-send-email-xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2012 01:59 PM, Cong Wang wrote:
> There are several places in fs/proc/base.c still use ptrace_may_access()
> directly to check the permission, actually this just gets a snapshot of
> the permission, nothing prevents the target task from raising the priviledges
> itself, it is better to use task_access_lock() for these places, to hold
> the priviledges.
>
Hi, Andrew,

Please drop this patch, it introduces a deadlock when execve() a 
/proc/<pid>/exec file, and it is not a big improvement nor fixes any 
bugs, so let's just drop this one.

Thanks!
