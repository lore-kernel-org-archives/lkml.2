Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787Ab2EaKdz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 06:33:55 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:41354 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751530Ab2EaKdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 06:33:52 -0400
Message-ID: <4FC74902.4070302@parallels.com>
Date: Thu, 31 May 2012 14:33:38 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Louis Rilling <louis.rilling@kerlabs.com>,
        Mike Galbraith <efault@gmx.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] pidns: find_new_reaper() can no longer switch to
 init_pid_ns.child_reaper
References: <20120530175745.GA19327@redhat.com> <20120530181429.GA19989@redhat.com> <20120530181515.GB20130@redhat.com>
In-Reply-To: <20120530181515.GB20130@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2012 10:15 PM, Oleg Nesterov wrote:
> find_new_reaper() changes pid_ns->child_reaper, see add0d4df
> "pid_ns: zap_pid_ns_processes: fix the ->child_reaper changing".
> 
> The original reason has gone away after the previous patch,
> ->children list must be empty after zap_pid_ns_processes().
> 
> However now we can not switch to init_pid_ns.child_reaper.
> __unhash_process() relies on the "->child_reaper == parent"
> check, but this check does not work if the last exiting task
> is also the child reaper.
> 
> As Eric sugested, we can change __unhash_process() to use the
> parent's pid_ns and remove this code.
> 
> Also, with this change we can move detach_pid(PIDTYPE_PID) back,
> where it was before the previous fix.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

Acked-by: Pavel Emelyanov <xemul@parallels.com>

