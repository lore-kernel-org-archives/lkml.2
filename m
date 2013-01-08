Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751376Ab3AHG3L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 01:29:11 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:43595 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836Ab3AHG3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 01:29:08 -0500
Message-ID: <50EBBC9C.7060909@huawei.com>
Date: Tue, 8 Jan 2013 14:28:44 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Greg Thelen <gthelen@google.com>
CC: Tejun Heo <tj@kernel.org>, <containers@lists.linux-foundation.org>,
        <cgroups@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] cgroups: fix cgroup_event_listener error handling
References: <1357333518-28899-1-git-send-email-gthelen@google.com> <1357333518-28899-2-git-send-email-gthelen@google.com> <20130107174427.GM3926@htj.dyndns.org> <xr93a9sklqme.fsf@gthelen.mtv.corp.google.com>
In-Reply-To: <xr93a9sklqme.fsf@gthelen.mtv.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> cgroups: fix cgroup_event_listener error handling
> 
> The error handling in cgroup_event_listener.c did not correctly deal
> with either an error opening either <control_file> or
> cgroup.event_control.  Due to an uninitialized variable the program
> exit code was undefined if either of these opens failed.
> 
> This patch simplifies and corrects cgroup_event_listener.c error
> handling by:
> 1. using err*() rather than printf(),exit()
> 2. depending on process exit to close open files
> 
> With this patch failures always return non-zero error.
> 
> Signed-off-by: Greg Thelen <gthelen@google.com>

Acked-by: Li Zefan <lizefan@huawei.com>

> ---
>  tools/cgroup/cgroup_event_listener.c |   72 ++++++++++-----------------------
>  1 files changed, 22 insertions(+), 50 deletions(-)

