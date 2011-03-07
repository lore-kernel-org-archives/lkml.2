Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601Ab1CGXUV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 18:20:21 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35537 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755204Ab1CGXUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 18:20:19 -0500
Date: Mon, 7 Mar 2011 15:19:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kirill A. Shutsemov" <kirill@shutemov.name>
Cc: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, jacob.jun.pan@linux.intel.com,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
        Matt Helsley <matthltc@us.ibm.com>, linux-api@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH, v8 3/3] cgroups: introduce timer slack controller
Message-Id: <20110307151932.4d73c3ff.akpm@linux-foundation.org>
In-Reply-To: <1299161947-9903-4-git-send-email-kirill@shutemov.name>
References: <1299161947-9903-1-git-send-email-kirill@shutemov.name>
	<1299161947-9903-4-git-send-email-kirill@shutemov.name>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  3 Mar 2011 16:19:07 +0200
"Kirill A. Shutsemov" <kirill@shutemov.name> wrote:

> --- /dev/null
> +++ b/Documentation/cgroups/timer_slack.txt
> @@ -0,0 +1,64 @@
> +Timer Slack Controller
> +=====================
> +
> +Overview
> +--------
> +
> +Every task_struct has timer_slack_ns value. This value uses to round up
> +poll() and select() timeout values. This feature can be useful in
> +mobile environment where combined wakeups are desired.
> +
> +cgroup subsys "timer_slack" implements timer slack controller. It
> +provides a way to set minimal timer slack value for a group of tasks.
> +If a task belongs to a cgroup with minimal timer slack value higher than
> +task's value, cgroup's value will be applied.

All I'm seeing here is a bunch of code, but no reason has been provided
for merging any of it.

Why do we need a cgroup for this as opposed to (say) inheritance over
fork(), or a system-wide knob, or a per-process/threadgroup knob, or
just leaving the existing code as-is?  Presumably you felt that a
cgroup approach is better for manageability, but you didn't tell us
about this and you didn't explore alternative ways of solving the
problem-which-you-didn't-describe.


Carefully describing the proposed feature and the overall value which
it brings does help to grease the wheels and is worth spending some
time over, please.  Don't expect the entire audience to be mind-readers!
